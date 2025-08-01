# This test runs gitlab and performs the following tests:
# - Creating users
# - Pushing commits
#   - over the API
#   - over SSH
# - Creating Merge Requests and merging them
# - Opening and closing issues.
# - Downloading repository archives as tar.gz and tar.bz2
# Run with
# [nixpkgs]$ nix-build -A nixosTests.gitlab

{ pkgs, lib, ... }:

let
  inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  initialRootPassword = "notproduction";
  rootProjectId = "2";

  aliceUsername = "alice";
  aliceUserId = "2";
  alicePassword = "R5twyCgU0uXC71wT9BBTCqLs6HFZ7h3L";
  aliceProjectId = "1";
  aliceProjectName = "test-alice";

  bobUsername = "bob";
  bobUserId = "3";
  bobPassword = "XwkkBbl2SiIwabQzgcoaTbhsotijEEtF";
  bobProjectId = "2";
in
{
  name = "gitlab";
  meta.maintainers = with lib.maintainers; [
    globin
    yayayayaka
  ];

  nodes = {
    gitlab =
      { ... }:
      {
        imports = [ common/user-account.nix ];

        environment.systemPackages = with pkgs; [ git ];

        networking.hosts."127.0.0.1" = [
          "registry.localhost"
          "pages.localhost"
        ];
        virtualisation.memorySize = 6144;
        virtualisation.cores = 4;
        virtualisation.useNixStoreImage = true;
        virtualisation.writableStore = false;

        systemd.services.gitlab.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-workhorse.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitaly.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-sidekiq.serviceConfig.Restart = lib.mkForce "no";

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          virtualHosts = {
            localhost = {
              locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
            };
            "pages.localhost" = {
              locations."/".proxyPass = "http://localhost:8090";
            };
            "registry.localhost" = {
              locations."/".proxyPass = "http://localhost:4567";
            };
          };
        };

        services.openssh.enable = true;

        services.dovecot2 = {
          enable = true;
          enableImap = true;
        };

        systemd.services.gitlab-backup.environment.BACKUP = "dump";

        services.gitlab = {
          enable = true;
          databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
          initialRootPasswordFile = pkgs.writeText "rootPassword" initialRootPassword;
          smtp.enable = true;
          pages = {
            enable = true;
            settings.pages-domain = "pages.localhost";
          };
          extraConfig = {
            incoming_email = {
              enabled = true;
              mailbox = "inbox";
              address = "alice@localhost";
              user = "alice";
              password = "foobar";
              host = "localhost";
              port = 143;
            };
          };
          secrets = {
            secretFile = pkgs.writeText "secret" "Aig5zaic";
            otpFile = pkgs.writeText "otpsecret" "Riew9mue";
            dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
            jwsFile = pkgs.runCommand "oidcKeyBase" { } "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
            activeRecordPrimaryKeyFile = pkgs.writeText "arprimary" "vsaYPZjTRxcbG7W6gNr95AwBmzFUd4Eu";
            activeRecordDeterministicKeyFile = pkgs.writeText "ardeterministic" "kQarv9wb2JVP7XzLTh5f6DFcMHms4nEC";
            activeRecordSaltFile = pkgs.writeText "arsalt" "QkgR9CfFU3MXEWGqa7LbP24AntK5ZeYw";
          };

          registry = {
            enable = true;
            certFile = "/var/lib/gitlab/registry_auth_cert";
            keyFile = "/var/lib/gitlab/registry_auth_key";
            externalAddress = "registry.localhost";
            externalPort = 443;
          };

          # reduce memory usage
          sidekiq.concurrency = 1;
          puma.workers = 2;
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      auth = pkgs.writeText "auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = "root";
          password = initialRootPassword;
        }
      );

      createUserAlice = pkgs.writeText "create-user-alice.json" (
        builtins.toJSON rec {
          username = aliceUsername;
          name = username;
          email = "alice@localhost";
          password = alicePassword;
          skip_confirmation = true;
        }
      );

      createUserBob = pkgs.writeText "create-user-bob.json" (
        builtins.toJSON rec {
          username = bobUsername;
          name = username;
          email = "bob@localhost";
          password = bobPassword;
          skip_confirmation = true;
        }
      );

      aliceAuth = pkgs.writeText "alice-auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = aliceUsername;
          password = alicePassword;
        }
      );

      bobAuth = pkgs.writeText "bob-auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = bobUsername;
          password = bobPassword;
        }
      );

      aliceAddSSHKey = pkgs.writeText "alice-add-ssh-key.json" (
        builtins.toJSON {
          id = aliceUserId;
          title = "snakeoil@nixos";
          key = snakeOilPublicKey;
        }
      );

      createProjectAlice = pkgs.writeText "create-project-alice.json" (
        builtins.toJSON {
          name = aliceProjectName;
          visibility = "public";
        }
      );

      putFile = pkgs.writeText "put-file.json" (
        builtins.toJSON {
          branch = "master";
          author_email = "author@example.com";
          author_name = "Firstname Lastname";
          content = "some content";
          commit_message = "create a new file";
        }
      );

      mergeRequest = pkgs.writeText "merge-request.json" (
        builtins.toJSON {
          id = bobProjectId;
          target_project_id = aliceProjectId;
          source_branch = "master";
          target_branch = "master";
          title = "Add some other file";
        }
      );

      newIssue = pkgs.writeText "new-issue.json" (
        builtins.toJSON {
          title = "useful issue title";
        }
      );

      closeIssue = pkgs.writeText "close-issue.json" (
        builtins.toJSON {
          issue_iid = 1;
          state_event = "close";
        }
      );

      # Wait for all GitLab services to be fully started.
      waitForServices = ''
        gitlab.wait_for_unit("gitaly.service")
        gitlab.wait_for_unit("gitlab-workhorse.service")
        gitlab.wait_for_unit("gitlab-mailroom.service")
        gitlab.wait_for_unit("gitlab.service")
        gitlab.wait_for_unit("gitlab-pages.service")
        gitlab.wait_for_unit("gitlab-sidekiq.service")
        gitlab.wait_for_file("${nodes.gitlab.services.gitlab.statePath}/tmp/sockets/gitlab.socket")
        gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
        gitlab.wait_for_unit("docker-registry.service")
      '';

      # The actual test of GitLab. Only push data to GitLab if
      # `doSetup` is is true.
      test =
        doSetup:
        ''
          GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null"

          gitlab.succeed(
              "curl -isSf http://gitlab | grep -i location | grep http://gitlab/users/sign_in"
          )
          gitlab.succeed(
              "${pkgs.sudo}/bin/sudo -u gitlab -H gitlab-rake gitlab:check 1>&2"
          )
          gitlab.succeed(
              "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
          )
        ''
        + lib.optionalString doSetup ''
          with subtest("Create user Alice"):
              gitlab.succeed(
                  """[ "$(curl -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createUserAlice} http://gitlab/api/v4/users)" = "201" ]"""
              )
              gitlab.succeed(
                  "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${aliceAuth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers-alice"
              )

          with subtest("Create user Bob"):
              gitlab.succeed(
                  """ [ "$(curl -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createUserBob} http://gitlab/api/v4/users)" = "201" ]"""
              )
              gitlab.succeed(
                  "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${bobAuth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers-bob"
              )

          with subtest("Setup Git and SSH for Alice"):
              gitlab.succeed("git config --global user.name Alice")
              gitlab.succeed("git config --global user.email alice@nixos.invalid")
              gitlab.succeed("mkdir -p -m 700 /root/.ssh")
              gitlab.succeed("cat ${snakeOilPrivateKey} > /root/.ssh/id_ecdsa")
              gitlab.succeed("chmod 600 /root/.ssh/id_ecdsa")
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-alice -d @${aliceAddSSHKey} \
                      http://gitlab/api/v4/user/keys)" = "201" ]
                  """
              )

          with subtest("Create a new repository"):
              # Alice creates a new repository
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-alice \
                      -d @${createProjectAlice} \
                      http://gitlab/api/v4/projects)" = "201" ]
                  """
              )

              # Alice commits an initial commit
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-alice \
                      -d @${putFile} \
                      http://gitlab/api/v4/projects/${aliceProjectId}/repository/files/some-file.txt)" = "201" ]"""
              )

          with subtest("git clone over HTTP"):
              gitlab.succeed(
                  """git clone http://gitlab/alice/${aliceProjectName}.git clone-via-http""",
                  timeout=15
              )

          with subtest("Push a commit via SSH"):
              gitlab.succeed(
                  f"""GIT_SSH_COMMAND="{GIT_SSH_COMMAND}" git clone gitlab@gitlab:alice/${aliceProjectName}.git""",
                  timeout=15
              )
              gitlab.succeed(
                  """echo "a commit sent over ssh" > ${aliceProjectName}/ssh.txt"""
              )
              gitlab.succeed(
                  """
                  cd ${aliceProjectName} || exit 1
                  git add .
                  """
              )
              gitlab.succeed(
                  """
                  cd ${aliceProjectName} || exit 1
                  git commit -m "Add a commit to be sent over ssh"
                  """
              )
              gitlab.succeed(
                  f"""
                  cd ${aliceProjectName} || exit 1
                  GIT_SSH_COMMAND="{GIT_SSH_COMMAND}" git push --set-upstream origin master
                  """,
                  timeout=15
              )

          with subtest("Fork a project"):
              # Bob forks Alice's project
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-bob \
                      http://gitlab/api/v4/projects/${aliceProjectId}/fork)" = "201" ]
                  """
              )

              # Bob creates a commit
              gitlab.wait_until_succeeds(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-bob \
                      -d @${putFile} \
                      http://gitlab/api/v4/projects/${bobProjectId}/repository/files/some-other-file.txt)" = "201" ]
                  """
              )

          with subtest("Create a Merge Request"):
              # Bob opens a merge request against Alice's repository
              gitlab.wait_until_succeeds(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-bob \
                      -d @${mergeRequest} \
                      http://gitlab/api/v4/projects/${bobProjectId}/merge_requests)" = "201" ]
                  """
              )

              # Alice merges the MR
              gitlab.wait_until_succeeds(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X PUT \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-alice \
                      -d @${mergeRequest} \
                      http://gitlab/api/v4/projects/${aliceProjectId}/merge_requests/1/merge)" = "200" ]
                  """
              )

          with subtest("Create an Issue"):
              # Bob opens an issue on Alice's repository
              gitlab.succeed(
                  """[ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X POST \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-bob \
                      -d @${newIssue} \
                      http://gitlab/api/v4/projects/${aliceProjectId}/issues)" = "201" ]
                  """
              )

              # Alice closes the issue
              gitlab.wait_until_succeeds(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -X PUT \
                      -H 'Content-Type: application/json' \
                      -H @/tmp/headers-alice -d @${closeIssue} http://gitlab/api/v4/projects/${aliceProjectId}/issues/1)" = "200" ]
                  """
              )
        ''
        + ''
          with subtest("Download archive.tar.gz"):
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -H @/tmp/headers-alice \
                      http://gitlab/api/v4/projects/${aliceProjectId}/repository/archive.tar.gz)" = "200" ]
                  """
              )
              gitlab.succeed(
                  """
                  curl \
                      -H @/tmp/headers-alice \
                      http://gitlab/api/v4/projects/${aliceProjectId}/repository/archive.tar.gz > /tmp/archive.tar.gz
                  """
              )
              gitlab.succeed("test -s /tmp/archive.tar.gz")

          with subtest("Download archive.tar.bz2"):
              gitlab.succeed(
                  """
                  [ "$(curl \
                      -o /dev/null \
                      -w '%{http_code}' \
                      -H @/tmp/headers-alice \
                      http://gitlab/api/v4/projects/${aliceProjectId}/repository/archive.tar.bz2)" = "200" ]
                  """
              )
              gitlab.succeed(
                  """
                  curl \
                      -H @/tmp/headers-alice \
                      http://gitlab/api/v4/projects/${aliceProjectId}/repository/archive.tar.bz2 > /tmp/archive.tar.bz2
                  """
              )
              gitlab.succeed("test -s /tmp/archive.tar.bz2")
        ''
        + ''
          with subtest("Test docker registry http is available"):
              gitlab.succeed("curl -sSf http://registry.localhost")
        '';

    in
    ''
      gitlab.start()
    ''
    + waitForServices
    + ''
      gitlab.succeed("cp /var/gitlab/state/config/secrets.yml /root/gitlab-secrets.yml")
    ''
    + test true
    + ''
      gitlab.systemctl("start gitlab-backup.service")
      gitlab.wait_for_unit("gitlab-backup.service")
      gitlab.wait_for_file("${nodes.gitlab.services.gitlab.statePath}/backup/dump_gitlab_backup.tar")
      gitlab.systemctl("stop postgresql gitlab-config.service gitlab.target")
      gitlab.succeed(
          "find ${nodes.gitlab.services.gitlab.statePath} -mindepth 1 -maxdepth 1 -not -name backup -execdir rm -r {} +"
      )
      gitlab.succeed("systemd-tmpfiles --create")
      gitlab.succeed("rm -rf ${nodes.gitlab.services.postgresql.dataDir}")
      gitlab.systemctl("start gitlab-config.service gitaly.service gitlab-postgresql.service")
      gitlab.wait_for_file("${nodes.gitlab.services.gitlab.statePath}/tmp/sockets/gitaly.socket")
      gitlab.succeed(
          "sudo -u gitlab -H gitlab-rake gitlab:backup:restore RAILS_ENV=production BACKUP=dump force=yes"
      )
      gitlab.systemctl("start gitlab.target")
    ''
    + waitForServices
    + ''
      with subtest("Check that no secrets were auto-generated as these would be non-persistent"):
          gitlab.succeed("diff -u /root/gitlab-secrets.yml /var/gitlab/state/config/secrets.yml")
    ''
    + test false;
}
