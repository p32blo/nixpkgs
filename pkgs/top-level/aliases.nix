lib: self: super:

### Deprecated aliases - for backward compatibility
### Please maintain this list in ASCIIbetical ordering.
### Hint: the "sections" are delimited by ### <letter> ###

# These aliases should not be used within nixpkgs, but exist to improve
# backward compatibility in projects outside of nixpkgs. See the
# documentation for the `allowAliases` option for more background.

# A script to convert old aliases to throws and remove old
# throws can be found in './maintainers/scripts/remove-old-aliases.py'.

# Add 'preserve, reason: reason why' after the date if the alias should not be removed.
# Try to keep them to a minimum.
# valid examples of what to preserve:
#   distro aliases such as:
#     debian-package-name -> nixos-package-name

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  transmission3Warning =
    {
      prefix ? "",
      suffix ? "",
    }:
    let
      p = "${prefix}transmission${suffix}";
      p3 = "${prefix}transmission_3${suffix}";
      p4 = "${prefix}transmission_4${suffix}";
    in
    "${p} has been renamed to ${p3} since ${p4} is also available. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)";

  deprecatedPlasma5Packages = {
    inherit (plasma5Packages)
      akonadi
      akregator
      arianna
      ark
      bluedevil
      bomber
      bovo
      breeze-grub
      breeze-gtk
      breeze-icons
      breeze-plymouth
      breeze-qt5
      colord-kde
      discover
      dolphin
      dragon
      elisa
      falkon
      ffmpegthumbs
      filelight
      granatier
      gwenview
      k3b
      kactivitymanagerd
      kaddressbook
      kalzium
      kapman
      kapptemplate
      kate
      katomic
      kblackbox
      kblocks
      kbounce
      kcachegrind
      kcalc
      kcharselect
      kcolorchooser
      kde-cli-tools
      kde-gtk-config
      kdenlive
      kdeplasma-addons
      kdevelop-pg-qt
      kdevelop-unwrapped
      kdev-php
      kdev-python
      kdevelop
      kdf
      kdialog
      kdiamond
      keditbookmarks
      kfind
      kgamma5
      kget
      kgpg
      khelpcenter
      kig
      kigo
      killbots
      kinfocenter
      kitinerary
      kleopatra
      klettres
      klines
      kmag
      kmail
      kmenuedit
      kmines
      kmix
      kmplot
      knavalbattle
      knetwalk
      knights
      kollision
      kolourpaint
      kompare
      konsole
      kontact
      konversation
      korganizer
      kpkpass
      krdc
      kreversi
      krfb
      kscreen
      kscreenlocker
      kshisen
      ksquares
      ksshaskpass
      ksystemlog
      kteatime
      ktimer
      ktorrent
      ktouch
      kturtle
      kwallet-pam
      kwalletmanager
      kwave
      kwayland-integration
      kwin
      kwrited
      marble
      merkuro
      milou
      minuet
      okular
      oxygen
      picmi
      plasma-browser-integration
      plasma-desktop
      plasma-integration
      plasma-nano
      plasma-nm
      plasma-pa
      plasma-mobile
      plasma-systemmonitor
      plasma-thunderbolt
      plasma-vault
      plasma-workspace
      plasma-workspace-wallpapers
      powerdevil
      qqc2-breeze-style
      sddm-kcm
      skanlite
      skanpage
      spectacle
      systemsettings
      xdg-desktop-portal-kde
      yakuake
      zanshin
      ;

    inherit (plasma5Packages.thirdParty)
      krohnkite
      krunner-ssh
      krunner-symbols
      kwin-dynamic-workspaces
      kwin-tiling
      plasma-applet-caffeine-plus
      plasma-applet-virtual-desktop-bar
      ;

    inherit (libsForQt5)
      sddm
      neochat # added 2025-07-04
      itinerary # added 2025-07-04
      libquotient # added 2025-07-04
      ;
  };

  makePlasma5Throw =
    name:
    throw ''
      The top-level ${name} alias has been removed.

      Please explicitly use kdePackages.${name} for the latest Qt 6-based version,
      or libsForQt5.${name} for the deprecated Qt 5 version.

      Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.
    '';

  plasma5Throws = lib.mapAttrs (k: _: makePlasma5Throw k) deprecatedPlasma5Packages;

  # Make sure that we are not shadowing something from all-packages.nix.
  checkInPkgs =
    n: alias:
    if builtins.hasAttr n super then abort "Alias ${n} is still in all-packages.nix" else alias;

  mapAliases =
    aliases: lib.mapAttrs (n: alias: removeRecurseForDerivations (checkInPkgs n alias)) aliases;
in

mapAliases {
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _: (import self.path { localSystem = { inherit system; }; });

  ### _ ###
  _1password = lib.warnOnInstantiate "_1password has been renamed to _1password-cli to better follow upstream name usage" _1password-cli; # Added 2024-10-24
  _2048-cli = throw "'_2048-cli' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-curses = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-terminal = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _5etools = throw "'_5etools' has been removed, as upstream is in a questionable legal position and the build was broken.";
  "7z2hashcat" =
    throw "'7z2hashcat' has been renamed to '_7z2hashcat' as the former isn't a valid variable name."; # Added 2024-11-27

  ### A ###

  AusweisApp2 = ausweisapp; # Added 2023-11-08
  a4term = a4; # Added 2023-10-06
  acorn = throw "acorn has been removed as the upstream project was archived"; # Added 2024-04-27
  acousticbrainz-client = throw "acousticbrainz-client has been removed since the AcousticBrainz project has been shut down"; # Added 2024-06-04
  adminer-pematon = adminneo; # Added 2025-02-20
  adminerneo = adminneo; # Added 2025-02-27
  adtool = throw "'adtool' has been removed, as it was broken and unmaintained";
  adobe-reader = throw "'adobe-reader' has been removed, as it was broken, outdated and insecure"; # added 2025-05-31
  adom = throw "'adom' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  adoptopenjdk-bin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin`"; # Added 2024-05-09
  adoptopenjdk-bin-17-packages-darwin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-bin-17-packages-linux = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-11`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-8`."; # Added 2024-05-09
  adoptopenjdk-jre-bin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin-11`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `temurin-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `temurin-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin-8`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-jre-bin-11`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `semeru-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `semeru-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-jre-bin-8`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-bin-11`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `semeru-bin-17`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `semeru-bin-17`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-bin-8`."; # Added 2024-05-09
  addOpenGLRunpath = throw "addOpenGLRunpath has been removed. Use addDriverRunpath instead."; # Converted to throw 2024-11-17
  aeon = throw "aeon has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-07-15
  afl = throw "afl has been removed as the upstream project was archived. Consider using 'aflplusplus'"; # Added 2024-04-21
  afpfs-ng = throw "'afpfs-ng' has been removed as it was broken and unmaintained for 10 years"; # Added 2025-05-17
  agda-pkg = throw "agda-pkg has been removed due to being unmaintained"; # Added 2024-09-10"
  ajour = throw "ajour has been removed, the project was archived upstream on 2024-09-17."; # Added 2025-03-12
  akkoma-emoji = recurseIntoAttrs {
    blobs_gg = lib.warnOnInstantiate "'akkoma-emoji.blobs_gg' has been renamed to 'blobs_gg'" blobs_gg; # Added 2025-03-14
  };
  akkoma-frontends = recurseIntoAttrs {
    admin-fe = lib.warnOnInstantiate "'akkoma-frontends.admin-fe' has been renamed to 'akkoma-admin-fe'" akkoma-admin-fe; # Added 2025-03-14
    akkoma-fe = lib.warnOnInstantiate "'akkoma-frontends.akkoma-fe' has been renamed to 'akkoma-fe'" akkoma-fe; # Added 2025-03-14
  };
  alass = throw "'alass' has been removed due to being unmaintained upstream"; # Added 2025-01-25
  alsaLib = throw "'alsaLib' has been renamed to/replaced by 'alsa-lib'"; # Converted to throw 2024-10-17
  alsaOss = throw "'alsaOss' has been renamed to/replaced by 'alsa-oss'"; # Converted to throw 2024-10-17
  alsaPluginWrapper = throw "'alsaPluginWrapper' has been renamed to/replaced by 'alsa-plugins-wrapper'"; # Converted to throw 2024-10-17
  alsaPlugins = throw "'alsaPlugins' has been renamed to/replaced by 'alsa-plugins'"; # Converted to throw 2024-10-17
  alsaTools = throw "'alsaTools' has been renamed to/replaced by 'alsa-tools'"; # Converted to throw 2024-10-17
  alsaUtils = throw "'alsaUtils' has been renamed to/replaced by 'alsa-utils'"; # Converted to throw 2024-10-17
  angelfish = throw "'angelfish' has been renamed to/replaced by 'libsForQt5.kdeGear.angelfish'"; # Converted to throw 2024-10-17
  ansible_2_14 = throw "Ansible 2.14 goes end of life in 2024/05 and can't be supported throughout the 24.05 release cycle"; # Added 2024-04-11
  ansible_2_15 = throw "Ansible 2.15 goes end of life in 2024/11 and can't be supported throughout the 24.11 release cycle"; # Added 2024-11-08
  antennas = throw "antennas has been removed as it only works with tvheadend, which nobody was willing to maintain and was stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  androidndkPkgs_23b = lib.warnOnInstantiate "The package set `androidndkPkgs_23b` has been renamed to `androidndkPkgs_23`." androidndkPkgs_23; # Added 2024-07-21
  ankisyncd = throw "ankisyncd is dead, use anki-sync-server instead"; # Added 2024-08-10
  ao = libfive; # Added 2024-10-11
  anbox = throw "'anbox' has been removed as the upstream project is unmaintained, see https://github.com/anbox/.github/blob/main/profile/README.md"; # Added 2025-01-04
  antic = throw "'antic' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  anevicon = throw "'anevicon' has been removed because the upstream repository no longer exists"; # Added 2025-01-26
  apacheKafka_3_5 = throw "apacheKafka_2_8 through _3_6 have been removed from nixpkgs as outdated"; # Added 2024-06-13
  apacheKafka_3_6 = throw "apacheKafka_2_8 through _3_6 have been removed from nixpkgs as outdated"; # Added 2024-11-27
  antimicroX = throw "'antimicroX' has been renamed to/replaced by 'antimicrox'"; # Converted to throw 2024-10-17
  apacheAnt = ant; # Added 2024-11-28
  apparmor-kernel-patches = throw "'apparmor-kernel-patches' has been removed as they were unmaintained, irrelevant and effectively broken"; # Added 2025-04-20
  appimagekit = throw "'appimagekit' has been removed as it was broken in nixpkgs and archived upstream"; # Added 2025-04-19
  apple-sdk_10_12 = throw "apple-sdk_10_12 was removed as Nixpkgs no longer supports macOS 10.12; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_13 = throw "apple-sdk_10_13 was removed as Nixpkgs no longer supports macOS 10.13; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_14 = throw "apple-sdk_10_14 was removed as Nixpkgs no longer supprots macOS 10.14; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_15 = throw "apple-sdk_10_15 was removed as Nixpkgs no longer supports macOS 10.15; see the 25.05 release notes"; # Added 2024-10-27
  appthreat-depscan = dep-scan; # Added 2024-04-10
  arb = throw "'arb' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  arcanist = throw "arcanist was removed as phabricator is not supported and does not accept fixes"; # Added 2024-06-07
  archipelago-minecraft = throw "archipelago-minecraft has been removed, as upstream no longer ships minecraft as a default APWorld."; # Added 2025-07-15
  argo = argo-workflows; # Added 2025-02-01
  aria = aria2; # Added 2024-03-26
  artim-dark = aritim-dark; # Added 2025-07-27
  armcord = throw "ArmCord was renamed to legcord by the upstream developers. Action is required to migrate configurations between the two applications. Please see this PR for more details: https://github.com/NixOS/nixpkgs/pull/347971"; # Added 2024-10-11
  aseprite-unfree = aseprite; # Added 2023-08-26
  asitop = macpm; # 'macpm' is a better-maintained downstream; keep 'asitop' for backwards-compatibility
  async = throw "'async' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  atlassian-bamboo = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-confluence = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-crowd = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-jira = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  ats = throw "'ats' has been removed as it is unmaintained for 10 years and broken"; # Added 2025-05-17
  audaciousQt5 = throw "'audaciousQt5' has been removed, since audacious is built with Qt 6 now"; # Added 2024-07-06
  auditBlasHook = throw "'auditBlasHook' has been removed since it never worked"; # Added 2024-04-02
  autoconf213 = throw "'autoconf213' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  autoconf264 = throw "'autoconf264' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  automake111x = throw "'automake111x' has been removed in favor of 'automake'"; # Added 2025-07-21
  autoReconfHook = throw "You meant 'autoreconfHook', with a lowercase 'r'."; # preserve
  autoreconfHook264 = throw "'autoreconfHook264' has been removed in favor of 'autoreconfHook'"; # Added 2025-07-21
  aumix = throw "'aumix' has been removed due to lack of maintenance upstream. Consider using 'pamixer' for CLI or 'pavucontrol' for GUI"; # Added 2024-09-14
  authy = throw "'authy' has been removed since it reached end of life"; # Added 2024-04-19
  autoadb = throw "'autoadb' has been removed due to lack of maintenance upstream"; # Added 2025-01-25
  avldrums-lv2 = throw "'avldrums-lv2' has been renamed to/replaced by 'x42-avldrums'"; # Converted to throw 2024-10-17
  avr-sim = throw "'avr-sim' has been removed as it was broken and unmaintained. Possible alternatives are 'simavr', SimulAVR and AVRStudio."; # Added 2025-05-31
  axmldec = throw "'axmldec' has been removed as it was broken and unmaintained for 8 years"; # Added 2025-05-17
  awesome-4-0 = awesome; # Added 2022-05-05
  aws-env = throw "aws-env has been removed as the upstream project was unmaintained"; # Added 2024-06-11
  aws-google-auth = throw "aws-google-auth has been removed as the upstream project was unmaintained"; # Added 2024-07-31

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  badwolf = throw "'badwolf' has been removed due to being unmaintained"; # Added 2025-04-15
  baget = throw "'baget' has been removed due to being unmaintained";
  base16-builder = throw "'base16-builder' has been removed due to being unmaintained"; # Added 2025-06-03
  bashInteractive_5 = throw "'bashInteractive_5' has been renamed to/replaced by 'bashInteractive'"; # Converted to throw 2024-10-17
  bash_5 = throw "'bash_5' has been renamed to/replaced by 'bash'"; # Converted to throw 2024-10-17
  bareboxTools = throw "bareboxTools has been removed due to lack of interest in maintaining it in nixpkgs"; # Added 2025-04-19
  BeatSaberModManager = beatsabermodmanager; # Added 2024-06-12
  beam_nox = throw "beam_nox has been removed in favor of beam_minimal or beamMinimalPackages"; # Added 2025-04-01
  beatsabermodmanager = throw "'beatsabermodmanager' has been removed due to lack of upstream maintainenance. Consider using 'bs-manager' instead"; # Added 2025-03-18
  betterbird = throw "betterbird has been removed as there were insufficient maintainer resources to keep up with security updates"; # Added 2024-10-25
  betterbird-unwrapped = throw "betterbird has been removed as there were insufficient maintainer resources to keep up with security updates"; # Added 2024-10-25
  bibata-extra-cursors = throw "bibata-cursors has been removed as it was broken"; # Added 2024-07-15
  bitbucket-server-cli = throw "bitbucket-server-cli has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  bitcoin-abc = throw "bitcoin-abc has been removed due to a lack of maintanance"; # Added 2026-06-17
  bitcoin-unlimited = throw "bitcoin-unlimited has been removed as it was broken and unmaintained"; # Added 2024-07-15
  bitcoind-abc = throw "bitcoind-abc has been removed due to a lack of maintanance"; # Added 2026-06-17
  bitcoind-unlimited = throw "bitcoind-unlimited has been removed as it was broken and unmaintained"; # Added 2024-07-15
  bird = throw "The bird alias was ambiguous and has been removed for the time being. Please explicitly choose bird2 or bird3."; # Added 2025-01-11
  bisq-desktop = throw "bisq-desktop has been removed because OpenJFX 11 was removed"; # Added 2024-11-17
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  blender-with-packages =
    args:
    lib.warnOnInstantiate
      "blender-with-packages is deprecated in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"
      (blender.withPackages (_: args.packages)).overrideAttrs
      (lib.optionalAttrs (args ? name) { pname = "blender-" + args.name; }); # Added 2023-10-30
  bless = throw "'bless' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'imhex' or 'ghex' instead"; # Added 2024-09-15
  blockbench-electron = blockbench; # Added 2024-03-16
  bloom = throw "'bloom' has been removed because it was unmaintained upstream."; # Added 2024-11-02
  bmap-tools = bmaptool; # Added 2024-08-05
  boost175 = throw "Boost 1.75 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost184 = throw "Boost 1.84 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost185 = throw "Boost 1.85 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost_process = throw "boost_process has been removed as it is included in regular boost"; # Added 2024-05-01
  bpb = throw "bpb has been removed as it is unmaintained and not compatible with recent Rust versions"; # Added 2024-04-30
  bpftool = throw "'bpftool' has been renamed to/replaced by 'bpftools'"; # Converted to throw 2024-10-17
  brasero-original = lib.warnOnInstantiate "Use 'brasero-unwrapped' instead of 'brasero-original'" brasero-unwrapped; # Added 2024-09-29
  bridgand = throw "'brigand' has been removed due to being unmaintained"; # Added 2025-04-30
  bs-platform = throw "'bs-platform' was removed as it was broken, development ended and 'melange' has superseded it"; # Added 2024-07-29
  buf-language-server = throw "'buf-language-server' was removed as its development has moved to the 'buf' package"; # Added 2024-11-15

  budgie = throw "The `budgie` scope has been removed and all packages moved to the top-level"; # Added 2024-07-14
  budgiePlugins = throw "The `budgiePlugins` scope has been removed and all packages moved to the top-level"; # Added 2024-07-14
  buildBarebox = throw "buildBarebox has been removed due to lack of interest in maintaining it in nixpkgs"; # Added 2025-04-19
  buildGo122Module = throw "Go 1.22 is end-of-life, and 'buildGo122Module' has been removed. Please use a newer builder version."; # Added 2025-03-28
  buildGoPackage = throw "`buildGoPackage` has been deprecated and removed, see the Go section in the nixpkgs manual for details"; # Added 2024-11-18
  buildXenPackage = throw "'buildXenPackage' has been removed as a custom Xen build can now be achieved by simply overriding 'xen'."; # Added 2025-05-12

  inherit (libsForQt5.mauiPackages) buho; # added 2022-05-17
  bwidget = tclPackages.bwidget; # Added 2024-10-02
  # Shorter names; keep the longer name for back-compat. Added 2023-04-11. Warning added on 2024-12-16. Removed on 2025-05-31
  buildFHSUserEnv = throw "'buildFHSUserEnv' has been renamed to 'buildFHSEnv' and was removed in 25.11";
  buildFHSUserEnvChroot = throw "'buildFHSUserEnvChroot' has been renamed to 'buildFHSEnvChroot' and was removed in 25.11";
  buildFHSUserEnvBubblewrap = throw "'buildFHSUserEnvBubblewrap' has been renamed to 'buildFHSEnvBubblewrap' and was removed in 25.11";

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;

  ### C ###

  caffeWithCuda = throw "caffeWithCuda has been removed, as it was broken and required CUDA 10"; # Added 2024-11-20
  calcium = throw "'calcium' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  calculix = calculix-ccx; # Added 2024-12-18
  calligra = kdePackages.calligra; # Added 2024-09-27
  callPackage_i686 = pkgsi686Linux.callPackage;
  cargo-asm = throw "'cargo-asm' has been removed due to lack of upstream maintenance. Consider 'cargo-show-asm' as an alternative.";
  cask = emacs.pkgs.cask; # Added 2022-11-12
  catcli = throw "catcli has been superseded by gocatcli"; # Added 2025-04-19
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cargo-deps = throw "cargo-deps has been removed as the repository is deleted"; # Added 2024-04-09
  cargo-espflash = espflash;
  cargo-kcov = throw "'cargo-kcov' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  cargo-information = throw "'cargo-information' has been removed due to being merged upstream into 'cargo'"; # Added 2025-03-09
  cargo-inspect = throw "'cargo-inspect' has been removed due to lack of upstream maintenance. Upstream recommends cargo-expand."; # Added 2025-01-26
  cargo-web = throw "'cargo-web' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  cargonode = throw "'cargonode' has been removed due to lack of upstream maintenance"; # Added 2025-06-18
  cassandra_3_0 = throw "'cassandra_3_0' has been removed has it reached end-of-life"; # Added 2025-03-23
  cassandra_3_11 = throw "'cassandra_3_11' has been removed has it reached end-of-life"; # Added 2025-03-23
  cawbird = throw "cawbird has been abandoned upstream and is broken anyways due to Twitter closing its API";
  catalyst-browser = throw "'catalyst-browser' has been removed due to a lack of maintenance and not satisfying our security criteria for browsers."; # Added 2025-06-25
  cde = throw "'cde' has been removed as it is unmaintained and broken"; # Added 2025-05-17
  centerim = throw "centerim has been removed due to upstream disappearing"; # Added 2025-04-18
  certmgr-selfsigned = certmgr; # Added 2023-11-30
  cgal_4 = throw "cgal_4 has been removed as it is obsolete use cgal instead"; # Added 2024-12-30
  cgal_5 = cgal; # Added 2024-12-30
  challenger = taler-challenger; # Added 2024-09-04
  check_smartmon = nagiosPlugins.check_smartmon; # Added 2024-05-03
  check_systemd = nagiosPlugins.check_systemd; # Added 2024-05-03
  check_zfs = nagiosPlugins.check_zfs; # Added 2024-05-03
  check-esxi-hardware = nagiosPlugins.check_esxi_hardware; # Added 2024-05-03
  check-mssql-health = nagiosPlugins.check_mssql_health; # Added 2024-05-03
  check-nwc-health = nagiosPlugins.check_nwc_health; # Added 2024-05-03
  check-openvpn = nagiosPlugins.check_openvpn; # Added 2024-05-03
  check-ups-health = nagiosPlugins.check_ups_health; # Added 2024-05-03
  check-uptime = nagiosPlugins.check_uptime; # Added 2024-05-03
  check-wmiplus = nagiosPlugins.check_wmi_plus; # Added 2024-05-03
  checkSSLCert = nagiosPlugins.check_ssl_cert; # Added 2024-05-03
  chiaki4deck = chiaki-ng; # Added 2024-08-04
  chocolateDoom = chocolate-doom; # Added 2023-05-01
  ChowCentaur = chow-centaur; # Added 2024-06-12
  ChowPhaser = chow-phaser; # Added 2024-06-12
  ChowKick = chow-kick; # Added 2024-06-12
  CHOWTapeModel = chow-tape-model; # Added 2024-06-12
  chromatic = throw "chromatic has been removed due to being unmaintained and failing to build"; # Added 2025-04-18
  chrome-gnome-shell = gnome-browser-connector; # Added 2022-07-27
  cinnamon = throw "The cinnamon scope has been removed and all packages have been moved to the top-level"; # Added 2024-11-25
  citra = throw "citra has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  citra-nightly = throw "citra-nightly has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  citra-canary = throw "citra-canary has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  cloog = throw "cloog has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  cloog_0_18_0 = throw "cloog_0_18_0 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  cloogppl = throw "cloogppl has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  clamsmtp = throw "'clamsmtp' has been removed as it is unmaintained and broken"; # Added 2025-05-17
  clang-sierraHack = throw "clang-sierraHack has been removed because it solves a problem that no longer seems to exist. Hey, what were you even doing with that thing anyway?"; # Added 2024-10-05
  clang-sierraHack-stdenv = clang-sierraHack; # Added 2024-10-05
  cli-visualizer = throw "'cli-visualizer' has been removed as the upstream repository is gone"; # Added 2025-06-05
  inherit (libsForQt5.mauiPackages) clip; # added 2022-05-17
  cloudlogoffline = throw "cloudlogoffline has been removed"; # added 2025-05-18
  clwrapperFunction = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  CoinMP = coinmp; # Added 2024-06-12
  collada-dom = opencollada; # added 2024-02-21
  colorpicker = throw "'colorpicker' has been removed due to lack of maintenance upstream. Consider using 'xcolor', 'gcolor3', 'eyedropper' or 'gpick' instead"; # Added 2024-10-19
  colorstorm = throw "'colorstorm' has been removed because it was unmaintained in nixpkgs and upstream was rewritten."; # Added 2025-06-15
  connman-ncurses = throw "'connman-ncurses' has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  cordless = throw "'cordless' has been removed due to being archived upstream. Consider using 'discordo' instead."; # Added 2025-06-07
  coriander = throw "'coriander' has been removed because it depends on GNOME 2 libraries"; # Added 2024-06-27
  corretto19 = throw "Corretto 19 was removed as it has reached its end of life"; # Added 2024-08-01
  cosmic-tasks = tasks; # Added 2024-07-04
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  cromite = throw "'cromite' has been removed from nixpkgs due to it not being maintained"; # Added 2025-06-12
  crossLibcStdenv = stdenvNoLibc; # Added 2024-09-06
  crystal_1_2 = throw "'crystal_1_2' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_7 = throw "'crystal_1_7' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_8 = throw "'crystal_1_8' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_9 = throw "'crystal_1_9' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_12 = throw "'crystal_1_12' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-19
  clash-geoip = throw "'clash-geoip' has been removed. Consider using 'dbip-country-lite' instead."; # added 2024-10-19
  clash-verge = throw "'clash-verge' has been removed, as it was broken and unmaintained. Consider using 'clash-verge-rev' or 'clash-nyanpasu' instead"; # Added 2024-09-17
  clasp = clingo; # added 2022-12-22
  claws-mail-gtk3 = throw "'claws-mail-gtk3' has been renamed to/replaced by 'claws-mail'"; # Converted to throw 2024-10-17
  clubhouse-cli = throw "'clubhouse-cli' has been removed due to lack of interest to maintain it in Nixpkgs and failing to build."; # added 2025-04-21
  cockroachdb-bin = cockroachdb; # 2024-03-15
  codimd = throw "'codimd' has been renamed to/replaced by 'hedgedoc'"; # Converted to throw 2024-10-17
  inherit (libsForQt5.mauiPackages) communicator; # added 2022-05-17
  concurrencykit = throw "'concurrencykit' has been renamed to/replaced by 'libck'"; # Converted to throw 2024-10-17
  containerpilot = throw "'containerpilot' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-06-09
  crack_attack = throw "'crack_attack' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  crackmapexec = throw "'crackmapexec' has been removed as it was unmaintained. Use 'netexec' instead"; # 2024-08-11
  create-react-app = throw "'create-react-app' has been removed as it was deprecated. Upstream suggests using a framework for React."; # Added 2025-05-17
  critcl = tclPackages.critcl; # Added 2024-10-02
  crunchy-cli = throw "'crunchy-cli' was sunset, see <https://github.com/crunchy-labs/crunchy-cli/issues/362>"; # Added 2025-03-26
  cudaPackages_10_0 = throw "CUDA 10.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10_1 = throw "CUDA 10.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10_2 = throw "CUDA 10.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10 = throw "CUDA 10 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12
  cutemarked-ng = throw "'cutemarked-ng' has been removed due to lack of maintenance upstream. Consider using 'kdePackages.ghostwriter' instead"; # Added 2024-12-27
  cvs_fast_export = throw "'cvs_fast_export' has been renamed to/replaced by 'cvs-fast-export'"; # Converted to throw 2024-10-17

  # these are for convenience, not for backward compat and shouldn't expire
  clang9Stdenv = throw "clang9Stdenv has been removed from nixpkgs"; # Added 2024-04-08
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;
  clang13Stdenv = lowPrio llvmPackages_13.stdenv;
  clang14Stdenv = lowPrio llvmPackages_14.stdenv;
  clang15Stdenv = lowPrio llvmPackages_15.stdenv;
  clang16Stdenv = lowPrio llvmPackages_16.stdenv;
  clang17Stdenv = lowPrio llvmPackages_17.stdenv;
  clang18Stdenv = lowPrio llvmPackages_18.stdenv;
  clang19Stdenv = lowPrio llvmPackages_19.stdenv;

  clang-tools_9 = throw "clang-tools_9 has been removed from nixpkgs"; # Added 2024-04-08
  clang_9 = throw "clang_9 has been removed from nixpkgs"; # Added 2024-04-08

  clang-tools_12 = llvmPackages_12.clang-tools; # Added 2024-04-22
  clang-tools_13 = llvmPackages_13.clang-tools; # Added 2024-04-22
  clang-tools_14 = llvmPackages_14.clang-tools; # Added 2024-04-22
  clang-tools_15 = llvmPackages_15.clang-tools; # Added 2024-04-22
  clang-tools_16 = llvmPackages_16.clang-tools; # Added 2024-04-22
  clang-tools_17 = llvmPackages_17.clang-tools; # Added 2024-04-22
  clang-tools_18 = llvmPackages_18.clang-tools; # Added 2024-04-22
  clang-tools_19 = llvmPackages_19.clang-tools; # Added 2024-08-21

  cligh = throw "'cligh' has been removed since it was unmaintained and its upstream deleted"; # Added 2025-05-05
  cq-editor = throw "cq-editor has been removed, as it use a dependency that was disabled since python 3.8 and was last updated in 2021"; # Added 2024-05-13

  ### D ###

  dap = throw "'dap' has been removed because it doesn't compile and has been unmaintained since 2014"; # Added 2025-05-10
  daq = throw "'daq' has been removed as it is unmaintained and broken. Snort2 has also been removed, which depended on this"; # Added 2025-05-21
  darling = throw "'darling' has been removed due to vendoring Python2"; # Added 2025-05-10
  dart_stable = throw "'dart_stable' has been renamed to/replaced by 'dart'"; # Converted to throw 2024-10-17
  dart-sass-embedded = throw "dart-sass-embedded has been removed from nixpkgs, as is now included in Dart Sass itself.";
  dat = nodePackages.dat;
  dave = throw "'dave' has been removed as it has been archived upstream. Consider using 'webdav' instead"; # Added 2025-02-03
  daytona-bin = throw "'daytona-bin' has been removed, as it was unmaintained in nixpkgs"; # Added 2025-07-21
  dbeaver = throw "'dbeaver' has been renamed to/replaced by 'dbeaver-bin'"; # Added 2024-05-16
  dbench = throw "'dbench' has been removed as it is unmaintained for 14 years and broken"; # Added 2025-05-17
  dclib = throw "'dclib' has been removed as it is unmaintained for 16 years and broken"; # Added 2025-05-25
  dbus-map = throw "'dbus-map' has been dropped as it is unmaintained"; # Added 2024-11-01
  deadpixi-sam = deadpixi-sam-unstable;

  debugedit-unstable = throw "'debugedit-unstable' has been renamed to/replaced by 'debugedit'"; # Converted to throw 2024-10-17
  degit-rs = throw "'degit-rs' has been removed because it is unmaintained upstream and has vulnerable dependencies."; # Added 2025-07-11
  deltachat-cursed = arcanechat-tui; # added 2025-02-25
  deltachat-electron = throw "'deltachat-electron' has been renamed to/replaced by 'deltachat-desktop'"; # Converted to throw 2024-10-17

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  devdash = throw "'devdash' has been removed as the upstream project was archived"; # Added 2025-03-27
  devdocs-desktop = throw "'devdocs-desktop' has been removed as it is unmaintained upstream and vendors insecure dependencies"; # Added 2025-06-11
  dfilemanager = throw "'dfilemanager' has been dropped as it was unmaintained"; # Added 2025-06-03
  dgsh = throw "'dgsh' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  dibbler = throw "dibbler was removed because it is not maintained anymore"; # Added 2024-05-14
  dillong = throw "'dillong' has been removed, as upstream is abandoned since 2021-12-13. Use either 'dillo' or 'dillo-plus'. The latter integrates features from dillong."; # Added 2024-10-07
  dina-font-pcf = throw "'dina-font-pcf' has been renamed to/replaced by 'dina-font'"; # Converted to throw 2024-10-17
  directvnc = throw "'directvnc' has been removed as it was unmaintained upstream since 2015 and failed to build with gcc 14"; # Added 2025-05-17
  diskonaut = throw "'diskonaut' was removed due to lack of upstream maintenance"; # Added 2025-01-25
  dispad = throw "dispad has been remove because it doesn't compile and has been unmaintained since 2014"; # Added 2025-04-25
  dleyna-core = dleyna; # Added 2025-04-19
  dleyna-connector-dbus = dleyna; # Added 2025-04-19
  dleyna-renderer = dleyna; # Added 2025-04-19
  dleyna-server = dleyna; # Added 2025-04-19
  dnnl = throw "'dnnl' has been renamed to/replaced by 'oneDNN'"; # Converted to throw 2024-10-17
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02
  dnscrypt-wrapper = throw "dnscrypt-wrapper was removed because it has been effectively unmaintained since 2018. Use DNSCcrypt support in dnsdist instead"; # Added 2024-09-14
  docear = throw "Docear was removed because it was unmaintained upstream. JabRef, Zotero, or Mendeley are potential replacements."; # Added 2024-11-02
  docker_24 = throw "'docker_24' has been removed because it has been unmaintained since June 2024. Use docker_25 or newer instead."; # Added 2024-12-21
  docker_26 = throw "'docker_26' has been removed because it has been unmaintained since February 2025. Use docker_28 or newer instead."; # Added 2025-06-21
  docker_27 = throw "'docker_27' has been removed because it has been unmaintained since May 2025. Use docker_28 or newer instead."; # Added 2025-06-15
  docker-compose_1 = throw "'docker-compose_1' has been removed because it has been unmaintained since May 2021. Use docker-compose instead."; # Added 2024-07-29
  docker-distribution = distribution; # Added 2023-12-26
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dolphinEmu = throw "'dolphinEmu' has been renamed to/replaced by 'dolphin-emu'"; # Converted to throw 2024-10-17
  dolphinEmuMaster = throw "'dolphinEmuMaster' has been renamed to/replaced by 'dolphin-emu-beta'"; # Converted to throw 2024-10-17
  dotty = scala_3; # Added 2023-08-20
  dotnet-netcore = throw "'dotnet-netcore' has been renamed to/replaced by 'dotnet-runtime'"; # Converted to throw 2024-10-17
  dotnet-sdk_2 = throw "'dotnet-sdk_2' has been renamed to/replaced by 'dotnetCorePackages.sdk_2_1'"; # Converted to throw 2024-10-17
  dotnet-sdk_3 = throw "'dotnet-sdk_3' has been renamed to/replaced by 'dotnetCorePackages.sdk_3_1'"; # Converted to throw 2024-10-17
  dotnet-sdk_5 = throw "'dotnet-sdk_5' has been renamed to/replaced by 'dotnetCorePackages.sdk_5_0'"; # Converted to throw 2024-10-17
  dotnetenv = throw "'dotnetenv' has been removed because it was unmaintained in Nixpkgs"; # Added 2025-07-11
  downonspot = throw "'downonspot' was removed because upstream has been taken down by a cease and desist"; # Added 2025-01-25
  dozenal = throw "dozenal has been removed because it does not compile and only minimal functionality"; # Added 2025-03-30
  dstat = throw "'dstat' has been removed because it has been unmaintained since 2020. Use 'dool' instead."; # Added 2025-01-21
  drush = throw "drush as a standalone package has been removed because it's no longer supported as a standalone tool";
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  dump1090 = dump1090-fa; # Added 2024-02-12
  dwfv = throw "'dwfv' has been removed due to lack of upstream maintenance";
  dylibbundler = throw "'dylibbundler' has been renamed to/replaced by 'macdylibbundler'"; # Converted to throw 2024-10-17

  ### E ###

  EBTKS = ebtks; # Added 2024-01-21
  eask = eask-cli; # Added 2024-09-05
  eboard = throw "'eboard' has been removed due to lack of maintenance upstream. Consider using 'kdePackages.knights' instead"; # Added 2024-10-19
  ec2_ami_tools = throw "'ec2_ami_tools' has been renamed to/replaced by 'ec2-ami-tools'"; # Converted to throw 2024-10-17
  ec2_api_tools = throw "'ec2_api_tools' has been renamed to/replaced by 'ec2-api-tools'"; # Converted to throw 2024-10-17
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  ecryptfs-helper = throw "'ecryptfs-helper' has been removed, for filesystem-level encryption, use fscrypt"; # Added 2025-04-08
  edbrowse = throw "'edbrowse' has been removed as it was unmaintained in Nixpkgs"; # Added 2025-05-18
  edUnstable = throw "edUnstable was removed; use ed instead"; # Added 2024-07-01
  edgedb = throw "edgedb replaced to gel because of change of upstream"; # Added 2025-02-24
  edge-runtime = throw "'edge-runtime' was removed as it was unused, unmaintained, likely insecure and failed to build"; # Added 2025-05-18
  edid-decode = v4l-utils; # Added 2025-06-20
  eidolon = throw "eidolon was removed as it is unmaintained upstream."; # Added 2025-05-28
  eintopf = lauti; # Project was renamed, added 2025-05-01
  elasticsearch7Plugins = elasticsearchPlugins;
  electronplayer = throw "'electronplayer' has been removed as it had been discontinued upstream since October 2024"; # Added 2024-12-17

  element-desktop-wayland = throw "element-desktop-wayland has been removed. Consider setting NIXOS_OZONE_WL=1 via 'environment.sessionVariables' instead"; # Added 2024-12-17
  elementsd-simplicity = throw "'elementsd-simplicity' has been removed due to lack of maintenance, consider using 'elementsd' instead"; # Added 2025-06-04

  elixir_ls = elixir-ls; # Added 2023-03-20

  # Emacs
  emacs28 = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28-gtk2 = throw "emacs28-gtk2 was removed because GTK2 is EOL; migrate to emacs28{,-gtk3,-nox} or to more recent versions of Emacs."; # Added 2024-09-20
  emacs28-gtk3 = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28-macport = throw "Emacs 28 Macport is removed due to CVEs which are fixed in Emacs 30 and backported to Emacs 29 Macport"; # Added 2025-04-06
  emacs28-nox = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacs28Packages = throw "'emacs28Packages' has been renamed to/replaced by 'emacs28.pkgs'"; # Converted to throw 2024-10-17
  emacs28WithPackages = throw "'emacs28WithPackages' has been renamed to/replaced by 'emacs28.pkgs.withPackages'"; # Converted to throw 2024-10-17
  emacs29 = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-gtk3 = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-nox = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-pgtk = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs; # Added 2022-06-08
  emacsWithPackages = throw "'emacsWithPackages' has been renamed to/replaced by 'emacs.pkgs.withPackages'"; # Converted to throw 2024-10-17
  emacsPackages = emacs.pkgs; # Added 2025-03-02

  EmptyEpsilon = empty-epsilon; # Added 2024-07-14
  enyo-doom = enyo-launcher; # Added 2022-09-09
  eolie = throw "'eolie' has been removed due to being unmaintained"; # Added 2025-04-15
  epapirus-icon-theme = throw "'epapirus-icon-theme' has been removed because 'papirus-icon-theme' no longer supports building with elementaryOS icon support"; # Added 2025-06-15
  epdfview = throw "'epdfview' has been removed due to lack of maintenance upstream. Consider using 'qpdfview' instead"; # Added 2024-10-19
  ephemeral = throw "'ephemeral' has been archived upstream since 2022-04-02"; # added 2025-04-12
  epoxy = throw "'epoxy' has been renamed to/replaced by 'libepoxy'"; # Converted to throw 2024-10-17

  erlang_24 = throw "erlang_24 has been removed as it is unmaintained upstream";
  erlang_27-rc3 = throw "erlang_27-rc3 has been removed in favor of erlang_27"; # added 2024-05-20
  erlang_nox = throw "erlang_nox has been removed in favor of beam_minimal.packages.erlang or beamMinimalPackages.erlang"; # added 2025-04-01
  erlangR24 = throw "erlangR24 has been removed in favor of erlang_24"; # added 2024-05-24
  erlangR24_odbc = throw "erlangR24_odbc has been removed in favor of erlang_24_odbc"; # added 2024-05-24
  erlangR24_javac = throw "erlangR24_javac has been removed in favor of erlang_24_javac"; # added 2024-05-24
  erlangR24_odbc_javac = throw "erlangR24_odbc_javac has been removed in favor of erlang_24_odbc_javac"; # added 2024-05-24
  erlang_25 = throw "erlang_25 has been removed as it is unmaintained upstream"; # added 2025-03-31
  erlangR25 = throw "erlangR25 has been removed as it is unmaintained upstream"; # added 2024-05-24
  erlangR25_odbc = throw "erlangR25_odbc has been removed as it is unmaintained upstream"; # added 2024-05-24
  erlangR25_javac = throw "erlangR25_javac has been removed as it is unmaintained upstream"; # added 2024-05-24
  erlangR25_odbc_javac = throw "erlangR25_odbc_javac has been removed as it is unmaintained upstream"; # added 2024-05-24
  erlangR26 = throw "erlangR26 has been removed in favor of erlang_26"; # added 2024-05-24
  erlangR26_odbc = throw "erlangR26_odbc has been removed in favor of erlang_26_odbc"; # added 2024-05-24
  erlangR26_javac = throw "erlangR26_javac has been removed in favor of erlang_26_javac"; # added 2024-05-24
  erlangR26_odbc_javac = throw "erlangR26_odbc_javac has been removed in favor of erlang_26_odbc_javac"; # added 2024-05-24

  erlang_language_platform = throw "erlang_language_platform has been renamed erlang-language-platform"; # added 2025-04-04

  est-sfs = throw "'est-sfs' has been removed as it was unmaintained in Nixpkgs"; # Added 2025-05-18

  ethabi = throw "ethabi has been removed due to lack of maintainence upstream and no updates in Nixpkgs"; # Added 2024-07-16
  eww-wayland = lib.warnOnInstantiate "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww;

  ### F ###

  f3d_egl = lib.warnOnInstantiate "'f3d' now build with egl support by default, so `f3d_egl` is deprecated, consider using 'f3d' instead." f3d; # added 2025-07-18
  factor-lang-scope = throw "'factor-lang-scope' has been renamed to 'factorPackages'"; # added 2024-11-28
  fahcontrol = throw "fahcontrol has been removed because the download is no longer available"; # added 2024-09-24
  fahviewer = throw "fahviewer has been removed because the download is no longer available"; # added 2024-09-24
  fam = throw "'fam' (aliased to 'gamin') has been removed as it is unmaintained upstream"; # Added 2024-04-19
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fastnlo = throw "'fastnlo' has been renamed to/replaced by 'fastnlo-toolkit'"; # Converted to throw 2024-10-17
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  fcitx5-catppuccin = catppuccin-fcitx5; # Added 2024-06-19
  fdr = throw "fdr has been removed, as it cannot be built from source and depends on Python 2.x"; # Added 2025-03-19
  inherit (luaPackages) fennel; # Added 2022-09-24
  ferdi = throw "'ferdi' has been removed, upstream does not exist anymore and the package is insecure"; # Added 2024-08-22
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  ffmpeg_5 = throw "ffmpeg_5 has been removed, please use another version"; # Added 2024-07-12
  ffmpeg_5-headless = throw "ffmpeg_5-headless has been removed, please use another version"; # Added 2024-07-12
  ffmpeg_5-full = throw "ffmpeg_5-full has been removed, please use another version"; # Added 2024-07-12
  FIL-plugins = fil-plugins; # Added 2024-06-12
  fileschanged = throw "'fileschanged' has been removed as it is unmaintained upstream"; # Added 2024-04-19
  filet = throw "'filet' has been removed as the upstream repo has been deleted"; # Added 2025-02-07
  finger_bsd = bsd-finger;
  fingerd_bsd = bsd-fingerd;
  fira-code-nerdfont = lib.warnOnInstantiate "fira-code-nerdfont is redundant. Use nerd-fonts.fira-code instead." nerd-fonts.fira-code; # Added 2024-11-10
  firebird_2_5 = throw "'firebird_2_5' has been removed as it has reached end-of-life and does not build."; # Added 2025-06-10
  firefox-beta-bin = lib.warnOnInstantiate "`firefox-beta-bin` is removed.  Please use `firefox-beta` or `firefox-bin` instead." firefox-beta;
  firefox-devedition-bin = lib.warnOnInstantiate "`firefox-devedition-bin` is removed.  Please use `firefox-devedition` or `firefox-bin` instead." firefox-devedition;
  firefox-esr-115 = throw "The Firefox 115 ESR series has reached its end of life. Upgrade to `firefox-esr` or `firefox-esr-128` instead.";
  firefox-esr-115-unwrapped = throw "The Firefox 115 ESR series has reached its end of life. Upgrade to `firefox-esr-unwrapped` or `firefox-esr-128-unwrapped` instead.";
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fit-trackee = fittrackee; # added 2024-09-03
  flashrom-stable = flashprog; # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flatcam = throw "flatcam has been removed because it is unmaintained since 2022 and doesn't support Python > 3.10"; # Added 2025-01-25
  flow-editor = flow-control; # Added 2025-03-05
  flutter313 = throw "flutter313 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter316 = throw "flutter316 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter319 = throw "flutter319 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-12-03
  flutter322 = throw "flutter322 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter323 = throw "flutter323 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter326 = throw "flutter326 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-06-08
  fluxctl = throw "fluxctl is unmaintained and has been removed. Migration to flux2 is recommended"; # Added 2025-05-11
  fluxus = throw "fluxus has been removed because it hasn't been updated in 9 years and depended on insecure Racket 7.9"; # Added 2024-12-06
  fmt_8 = throw "fmt_8 has been removed as it is obsolete and was no longer used in the tree"; # Added 2024-11-12
  fntsample = throw "fntsample has been removed as it is unmaintained upstream"; # Added 2025-04-21
  foldingathome = throw "'foldingathome' has been renamed to/replaced by 'fahclient'"; # Converted to throw 2024-10-17
  follow = lib.warnOnInstantiate "follow has been renamed to folo" folo; # Added 2025-05-18
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04
  fornalder = throw "'fornalder' has been removed as it is unmaintained upstream"; # Added 2025-01-25
  foundationdb71 = throw "foundationdb71 has been removed; please upgrade to foundationdb73"; # Added 2024-12-28

  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  francis = kdePackages.francis; # added 2024-07-13
  freecad-qt6 = freecad; # added 2025-06-14
  freecad-wayland = freecad; # added 2025-06-14
  freerdp3 = freerdp; # added 2025-03-25
  freerdpUnstable = freerdp; # added 2025-03-25
  frostwire = throw "frostwire was removed, as it was broken due to reproducibility issues, use `frostwire-bin` package instead."; # added 2024-05-17
  ftjam = throw "ftjam was removed, as it hasn't been updated since 2007 and fails to build"; # added 2025-01-02
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  fuse-common = throw "fuse-common was removed, because the udev rule was early included by systemd-udevd and the config is done by NixOS module `programs.fuse`"; # added 2024-09-29
  fusee-launcher = throw "'fusee-launcher' was removed as upstream removed the original source repository fearing legal repercussions"; # added 2025-07-05
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26

  fcitx5-chinese-addons = libsForQt5.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = libsForQt5.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = libsForQt5.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = libsForQt5.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = libsForQt5.fcitx5-with-addons; # Added 2024-03-01

  ### G ###

  g4music = gapless; # Added 2024-07-26
  g4py = throw "'g4py' has been renamed to/replaced by 'python3Packages.geant4'"; # Converted to throw 2024-10-17
  gamin = throw "'gamin' has been removed as it is unmaintained upstream"; # Added 2024-04-19
  garage_0_8 = throw "'garage_0_8' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_8_7 = throw "'garage_0_8_7' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_1_x = lib.warnOnInstantiate "'garage_1_x' has been renamed to 'garage_1'" garage_1; # Added 2025-06-23
  gbl = throw "'gbl' has been removed because the upstream repository no longer exists"; # Added 2025-01-26
  gcc48 = throw "gcc48 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-10
  gcc49 = throw "gcc49 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-11
  gcc49Stdenv = throw "gcc49Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-11
  gcc6 = throw "gcc6 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcc6Stdenv = throw "gcc6Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcc7 = throw "gcc7 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc7Stdenv = throw "gcc7Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc8 = throw "gcc8 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc8Stdenv = throw "gcc8Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc10StdenvCompat =
    if stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11" then gcc10Stdenv else stdenv; # Added 2024-03-21
  gcc-arm-embedded-6 = throw "gcc-arm-embedded-6 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-7 = throw "gcc-arm-embedded-7 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-8 = throw "gcc-arm-embedded-8 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-9 = throw "gcc-arm-embedded-9 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-10 = throw "gcc-arm-embedded-10 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-11 = throw "gcc-arm-embedded-11 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-12 = throw "gcc-arm-embedded-12 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcj = gcj6; # Added 2024-09-13
  gcj6 = throw "gcj6 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcolor2 = throw "'gcolor2' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'gcolor3' or 'eyedropper' instead"; # Added 2024-09-15
  gdome2 = throw "'gdome2' has been removed from nixpkgs, as it is umaintained and obsolete"; # Added 2024-12-29
  geocode-glib = throw "throw 'geocode-glib' has been removed, as it was unused and used outdated libraries"; # Added 2025-04-16
  geos_3_11 = throw "geos_3_11 has been removed from nixpgks. Please use a more recent 'geos' instead.";
  gfbgraph = throw "'gfbgraph' has been removed as it was archived upstream and unused in nixpkgs"; # Added 2025-04-20
  gfortran48 = throw "'gfortran48' has been removed from nixpkgs"; # Added 2024-09-10
  gfortran49 = throw "'gfortran49' has been removed from nixpkgs"; # Added 2024-09-11
  gfortran7 = throw "gfortran7 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gfortran8 = throw "gfortran8 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gg = go-graft; # Added 2025-03-07
  ggobi = throw "'ggobi' has been removed from Nixpkgs, as it is unmaintained and broken"; # Added 2025-05-18
  ghostwriter = makePlasma5Throw "ghostwriter"; # Added 2023-03-18
  git-annex-utils = throw "'git-annex-utils' has been removed as it is unmaintained"; # Added 2025-05-18
  git-codeowners = throw "'git-codeowners' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  gjay = throw "'gjay' has been removed as it is unmaintained upstream"; # Added 2025-05-25
  gmni = throw "gmni has been removed as it is no longer maintained upstream"; # Added 2025-05-02
  gmp5 = throw "'gmp5' has been removed as it is unmaintained. Consider using 'gmp' instead"; # Added 2024-10-28
  gmpc = throw "'gmpc' has been removed due to lack of maintenance upstream. Consider using 'plattenalbum' instead"; # Added 2024-09-14
  gmtk = throw "'gmtk' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  gmtp = throw "'gmtp' has been removed due to lack of maintenance upstream. Consider using 'gnome-music' instead"; # Added 2024-09-14
  gnome-latex = throw "'gnome-latex' has been superseded by 'enter-tex'"; # Added 2024-09-18
  gnome-settings-daemon43 = throw "'gnome-settings-daemon43' has been removed since it is no longer used by Pantheon."; # Added 2024-09-22
  gnu-cobol = gnucobol; # Added 2024-09-17
  gnupg1orig = throw "'gnupg1orig' has been removed due to lack of active upstream maintainance. Consider using 'gnupg' instead"; # Added 2025-01-11
  gnupg22 = throw "'gnupg22' is end-of-life. Consider using 'gnupg24' instead"; # Added 2025-01-05
  go_1_22 = throw "Go 1.22 is end-of-life and 'go_1_22' has been removed. Please use a newer Go toolchain."; # Added 2024-03-28
  gogs = throw ''
    Gogs development has stalled. Also, it has several unpatched, critical vulnerabilities that
    weren't addressed within a year: https://github.com/gogs/gogs/issues/7777

    Consider migrating to forgejo or gitea.
  ''; # Added 2024-10-12
  git-backup = throw "git-backup has been removed, as it has been abandoned upstream. Consider using git-backup-go instead.";
  git-credential-1password = throw "'git-credential-1password' has been removed, as the upstream project is deleted."; # Added 2024-05-20
  git-stree = throw "'git-stree' has been deprecated by upstream. Upstream recommends using 'git-subrepo' as a replacement."; # Added 2025-05-05

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14
  github-copilot-cli = throw "'github-copilot-cli' has been removed because GitHub has replaced it with 'gh-copilot'."; # Added 2025-06-01
  givaro_3 = throw "'givaro_3' has been removed as it is end-of-life. Consider using the up-to-date 'givaro' instead"; # Added 2025-05-07
  givaro_3_7 = throw "'givaro_3_7' has been removed as it is end-of-life. Consider using the up-to-date 'givaro' instead"; # Added 2025-05-07
  gkraken = throw "'gkraken' has been deprecated by upstream. Consider using the replacement 'coolercontrol' instead."; # Added 2024-11-22
  glew-egl = lib.warnOnInstantiate "'glew-egl' is now provided by 'glew' directly" glew; # Added 2024-08-11
  glfw-wayland = glfw; # Added 2024-04-19
  glfw-wayland-minecraft = glfw3-minecraft; # Added 2024-05-08
  glxinfo = mesa-demos; # Added 2024-07-04
  gmailieer = throw "'gmailieer' has been renamed to/replaced by 'lieer'"; # Converted to throw 2024-10-17
  gmnisrv = throw "'gmnisrv' has been removed due to lack of maintenance upstream"; # Added 2025-06-07
  gmp4 = throw "'gmp4' is end-of-life, consider using 'gmp' instead"; # Added 2024-12-24
  gnatboot11 = gnat-bootstrap11;
  gnatboot12 = gnat-bootstrap12;
  gnatboot = gnat-bootstrap;
  gnatcoll-core = gnatPackages.gnatcoll-core; # Added 2024-02-25
  gnatcoll-gmp = gnatPackages.gnatcoll-gmp; # Added 2024-02-25
  gnatcoll-iconv = gnatPackages.gnatcoll-iconv; # Added 2024-02-25
  gnatcoll-lzma = gnatPackages.gnatcoll-lzma; # Added 2024-02-25
  gnatcoll-omp = gnatPackages.gnatcoll-omp; # Added 2024-02-25
  gnatcoll-python3 = gnatPackages.gnatcoll-python3; # Added 2024-02-25
  gnatcoll-readline = gnatPackages.gnatcoll-readline; # Added 2024-02-25
  gnatcoll-syslog = gnatPackages.gnatcoll-syslog; # Added 2024-02-25
  gnatcoll-zlib = gnatPackages.gnatcoll-zlib; # Added 2024-02-25
  gnatcoll-postgres = gnatPackages.gnatcoll-postgres; # Added 2024-02-25
  gnatcoll-sql = gnatPackages.gnatcoll-sql; # Added 2024-02-25
  gnatcoll-sqlite = gnatPackages.gnatcoll-sqlite; # Added 2024-02-25
  gnatcoll-xref = gnatPackages.gnatcoll-xref; # Added 2024-02-25
  gnatcoll-db2ada = gnatPackages.gnatcoll-db2ada; # Added 2024-02-25
  gnatinspect = gnatPackages.gnatinspect; # Added 2024-02-25
  gnome-dictionary = throw "'gnome-dictionary' has been removed as it has been archived upstream. Consider using 'wordbook' instead"; # Added 2024-09-14
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-hexgl = throw "'gnome-hexgl' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome_mplayer = throw "'gnome_mplayer' has been removed due to lack of maintenance upstream. Consider using 'celluloid' instead"; # Added 2024-09-14
  gnome-resources = resources; # added 2023-12-10

  gmock = throw "'gmock' has been renamed to/replaced by 'gtest'"; # Converted to throw 2024-10-17

  gnome3 = throw "'gnome3' has been renamed to/replaced by 'gnome'"; # Converted to throw 2024-10-17
  gnufdisk = throw "'gnufdisk' has been removed due to lack of maintenance upstream"; # Added 2024-12-31
  gnuradio3_9 = throw "gnuradio3_9 has been removed because it is not compatible with the latest volk and it had no dependent packages which justified its distribution"; # Added 2024-07-28
  gnuradio3_9Minimal = throw "gnuradio3_9Minimal has been removed because it is not compatible with the latest volk and it had no dependent packages which justified its distribution"; # Added 2024-07-28
  gnuradio3_9Packages = throw "gnuradio3_9Minimal has been removed because it is not compatible with the latest volk and it had no dependent packages which justified its distribution"; # Added 2024-07-28
  gnuradio3_8 = throw "gnuradio3_8 has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gnuradio3_8Minimal = throw "gnuradio3_8Minimal has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gnuradio3_8Packages = throw "gnuradio3_8Minimal has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gnustep = throw "The gnustep scope has been replaced with top-level packages: gnustep-back, -base, -gui, -libobjc, -make, -systempreferences; gorm, gworkspace, projectcenter."; # Added 2025-01-25
  gn1924 = throw "gn1924 has been removed because it was broken and no longer used by envoy."; # Added 2024-11-03
  gobby5 = throw "'gobby5' has been renamed to/replaced by 'gobby'"; # Converted to throw 2024-10-17
  gradle_6 = throw "Gradle 6 has been removed, as it is end-of-life (https://endoflife.date/gradle) and has many vulnerabilities that are not resolved until Gradle 7."; # Added 2024-10-30
  gradle_6-unwrapped = throw "Gradle 6 has been removed, as it is end-of-life (https://endoflife.date/gradle) and has many vulnerabilities that are not resolved until Gradle 7."; # Added 2024-10-30
  grafana-agent = throw "'grafana-agent' has been removed, as it only works with an EOL compiler and will become EOL during the 25.05 release. Consider migrating to 'grafana-alloy' instead"; # Added 2025-04-02

  #godot
  godot_4_3-export-templates = lib.warnOnInstantiate "godot_4_3-export-templates has been renamed to godot_4_3-export-templates-bin" godot_4_3-export-templates-bin;
  godot_4_4-export-templates = lib.warnOnInstantiate "godot_4_4-export-templates has been renamed to godot_4_4-export-templates-bin" godot_4_4-export-templates-bin;
  godot_4-export-templates = lib.warnOnInstantiate "godot_4-export-templates has been renamed to godot_4-export-templates-bin" godot_4-export-templates-bin;
  godot-export-templates = lib.warnOnInstantiate "godot-export-templates has been renamed to godot-export-templates-bin" godot-export-templates-bin;

  go-thumbnailer = thud; # Added 2023-09-21
  go-upower-notify = upower-notify; # Added 2024-07-21
  googler = throw "'googler' has been removed, as it no longer works and is abandoned upstream"; # Added 2025-04-01
  gpicview = throw "'gpicview' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'loupe', 'gthumb' or 'image-roll' instead"; # Added 2024-09-15
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25;

  gqview = throw "'gqview' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'gthumb' instead";
  graalvmCEPackages = graalvmPackages; # Added 2024-08-10
  graalvm-ce = graalvmPackages.graalvm-ce; # Added 2024-08-10
  graalvm-oracle = graalvmPackages.graalvm-oracle; # Added 2024-12-17
  grafana_reporter = grafana-reporter; # Added 2024-06-09
  grapefruit = throw "'grapefruit' was removed due to being blocked by Roblox, rendering the package useless"; # Added 2024-08-23
  graylog-3_3 = throw "graylog 3.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 3.x to latest series."; # Added 2023-10-09
  graylog-4_0 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-4_3 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-5_0 = throw "graylog 5.0.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.0.x to latest series."; # Added 2024-02-15
  graylog-5_1 = throw "graylog 5.1.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.1.x to latest series."; # Added 2024-10-16
  graylog-5_2 = throw "graylog 5.2 is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.2 to latest series."; # Added 2025-03-21
  green-pdfviewer = throw "'green-pdfviewer' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  gringo = clingo; # added 2022-11-27
  grub2_full = grub2; # Added 2022-11-18
  grun = throw "grun has been removed due to lack of maintenance upstream and depending on gtk2"; # Added 2025-03-29
  gsignond = throw "'gsignond' and its plugins have been removed due to lack of maintenance upstream"; # added 2025-04-17
  gsignondPlugins = throw "'gsignondPlugins' have been removed alongside 'gsignond' due to lack of maintenance upstream and depending on libsoup_2"; # added 2025-04-17
  gtetrinet = throw "'gtetrinet' has been removed because it depends on GNOME 2 libraries"; # Added 2024-06-27
  gtk-engine-bluecurve = throw "'gtk-engine-bluecurve' has been removed as it has been archived upstream."; # Added 2024-12-04
  gtk2fontsel = throw "'gtk2fontsel' has been removed due to lack of maintenance upstream. GTK now has a built-in font chooser so it's no longer needed for newer apps"; # Added 2024-10-19
  gtkcord4 = dissent; # Added 2024-03-10
  gtkextra = throw "'gtkextra' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  gtkperf = throw "'gtkperf' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  guardian-agent = throw "'guardian-agent' has been removed, as it hasn't been maintained upstream in years and accumulated many vulnerabilities"; # Added 2024-06-09
  guile-disarchive = disarchive; # Added 2023-10-27

  ### H ###

  hacksaw = throw "'hacksaw' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  haka = throw "haka has been removed because it failed to build and was unmaintained for 9 years"; # Added 2025-03-11
  hardinfo = throw "'hardinfo' has been removed as it was abandoned upstream. Consider using 'hardinfo2' instead."; # added 2025-04-17
  hasura-graphql-engine = throw "hasura-graphql-engine has been removed because was broken and its packaging severly out of date"; # Added 2025-02-14
  haven-cli = throw "'haven-cli' has been removed due to the official announcement of the project closure. Read more at https://havenprotocol.org/2024/12/12/project-closure-announcement"; # Added 2025-02-25
  hawknl = throw "'hawknl' has been removed as it was unmaintained and the upstream unavailable"; # Added 2025-05-07
  HentaiAtHome = hentai-at-home; # Added 2024-06-12
  hll2390dw-cups = throw "The hll2390dw-cups package was dropped since it was unmaintained."; # Added 2024-06-21
  hoarder = throw "'hoarder' has been renamed to 'karakeep'"; # Added 2025-04-21
  hmetis = throw "'hmetis' has been removed as it was unmaintained and the upstream was unavailable"; # Added 2025-05-05
  hop-cli = throw "hop-cli has been removed as the service has been shut-down"; # Added 2024-08-13
  hpp-fcl = coal; # Added 2024-11-15
  ht-rust = throw "'ht-rust' has been renamed to/replaced by 'xh'"; # Converted to throw 2024-10-17
  hydra_unstable = hydra; # Added 2024-08-22
  hydron = throw "hydron has been removed as the project has been archived upstream since 2022 and is affected by a severe remote code execution vulnerability";
  hyenae = throw "hyenae has been removed because it fails to build and was unmaintained for 15 years"; # Added 2025-04-04
  hyprgui = throw "hyprgui has been removed as the repository is deleted"; # Added 2024-12-27
  hyprlauncher = throw "hyprlauncher has been removed as the repository is deleted"; # Added 2024-12-27
  hyprswitch = throw "hyprswitch has been renamed to hyprshell"; # Added 2025-06-01
  hyprwall = throw "hyprwall has been removed as the repository is deleted"; # Added 2024-12-27

  ### I ###

  i3-gaps = i3; # Added 2023-01-03
  i3nator = throw "'i3nator' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  ibniz = throw "ibniz has been removed because it fails to compile and the source url is dead"; # Added 2025-04-07
  ib-tws = throw "ib-tws has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  ib-controller = throw "ib-controller has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  icuReal = throw "icuReal has been removed from nixpkgs as a mistake"; # Added 2025-02-18
  imagemagick7Big = throw "'imagemagick7Big' has been renamed to/replaced by 'imagemagickBig'"; # Converted to throw 2024-10-17
  imagemagick7 = throw "'imagemagick7' has been renamed to/replaced by 'imagemagick'"; # Converted to throw 2024-10-17
  imagemagick7_light = throw "'imagemagick7_light' has been renamed to/replaced by 'imagemagick_light'"; # Converted to throw 2024-10-17
  immersed-vr = lib.warnOnInstantiate "'immersed-vr' has been renamed to 'immersed'" immersed; # Added 2024-08-11
  inconsolata-nerdfont = lib.warnOnInstantiate "inconsolata-nerdfont is redundant. Use nerd-fonts.inconsolata instead." nerd-fonts.inconsolata; # Added 2024-11-10
  incrtcl = tclPackages.incrtcl; # Added 2024-10-02
  input-utils = throw "The input-utils package was dropped since it was unmaintained."; # Added 2024-06-21
  index-fm = libsForQt5.mauiPackages.index; # added 2022-05-17
  inotifyTools = inotify-tools;
  insync-emblem-icons = throw "'insync-emblem-icons' has been removed, use 'insync-nautilus' instead"; # Added 2025-05-14
  inter-ui = throw "'inter-ui' has been renamed to/replaced by 'inter'"; # Converted to throw 2024-10-17
  ioccheck = throw "ioccheck was dropped since it was unmaintained."; # Added 2025-07-06
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  iproute = throw "'iproute' has been renamed to/replaced by 'iproute2'"; # Converted to throw 2024-10-17
  irrlichtmt = throw "irrlichtmt has been removed because it was moved into the Minetest repo"; # Added 2024-08-12
  isl_0_11 = throw "isl_0_11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  isl_0_14 = throw "isl_0_14 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  isl_0_17 = throw "isl_0_17 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  istatmenus = throw "istatmenus has beend renamed to istat-menus"; # Added 2025-05-05
  iso-flags-png-320x420 = lib.warnOnInstantiate "iso-flags-png-320x420 has been renamed to iso-flags-png-320x240" iso-flags-png-320x240; # Added 2024-07-17
  itktcl = tclPackages.itktcl; # Added 2024-10-02
  iv = throw "iv has been removed as it was no longer required for neuron and broken"; # Added 2025-04-18
  ix = throw "ix has been removed from Nixpkgs, as the ix.io pastebin has been offline since Dec. 2023"; # Added 2025-04-11

  ### J ###

  jack2Full = throw "'jack2Full' has been renamed to/replaced by 'jack2'"; # Converted to throw 2024-10-17
  jack_rack = throw "'jack_rack' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jami-client-qt = jami-client; # Added 2022-11-06
  jami-client = jami; # Added 2023-02-10
  jami-daemon = jami.daemon; # Added 2023-02-10
  javacard-devkit = throw "javacard-devkit was dropped due to having a dependency on the Oracle JDK, as well as being several years out-of-date."; # Added 2024-11-01
  jd-cli = throw "jd-cli has been removed due to upstream being unmaintained since 2019. Other Java decompilers in Nixpkgs include bytecode-viewer (GUI), cfr (CLI), and procyon (CLI)."; # Added 2024-10-30
  jd-gui = throw "jd-gui has been removed due to a dependency on the dead JCenter Bintray. Other Java decompilers in Nixpkgs include bytecode-viewer (GUI), cfr (CLI), and procyon (CLI)."; # Added 2024-10-30
  jikespg = throw "'jikespg' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jsawk = throw "'jsawk' has been removed because it is unmaintained upstream"; # Added 2028-08-07

  # Julia
  julia_16-bin = throw "'julia_16-bin' has been removed from nixpkgs as it has reached end of life"; # Added 2024-10-08

  jush = throw "jush has been removed from nixpkgs because it is unmaintained"; # Added 2024-05-28

  ### K ###

  k3s_1_26 = throw "'k3s_1_26' has been removed from nixpkgs as it has reached end of life"; # Added 2024-05-20
  k3s_1_27 = throw "'k3s_1_27' has been removed from nixpkgs as it has reached end of life on 2024-06-28"; # Added 2024-06-01
  k3s_1_28 = throw "'k3s_1_28' has been removed from nixpkgs as it has reached end of life"; # Added 2024-12-15
  k3s_1_29 = throw "'k3s_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016" Added 2022-01-04
  # now kube3d/k3d will take its place
  kube3d = k3d; # Added 2022-0705
  kafkacat = throw "'kafkacat' has been renamed to/replaced by 'kcat'"; # Converted to throw 2024-10-17
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kanidm_1_3 = throw "'kanidm_1_3' has been removed as it has reached end of life"; # Added 2025-03-10
  kanidm_1_4 = throw "'kanidm_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kanidmWithSecretProvisioning_1_4 = throw "'kanidmWithSecretProvisioning_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kdbplus = throw "'kdbplus' has been removed from nixpkgs"; # Added 2024-05-06
  kdeconnect = throw "'kdeconnect' has been renamed to/replaced by 'plasma5Packages.kdeconnect-kde'"; # Converted to throw 2024-10-17
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kerberos = throw "'kerberos' has been renamed to/replaced by 'krb5'"; # Converted to throw 2024-10-17
  kexectools = throw "'kexectools' has been renamed to/replaced by 'kexec-tools'"; # Converted to throw 2024-10-17
  keyfinger = throw "keyfinder has been removed as it was abandoned upstream and did not build; consider using mixxx or keyfinder-cli"; # Addd 2024-08-25
  keysmith = throw "'keysmith' has been renamed to/replaced by 'libsForQt5.kdeGear.keysmith'"; # Converted to throw 2024-10-17
  kgx = gnome-console; # Added 2022-02-19
  kibana7 = throw "Kibana 7.x has been removed from nixpkgs as it depends on an end of life Node.js version and received no maintenance in time."; # Added 2023-30-10
  kibana = kibana7;
  kio-admin = makePlasma5Throw "kio-admin"; # Added 2023-03-18
  kiwitalk = throw "KiwiTalk has been removed because the upstream has been deprecated at the request of Kakao and it's now obsolete."; # Added 2024-10-10
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  kramdown-rfc2629 = throw "'kramdown-rfc2629' has been renamed to/replaced by 'rubyPackages.kramdown-rfc2629'"; # Converted to throw 2024-10-17
  krb5Full = krb5;
  kreative-square-fonts = throw "'kreative-square-fonts' has been renamed to 'kreative-square'"; # Added 2025-04-16
  krita-beta = throw "'krita-beta' has been renamed to/replaced by 'krita'"; # Converted to throw 2024-10-17
  krun = throw "'krun' has been renamed to/replaced by 'muvm'"; # Added 2025-05-01
  kubei = kubeclarity; # Added 2023-05-20
  kubo-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2024-09-24

  ### L ###

  l3afpad = throw "'l3afpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead"; # Added 2024-09-14
  larynx = piper-tts; # Added 2023-05-09
  LASzip = laszip; # Added 2024-06-12
  LASzip2 = laszip_2; # Added 2024-06-12
  lanzaboote-tool = throw "lanzaboote-tool has been removed due to lack of integration maintenance with nixpkgs. Consider using the Nix expressions provided by https://github.com/nix-community/lanzaboote"; # Added 2025-07-23
  latencytop = throw "'latencytop' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  latinmodern-math = lmmath;
  lazarus-qt = lazarus-qt5; # Added 2024-12-25
  leafpad = throw "'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead"; # Added 2024-10-19
  ledger_agent = ledger-agent; # Added 2024-01-07
  lesstif = throw "'lesstif' has been removed due to its being broken and unmaintained upstream. Consider using 'motif' instead."; # Added 2024-06-09
  lfs = dysk; # Added 2023-07-03
  libAfterImage = throw "'libAfterImage' has been removed from nixpkgs, as it's no longer in development for a long time"; # Added 2024-06-01
  libast = throw "'libast' has been removed due to lack of maintenance upstream."; # Added 2025-06-09
  libav = throw "libav has been removed as it was insecure and abandoned upstream for over half a decade; please use FFmpeg"; # Added 2024-08-25
  libav_0_8 = libav; # Added 2024-08-25
  libav_11 = libav; # Added 2024-08-25
  libav_12 = libav; # Added 2024-08-25
  libav_all = libav; # Added 2024-08-25
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libbitcoin = throw "libbitcoin has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-client = throw "libbitcoin-client has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-explorer = throw "libbitcoin-explorer has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-network = throw "libbitcoin-network has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-protocol = throw "libbitcoin-protocol has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libchop = throw "libchop has been removed due to failing to build and being unmaintained upstream"; # Added 2025-05-02
  libdwarf-lite = throw "`libdwarf-lite` has been replaced by `libdwarf` as it's mostly a mirror"; # Added 2025-06-16
  libdwg = throw "libdwg has been removed as upstream is unmaintained, the code doesn't build without significant patches, and the package had no reverse dependencies"; # Added 2024-12-28
  libfpx = throw "libfpx has been removed as it was unmaintained in Nixpkgs and had known vulnerabilities"; # Added 2025-05-20
  libgadu = throw "'libgadu' has been removed as upstream is unmaintained and has no dependents or maintainers in Nixpkgs"; # Added 2025-05-17
  libgcrypt_1_8 = throw "'libgcrypt_1_8' is end-of-life. Consider using 'libgcrypt' instead"; # Added 2025-01-05
  libgda = lib.warnOnInstantiate "‘libgda’ has been renamed to ‘libgda5’" libgda5; # Added 2025-01-21
  libgme = game-music-emu; # Added 2022-07-20
  libgnome-keyring3 = libgnome-keyring; # Added 2024-06-22
  libgpgerror = throw "'libgpgerror' has been renamed to/replaced by 'libgpg-error'"; # Converted to throw 2024-10-17
  libgrss = throw "'libgrss' has been removed as it was archived upstream and had no users in nixpkgs"; # Added 2025-04-17
  libheimdal = heimdal; # Added 2022-11-18
  libhttpseverywhere = throw "'libhttpseverywhere' has been removed due to lack of upstream maintenance. It was no longer used in nixpkgs."; # Added 2025-04-17
  libiconv-darwin = darwin.libiconv;
  libixp_hg = libixp;
  libjpeg_drop = throw "'libjpeg_drop' has been renamed to/replaced by 'libjpeg_original'"; # Converted to throw 2024-10-17
  liblastfm = throw "'liblastfm' has been renamed to/replaced by 'libsForQt5.liblastfm'"; # Converted to throw 2024-10-17
  libmp3splt = throw "'libmp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  libmx = throw "'libmx' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  liboop = throw "liboop has been removed as it is unmaintained upstream."; # Added 2024-08-14
  libosmo-sccp = libosmo-sigtran; # Added 2024-12-20
  libpqxx_6 = throw "libpqxx_6 has been removed, please use libpqxx"; # Added 2024-10-02
  libpromhttp = throw "'libpromhttp' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-16
  libpseudo = throw "'libpseudo' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqt5pas = libsForQt5.libqtpas; # Added 2024-12-25
  libquotient = throw "'libquotient' for qt5 was removed as upstream removed qt5 support. Consider explicitly upgrading to qt6 'libquotient'"; # Converted to throw 2025-07-04
  librarian-puppet-go = throw "'librarian-puppet-go' has been removed, as its upstream is unmaintained"; # Added 2024-06-10
  librdf = throw "'librdf' has been renamed to/replaced by 'lrdf'"; # Converted to throw 2024-10-17
  librdf_raptor = throw "librdf_raptor has been remove due to failing to build and being unmaintained"; # Added 2025-04-14
  LibreArp = librearp; # Added 2024-06-12
  LibreArp-lv2 = librearp-lv2; # Added 2024-06-12
  libreddit = throw "'libreddit' has been removed because it is unmaintained upstream. Consider using 'redlib', a maintained fork"; # Added 2024-07-17
  librtlsdr = rtl-sdr; # Added 2023-02-18
  librewolf-wayland = librewolf; # Added 2022-11-15
  libseat = throw "'libseat' has been renamed to/replaced by 'seatd'"; # Converted to throw 2024-10-17
  libsForQt515 = libsForQt5; # Added 2022-11-24
  libsoup = lib.warnOnInstantiate "‘libsoup’ has been renamed to ‘libsoup_2_4’" libsoup_2_4; # Added 2024-12-02
  libstdcxx5 = throw "libstdcxx5 is severly outdated and has been removed"; # Added 2024-11-24
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libtorrentRasterbar = throw "'libtorrentRasterbar' has been renamed to/replaced by 'libtorrent-rasterbar'"; # Converted to throw 2024-10-17
  libtorrentRasterbar-1_2_x = throw "'libtorrentRasterbar-1_2_x' has been renamed to/replaced by 'libtorrent-rasterbar-1_2_x'"; # Converted to throw 2024-10-17
  libtorrentRasterbar-2_0_x = throw "'libtorrentRasterbar-2_0_x' has been renamed to/replaced by 'libtorrent-rasterbar-2_0_x'"; # Converted to throw 2024-10-17
  libungif = throw "'libungif' has been renamed to/replaced by 'giflib'"; # Converted to throw 2024-10-17
  libusb = throw "'libusb' has been renamed to/replaced by 'libusb1'"; # Converted to throw 2024-10-17
  libvpx_1_8 = throw "libvpx_1_8 has been removed because it is impacted by security issues and not used in nixpkgs, move to 'libvpx'"; # Added 2024-07-26
  libwnck3 = libwnck;
  libxplayer-plparser = throw "libxplayer-plparser has been removed as the upstream project was archived"; # Added 2024-12-27
  libyamlcpp = yaml-cpp; # Added 2023-01-29
  libyamlcpp_0_3 = yaml-cpp_0_3; # Added 2023-01-29
  libzapojit = throw "'libzapojit' has been removed due to lack of upstream maintenance and archival"; # Added 2025-04-16
  licensor = throw "'licensor' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lightstep-tracer-cpp = throw "lightstep-tracer-cpp is deprecated since 2022-08-29; the upstream recommends migration to opentelemetry projects.";
  ligo = throw "ligo has been removed from nixpkgs for lack of maintainance"; # Added 2025-06-03
  lima-bin = lib.warnOnInstantiate "lima-bin has been replaced by lima" lima; # Added 2025-05-13
  lime3ds = throw "lime3ds is deprecated, use 'azahar' instead."; # Added 2025-03-22
  limesctl = throw "limesctl has been removed because it is insignificant."; # Added 2024-11-25
  linenoise-ng = throw "'linenoise-ng' has been removed as the upstream project was archived. Consider using 'linenoise' instead."; # Added 2025-05-05
  lispPackages_new = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackages = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackagesFor = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  litecoin = throw "litecoin has been removed as nobody was maintaining it and the packaged version had known vulnerabilities"; # Added 2024-11-24
  litecoind = throw "litecoind has been removed as nobody was maintaining it and the packaged version had known vulnerabilities"; # Added 2024-11-24
  Literate = literate; # Added 2024-06-12
  llama = walk; # Added 2023-01-23

  # Linux kernels
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_15 = linuxKernel.kernels.linux_rt_5_15;
  linux-rt_5_4 = linuxKernel.kernels.linux_rt_5_4;
  linux-rt_6_1 = linuxKernel.kernels.linux_rt_6_1;
  linuxPackages_4_19 = linuxKernel.packages.linux_4_19;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_9 = linuxKernel.packages.linux_6_9;
  linuxPackages_6_10 = linuxKernel.packages.linux_6_10;
  linuxPackages_6_11 = linuxKernel.packages.linux_6_11;
  linuxPackages_6_12 = linuxKernel.packages.linux_6_12;
  linuxPackages_6_13 = linuxKernel.packages.linux_6_13;
  linuxPackages_6_14 = linuxKernel.packages.linux_6_14;
  linuxPackages_6_15 = linuxKernel.packages.linux_6_15;
  linuxPackages_6_16 = linuxKernel.packages.linux_6_16;
  linuxPackages_ham = linuxKernel.packages.linux_ham;
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi02w = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi1 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi2 = linuxKernel.packages.linux_rpi2;
  linuxPackages_rpi3 = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi4 = linuxKernel.packages.linux_rpi4;
  linuxPackages_rt_5_10 = linuxKernel.packages.linux_rt_5_10;
  linuxPackages_rt_5_15 = linuxKernel.packages.linux_rt_5_15;
  linuxPackages_rt_5_4 = linuxKernel.packages.linux_rt_5_4;
  linuxPackages_rt_6_1 = linuxKernel.packages.linux_rt_6_1;
  linux_4_19 = linuxKernel.kernels.linux_4_19;
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_9 = linuxKernel.kernels.linux_6_9;
  linux_6_10 = linuxKernel.kernels.linux_6_10;
  linux_6_11 = linuxKernel.kernels.linux_6_11;
  linux_6_12 = linuxKernel.kernels.linux_6_12;
  linux_6_13 = linuxKernel.kernels.linux_6_13;
  linux_6_14 = linuxKernel.kernels.linux_6_14;
  linux_6_15 = linuxKernel.kernels.linux_6_15;
  linux_6_16 = linuxKernel.kernels.linux_6_16;
  linux_ham = linuxKernel.kernels.linux_ham;
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi02w = linuxKernel.kernels.linux_rpi3;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;

  # Added 2021-04-04
  linuxPackages_xen_dom0 = linuxPackages;
  linuxPackages_latest_xen_dom0 = linuxPackages_latest;
  linuxPackages_xen_dom0_hardened = linuxPackages_hardened;
  linuxPackages_latest_xen_dom0_hardened = linuxPackages_latest_hardened;

  # Added 2021-08-16
  linuxPackages_6_13_hardened = linuxKernel.packages.linux_6_13_hardened;
  linux_6_13_hardened = linuxKernel.kernels.linux_6_13_hardened;
  linuxPackages_6_14_hardened = linuxKernel.packages.linux_6_14_hardened;
  linux_6_14_hardened = linuxKernel.kernels.linux_6_14_hardened;
  linuxPackages_latest_hardened = throw ''
    The attribute `linuxPackages_hardened_latest' was dropped because the hardened patches
    frequently lag behind the upstream kernel. In some cases this meant that this attribute
    had to refer to an older kernel[1] because the latest hardened kernel was EOL and
    the latest supported kernel didn't have patches.

    If you want to use a hardened kernel, please check which kernel minors are supported
    and use a versioned attribute, e.g. `linuxPackages_5_10_hardened'.

    [1] for more context: https://github.com/NixOS/nixpkgs/pull/133587
  '';
  linux_latest_hardened = linuxPackages_latest_hardened;

  # Added 2023-11-18, modified 2024-01-09
  linuxPackages_testing_bcachefs = throw "'linuxPackages_testing_bcachefs' has been removed, please use 'linuxPackages_latest', any kernel version at least 6.7, or any other linux kernel with bcachefs support";
  linux_testing_bcachefs = throw "'linux_testing_bcachefs' has been removed, please use 'linux_latest', any kernel version at least 6.7, or any other linux kernel with bcachefs support";

  linuxstopmotion = stopmotion; # Added 2024-11-01

  lixVersions = lixPackageSets.renamedDeprecatedLixVersions; # Added 2025-03-20, warning in ../tools/package-management/lix/default.nix

  llvmPackages_git = (callPackages ../development/compilers/llvm { }).git;

  lld_9 = throw "lld_9 has been removed from nixpkgs"; # Added 2024-04-08
  lldb_9 = throw "lldb_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvmPackages_9 = throw "llvmPackages_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvm_9 = throw "llvm_9 has been removed from nixpkgs"; # Added 2024-04-08

  lobster-two = throw "'lobster-two' has been renamed to/replaced by 'google-fonts'"; # Converted to throw 2024-10-17
  loc = throw "'loc' has been removed due to lack of upstream maintenance. Consider 'tokei' as an alternative."; # Added 2025-01-25
  loco-cli = loco; # Added 2025-02-24
  loop = throw "'loop' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  ltwheelconf = throw "'ltwheelconf' has been removed because it is obsolete"; # Added 2025-05-07
  luna-icons = throw "luna-icons has been removed as it was removed upstream"; # Added 2024-10-29
  lucene = throw "lucene has been removed since it was both wildly out of date and was not even built properly for 4 years"; # Added 2025-04-10
  lumail = throw "'lumail' has been removed since its upstream is unavailable"; # Added 2025-05-07
  lv_img_conv = throw "'lv_img_conv' has been removed from nixpkgs as it is broken"; # Added 2024-06-18
  lxd = lib.warnOnInstantiate "lxd has been renamed to lxd-lts" lxd-lts; # Added 2024-04-01
  lxd-unwrapped = lib.warnOnInstantiate "lxd-unwrapped has been renamed to lxd-unwrapped-lts" lxd-unwrapped-lts; # Added 2024-04-01
  lxdvdrip = throw "'lxdvdrip' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  lzma = throw "'lzma' has been renamed to/replaced by 'xz'"; # Converted to throw 2024-10-17
  lzwolf = throw "'lzwolf' has been removed because it's no longer maintained upstream. Consider using 'ecwolf'"; # Added 2025-03-02

  ### M ###

  ma1sd = throw "ma1sd was dropped as it is unmaintained"; # Added 2024-07-10
  mac = monkeysAudio; # Added 2024-11-30
  MACS2 = macs2; # Added 2023-06-12
  magma_2_6_2 = throw "'magma_2_6_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  magma_2_7_2 = throw "'magma_2_7_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  mailcore2 = throw "'mailcore2' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mailctl = throw "mailctl has been renamed to oama"; # Added 2024-08-19
  mailman-rss = throw "The mailman-rss package was dropped since it was unmaintained."; # Added 2024-06-21
  mariadb_105 = throw "'mariadb_105' has been removed because it reached its End of Life. Consider upgrading to 'mariadb_106'."; # Added 2025-04-26
  mariadb_110 = throw "mariadb_110 has been removed from nixpkgs, please switch to another version like mariadb_114"; # Added 2024-08-15
  mariadb-client = hiPrio mariadb.client; # added 2019.07.28
  maligned = throw "maligned was deprecated upstream in favor of x/tools/go/analysis/passes/fieldalignment"; # Added 20204-08-24
  manicode = throw "manicode has been renamed to codebuff"; # Added 2024-12-10
  manta = throw "manta does not support python3, and development has been abandoned upstream"; # Added 2025-03-17
  manticore = throw "manticore is no longer maintained since 2020, and doesn't build since smlnj-110.99.7.1"; # Added 2025-05-17

  maple-mono-NF = throw ''
    maple-mono-NF had been moved to maple-mono.NF.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  '';
  maple-mono-otf = throw ''
    maple-mono-otf had been moved to maple-mono.opentype.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  '';
  maple-mono-woff2 = throw ''
    maple-mono-woff2 had been moved to maple-mono.woff2.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  '';
  maple-mono-SC-NF = throw ''
    mono-SC-NF had been superseded by maple-mono.NF-CN.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  '';
  maple-mono-autohint = throw ''
    maple-mono-autohint had been moved to maple-mono.truetype-autohint.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  '';

  mapmap = throw "'mapmap' has been removed as it has been unmaintained since 2021";
  markets = throw "'markets' has been removed as it was archived upstream in 2023"; # Added 2025-04-17
  marwaita-manjaro = lib.warnOnInstantiate "marwaita-manjaro has been renamed to marwaita-teal" marwaita-teal; # Added 2024-07-08
  marwaita-peppermint = lib.warnOnInstantiate "marwaita-peppermint has been renamed to marwaita-red" marwaita-red; # Added 2024-07-01
  marwaita-ubuntu = lib.warnOnInstantiate "marwaita-ubuntu has been renamed to marwaita-orange" marwaita-orange; # Added 2024-07-08
  marwaita-pop_os = lib.warnOnInstantiate "marwaita-pop_os has been renamed to marwaita-yellow" marwaita-yellow; # Added 2024-10-29
  masari = throw "masari has been removed as it was abandoned upstream"; # Added 2024-07-11
  mathematica9 = throw "mathematica9 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  mathematica10 = throw "mathematica10 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  mathematica11 = throw "mathematica11 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  matomo_5 = matomo; # Added 2024-12-12
  matomo-beta = throw "matomo-beta has been removed as it mostly just pointed to the latest matomo release, use `matomo.overrideAttrs` to access a specific beta version instead"; # Added 2025-01-15
  matrique = throw "'matrique' has been renamed to/replaced by 'spectral'"; # Converted to throw 2024-10-17
  matrix-sliding-sync = throw "matrix-sliding-sync has been removed as matrix-synapse 114.0 and later covers its functionality"; # Added 2024-10-20
  matrix-synapse-tools = recurseIntoAttrs {
    rust-synapse-compress-state = lib.warnOnInstantiate "`matrix-synapse-tools.rust-synapse-compress-state` has been renamed to `rust-synapse-compress-state`" rust-synapse-compress-state;
    synadm = lib.warnOnInstantiate "`matrix-synapse-tools.synadm` has been renamed to `synadm`" synadm;
  }; # Added 2025-02-20
  maui-nota = libsForQt5.mauiPackages.nota; # added 2022-05-17
  maui-shell = throw "maui-shell has been removed from nixpkgs, it was broken"; # Added 2024-07-15
  mcomix3 = mcomix; # Added 2022-06-05
  mdt = md-tui; # Added 2024-09-03
  meme = throw "'meme' has been renamed to/replaced by 'meme-image-generator'"; # Converted to throw 2024-10-17
  memorymapping = throw "memorymapping has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memorymappingHook = throw "memorymapping has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memstream = throw "memstream has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memstreamHook = throw "memstream has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  mhwaveedit = throw "'mkwaveedit' has been removed due to lack of maintenance upstream. Consider using 'audacity' or 'tenacity' instead";
  microcodeAmd = microcode-amd; # Added 2024-09-08
  microcodeIntel = microcode-intel; # Added 2024-09-08
  micropad = throw "micropad has been removed, since it was unmaintained and blocked the Electron 27 removal."; # Added 2025-02-24
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  midori = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  midori-unwrapped = midori; # Added 2025-05-19
  MIDIVisualizer = midivisualizer; # Added 2024-06-12
  mikutter = throw "'mikutter' has been removed because the package was broken and had no maintainers"; # Added 2024-10-01
  mime-types = mailcap; # Added 2022-01-21
  minetest = luanti; # Added 2024-11-11
  minetestclient = luanti-client; # Added 2024-11-11
  minetestserver = luanti-server; # Added 2024-11-11
  minetest-touch = luanti-client; # Added 2024-08-12
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  mmsd = throw "'mmsd' has been removed due to being unmaintained upstream. Consider using 'mmsd-tng' instead"; # Added 2025-06-07
  mod_dnssd = throw "'mod_dnssd' has been renamed to/replaced by 'apacheHttpdPackages.mod_dnssd'"; # Converted to throw 2024-10-17
  mod_fastcgi = throw "'mod_fastcgi' has been renamed to/replaced by 'apacheHttpdPackages.mod_fastcgi'"; # Converted to throw 2024-10-17
  mod_python = throw "'mod_python' has been renamed to/replaced by 'apacheHttpdPackages.mod_python'"; # Converted to throw 2024-10-17
  mod_wsgi = throw "'mod_wsgi' has been renamed to/replaced by 'apacheHttpdPackages.mod_wsgi'"; # Converted to throw 2024-10-17
  mod_ca = throw "'mod_ca' has been renamed to/replaced by 'apacheHttpdPackages.mod_ca'"; # Converted to throw 2024-10-17
  mod_crl = throw "'mod_crl' has been renamed to/replaced by 'apacheHttpdPackages.mod_crl'"; # Converted to throw 2024-10-17
  mod_csr = throw "'mod_csr' has been renamed to/replaced by 'apacheHttpdPackages.mod_csr'"; # Converted to throw 2024-10-17
  mod_ocsp = throw "'mod_ocsp' has been renamed to/replaced by 'apacheHttpdPackages.mod_ocsp'"; # Converted to throw 2024-10-17
  mod_scep = throw "'mod_scep' has been renamed to/replaced by 'apacheHttpdPackages.mod_scep'"; # Converted to throw 2024-10-17
  mod_spkac = throw "'mod_spkac' has been renamed to/replaced by 'apacheHttpdPackages.mod_spkac'"; # Converted to throw 2024-10-17
  mod_pkcs12 = throw "'mod_pkcs12' has been renamed to/replaced by 'apacheHttpdPackages.mod_pkcs12'"; # Converted to throw 2024-10-17
  mod_timestamp = throw "'mod_timestamp' has been renamed to/replaced by 'apacheHttpdPackages.mod_timestamp'"; # Converted to throw 2024-10-17
  monero = throw "'monero' has been renamed to/replaced by 'monero-cli'"; # Converted to throw 2024-10-17
  mongodb-4_4 = throw "mongodb-4_4 has been removed, it's end of life since April 2024"; # Added 2024-04-11
  mongodb-5_0 = throw "mongodb-5_0 has been removed, it's end of life since October 2024"; # Added 2024-10-01
  moz-phab = mozphab; # Added 2022-08-09
  mp3info = throw "'mp3info' has been removed due to lack of maintenance upstream. Consider using 'eartag' or 'tagger' instead"; # Added 2024-09-14
  mp3splt = throw "'mp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  mpc-cli = mpc; # Added 2024-10-14
  mpc_cli = mpc; # Added 2024-10-14
  mpd_clientlib = throw "'mpd_clientlib' has been renamed to/replaced by 'libmpdclient'"; # Converted to throw 2024-10-17
  mpdevil = plattenalbum; # Added 2024-05-22
  mpg321 = throw "'mpg321' has been removed due to it being unmaintained by upstream. Consider using mpg123 instead."; # Added 2024-05-10
  mq-cli = throw "'mq-cli' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  mrkd = throw "'mrkd' has been removed as it is unmaintained since 2021"; # Added 2024-12-21
  msp430NewlibCross = msp430Newlib; # Added 2024-09-06
  mumps_par = lib.warnOnInstantiate "mumps_par has been renamed to mumps-mpi" mumps-mpi; # Added 2025-05-07
  mupdf_1_17 = throw "'mupdf_1_17' has been removed due to being outdated and insecure. Consider using 'mupdf' instead."; # Added 2024-08-22
  music-player = throw "'music-player' has been removed due to lack of maintenance upstream. Consider using 'fum' or 'termusic' instead."; # Added 2025-05-02
  mustache-tcl = tclPackages.mustache-tcl; # Added 2024-10-02
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mutter43 = throw "'mutter43' has been removed since it is no longer used by Pantheon."; # Added 2024-09-22
  mx-puppet-discord = throw "mx-puppet-discord was removed since the packaging was unmaintained and was the sole user of sha1 hashes in nixpkgs"; # Added 2025-07-24
  mysql-client = hiPrio mariadb.client;
  mysql = throw "'mysql' has been renamed to/replaced by 'mariadb'"; # Converted to throw 2024-10-17
  mesa_drivers = throw "'mesa_drivers' has been removed, use 'pkgs.mesa' instead."; # Converted to throw 2024-07-11

  ### N ###

  ncdu_2 = ncdu; # Added 2022-07-22
  neocities-cli = neocities; # Added 2024-07-31
  neocomp = throw "neocomp has been remove because it fails to build and was unmaintained upstream"; # Added 2025-04-28
  netbox_3_3 = throw "netbox 3.3 series has been removed as it was EOL"; # Added 2023-09-02
  netbox_3_5 = throw "netbox 3.5 series has been removed as it was EOL"; # Added 2024-01-22
  netbox_3_7 = throw "netbox 3.7 series has been removed as it was EOL"; # Added 2025-04-23
  nettools = net-tools; # Added 2025-06-11
  newt-go = fosrl-newt; # Added 2025-06-24
  nextcloud29 = throw ''
    Nextcloud v29 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-04. Please upgrade to at least Nextcloud v30 by declaring

        services.nextcloud.package = pkgs.nextcloud30;

    in your NixOS config.

    WARNING: if you were on Nextcloud 28 you have to upgrade to Nextcloud 29
    first on 24.11 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2025-04-11
  nextcloud29Packages = throw "Nextcloud 29 is EOL!"; # Added 2025-04-11
  nextcloud28 = throw ''
    Nextcloud v28 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-01. Please upgrade to at least Nextcloud v29 by declaring

        services.nextcloud.package = pkgs.nextcloud29;

    in your NixOS config.

    WARNING: if you were on Nextcloud 27 you have to upgrade to Nextcloud 28
    first on 24.11 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2025-01-19
  nextcloud28Packages = throw "Nextcloud 28 is EOL!"; # Added 2025-01-19
  nextcloud27 = throw ''
    Nextcloud v27 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2024-06. Please upgrade to at least Nextcloud v28 by declaring

        services.nextcloud.package = pkgs.nextcloud28;

    in your NixOS config.

    WARNING: if you were on Nextcloud 26 you have to upgrade to Nextcloud 27
    first on 24.05 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2024-06-25
  nextcloud27Packages = throw "Nextcloud27 is EOL!"; # Added 2024-06-25
  nextcloud-news-updater = throw "nextcloud-news-updater has been removed because the project is unmaintained"; # Added 2025-03-28
  nagiosPluginsOfficial = monitoring-plugins;
  neochat = makePlasma5Throw "neochat"; # added 2022-05-10
  nerdfonts = throw ''
    nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
    For example change:
      fonts.packages = [
        ...
        (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
      ]
    to
      fonts.packages = [
        ...
        pkgs.nerd-fonts._0xproto
        pkgs.nerd-fonts.droid-sans-mono
      ]
    or for all fonts
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
  ''; # Added 2024-11-09
  networkmanager_strongswan = networkmanager-strongswan; # added 2025-06-29
  newlibCross = newlib; # Added 2024-09-06
  newlib-nanoCross = newlib-nano; # Added 2024-09-06
  nix-direnv-flakes = nix-direnv;
  nix-ld-rs = nix-ld; # Added 2024-08-17
  nix-plugin-pijul = throw "nix-plugin-pijul has been removed due to being discontinued"; # added 2025-05-18
  nix-repl = throw (
    # Added 2018-08-26
    "nix-repl has been removed because it's not maintained anymore, "
    + "use `nix repl` instead. Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );
  nix-simple-deploy = throw "'nix-simple-deploy' has been removed as it is broken and unmaintained"; # Added 2024-08-17
  nix-universal-prefetch = throw "The nix-universal-prefetch package was dropped since it was unmaintained."; # Added 2024-06-21
  nixFlakes = throw "'nixFlakes' has been renamed to/replaced by 'nixVersions.stable'"; # Converted to throw 2024-10-17
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixUnstable = throw "nixUnstable has been removed. For bleeding edge (Nix master, roughly weekly updated) use nixVersions.git, otherwise use nixVersions.latest."; # Converted to throw 2024-04-22
  nix_2_3 = nixVersions.nix_2_3;
  nixfmt-rfc-style =
    if lib.oldestSupportedReleaseIsAtLeast 2511 then
      lib.warnOnInstantiate
        "nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead."
        nixfmt # Added 2025-07-14
    else
      nixfmt;

  # When the nixops_unstable alias is removed, nixops_unstable_minimal can be renamed to nixops_unstable.

  nixosTest = testers.nixosTest; # Added 2022-05-05
  nmap-unfree = throw "'nmap-unfree' has been renamed to/replaced by 'nmap'"; # Converted to throw 2024-10-17
  noah = throw "'noah' has been removed because it was broken and its upstream archived"; # Added 2025-05-10
  nodejs_18 = throw "Node.js 18.x has reached End-Of-Life and has been removed"; # Added 2025-04-23
  nodejs-slim_18 = nodejs_18; # Added 2025-04-23
  corepack_18 = nodejs_18; # Added 2025-04-23
  nodejs-18_x = nodejs_18; # Added 2022-11-06
  nodejs-slim-18_x = nodejs-slim_18; # Added 2022-11-06
  nomad_1_4 = throw "nomad_1_4 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_5 = throw "nomad_1_5 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_6 = throw "nomad_1_6 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_7 = throw "nomad_1_7 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-03-27
  nomad_1_8 = throw "nomad_1_8 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-03-27
  noto-fonts-cjk = throw "'noto-fonts-cjk' has been renamed to/replaced by 'noto-fonts-cjk-sans'"; # Converted to throw 2024-10-17
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nushellFull = lib.warnOnInstantiate "`nushellFull` has has been replaced by `nushell` as its features no longer exist" nushell; # Added 2024-05-30
  nux = throw "nux has been removed because it has been abandoned for 4 years"; # Added 2025-03-22
  nvidia-podman = throw "podman should use the Container Device Interface (CDI) instead. See https://web.archive.org/web/20240729183805/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-podman"; # Added 2024-08-02
  nvidia-thrust = throw "nvidia-thrust has been removed because the project was deprecated; use cudaPackages.cuda_cccl";

  ### O ###

  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  oauth2_proxy = throw "'oauth2_proxy' has been renamed to/replaced by 'oauth2-proxy'"; # Converted to throw 2024-10-17
  ocis-bin = throw "ocis-bin has been renamed to ocis_5-bin'. Future major.minor versions will be made available as separate packages"; # Added 2025-03-30
  odoo15 = throw "odoo15 has been removed from nixpkgs as it is unsupported; migrate to a newer version of odoo"; # Added 2025-05-06
  offrss = throw "offrss has been removed due to lack of upstream maintenance; consider using another rss reader"; # Added 2025-06-01
  oil = lib.warnOnInstantiate "Oil has been replaced with the faster native C++ version and renamed to 'oils-for-unix'. See also https://github.com/oils-for-unix/oils/wiki/Oils-Deployments" oils-for-unix; # Added 2024-10-22
  oneDNN_2 = throw "oneDNN_2 has been removed as it was only used by rocmPackages.migraphx"; # added 2025-07-18
  onevpl-intel-gpu = lib.warnOnInstantiate "onevpl-intel-gpu has been renamed to vpl-gpu-rt" vpl-gpu-rt; # Added 2024-06-04
  openai-triton-llvm = triton-llvm; # added 2024-07-18
  openai-whisper-cpp = whisper-cpp; # Added 2024-12-13
  opencv2 = throw "opencv2 has been removed as it is obsolete and was not used by any other package; please migrate to OpenCV 4"; # Added 2024-08-20
  opencv3 = throw "opencv3 has been removed as it is obsolete and was not used by any other package; please migrate to OpenCV 4"; # Added 2024-08-20
  openafs_1_8 = openafs; # Added 2022-08-22
  opencl-info = throw "opencl-info has been removed, as the upstream is unmaintained; consider using 'clinfo' instead"; # Added 2024-06-12
  opencomposite-helper = throw "opencomposite-helper has been removed from nixpkgs as it causes issues with some applications. See https://wiki.nixos.org/wiki/VR#OpenComposite for the recommended setup"; # Added 2024-09-07
  openconnect_gnutls = openconnect; # Added 2022-03-29
  opendylan = throw "opendylan has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  opendylan_bin = throw "opendylan_bin has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  openelec-dvb-firmware = throw "'openelec-dvb-firmware' has been renamed to/replaced by 'libreelec-dvb-firmware'"; # Converted to throw 2024-10-17
  openethereum = throw "openethereum development has ceased by upstream. Use alternate clients such as go-ethereum, erigon, or nethermind"; # Added 2024-05-13
  openexr_3 = openexr; # Added 2025-03-12
  openimageio2 = openimageio; # Added 2023-01-05
  openisns = throw "'openisns' has been renamed to/replaced by 'open-isns'"; # Converted to throw 2024-10-17
  openjdk19 = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk19_headless = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk19 = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk19_headless = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk20 = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk20_headless = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk20 = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk20_headless = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk22 = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  openjdk22_headless = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  jdk22 = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  jdk22_headless = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  oobicpl = throw "oobicpl was removed as it is unmaintained upstream"; # Added 2025-04-26
  openjfx11 = throw "OpenJFX 11 was removed as it has reached its end of life"; # Added 2024-10-07
  openjfx19 = throw "OpenJFX 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjfx20 = throw "OpenJFX 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjfx22 = throw "OpenJFX 22 was removed as it has reached its end of life"; # Added 2024-09-24
  openjpeg_2 = throw "'openjpeg_2' has been renamed to/replaced by 'openjpeg'"; # Converted to throw 2024-10-17
  openlens = throw "Lens Closed its source code, package obsolete/stale - consider lens as replacement"; # Added 2024-09-04
  openlp = throw "openlp has been removed for now because the outdated version depended on insecure and removed packages and it needs help to upgrade and maintain it; see https://github.com/NixOS/nixpkgs/pull/314882"; # Added 2024-07-29
  openmpt123 = throw "'openmpt123' has been renamed to/replaced by 'libopenmpt'"; # Converted to throw 2024-10-17
  opensmtpd-extras = throw "opensmtpd-extras has been removed in favor of separate opensmtpd-table-* packages"; # Added 2025-01-26
  openssl_3_0 = openssl_3; # Added 2022-06-27
  opensycl = lib.warnOnInstantiate "'opensycl' has been renamed to 'adaptivecpp'" adaptivecpp; # Added 2024-12-04
  opensyclWithRocm = lib.warnOnInstantiate "'opensyclWithRocm' has been renamed to 'adaptivecppWithRocm'" adaptivecppWithRocm; # Added 2024-12-04
  opentofu-ls = lib.warnOnInstantiate "'opentofu-ls' has been renamed to 'tofu-ls'" tofu-ls; # Added 2025-06-10
  openvdb_11 = throw "'openvdb_11' has been removed in favor of the latest version'"; # Added 2025-05-03
  opera = throw "'opera' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-05-19
  orchis = throw "'orchis' has been renamed to/replaced by 'orchis-theme'"; # Converted to throw 2024-10-17
  omping = throw "'omping' has been removed because its upstream has been archived"; # Added 2025-05-10
  onlyoffice-bin = onlyoffice-desktopeditors; # Added 2024-09-20
  onlyoffice-bin_latest = onlyoffice-bin; # Added 2024-07-03
  onlyoffice-bin_7_2 = throw "onlyoffice-bin_7_2 has been removed. Please use the latest version available under onlyoffice-bin"; # Added 2024-07-03
  onlyoffice-bin_7_5 = throw "onlyoffice-bin_7_5 has been removed. Please use the latest version available under onlyoffice-bin"; # Added 2024-07-03
  openvswitch-lts = throw "openvswitch-lts has been removed. Please use the latest version available under openvswitch"; # Added 2024-08-24
  oraclejdk = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk8 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejre = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejre8 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jrePlugin = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jre8Plugin = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jdkdistro = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk8distro = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk11 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  OSCAR = oscar; # Added 2024-06-12
  osxfuse = throw "'osxfuse' has been renamed to/replaced by 'macfuse-stubs'"; # Converted to throw 2024-10-17
  ovn-lts = throw "ovn-lts has been removed. Please use the latest version available under ovn"; # Added 2024-08-24
  oxygen-icons5 = throw ''
    The top-level oxygen-icons5 alias has been removed.

    Please explicitly use kdePackages.oxygen-icons for the latest Qt 6-based version,
    or libsForQt5.oxygen-icons5 for the deprecated Qt 5 version.

    Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.
  ''; # Added 2025-03-15;
  oysttyer = throw "oysttyer has been removed; it is no longer maintained because of Twitter disabling free API access"; # Added 2024-09-23

  ### P ###

  pax-rs = throw "'pax-rs' has been removed because upstream has disappeared"; # Added 2025-01-25
  PageEdit = pageedit; # Added 2024-01-21
  passky-desktop = throw "passky-desktop has been removed, as it was unmaintained and blocking the Electron 29 removal."; # Added 2025-02-24
  p2pvc = throw "p2pvc has been removed as it is unmaintained upstream and depends on OpenCV 2"; # Added 2024-08-20
  packet-cli = throw "'packet-cli' has been renamed to/replaced by 'metal-cli'"; # Converted to throw 2024-10-17
  paco = throw "'paco' has been removed as it has been abandoned"; # Added 2025-04-30
  inherit (perlPackages) pacup;
  panopticon = throw "'panopticon' has been removed because it is unmaintained upstream"; # Added 2025-01-25
  paperoni = throw "paperoni has been removed, because it is unmaintained"; # Added 2024-07-14
  paperless = throw "'paperless' has been renamed to/replaced by 'paperless-ngx'"; # Converted to throw 2024-10-17
  pathsFromGraph = throw "pathsFromGraph has been removed, use closureInfo instead"; # Added 2025-01-23
  paperless-ng = paperless-ngx; # Added 2022-04-11
  partition-manager = makePlasma5Throw "partitionmanager"; # Added 2024-01-08
  patchelfStable = patchelf; # Added 2024-01-25
  paup = paup-cli; # Added 2024-09-11
  pcre16 = throw "'pcre16' has been removed because it is obsolete. Consider migrating to 'pcre2' instead."; # Added 2025-05-29
  pcsctools = pcsc-tools; # Added 2023-12-07
  pcsxr = throw "pcsxr was removed as it has been abandoned for over a decade; please use DuckStation, Mednafen, or the RetroArch PCSX ReARMed core"; # Added 2024-08-20
  pdf4tcl = tclPackages.pdf4tcl; # Added 2024-10-02
  peach = asouldocs; # Added 2022-08-28
  percona-server_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-server; # Added 2024-10-13
  percona-server_lts = percona-server; # Added 2024-10-13
  percona-xtrabackup_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-xtrabackup; # Added 2024-10-13
  percona-xtrabackup_lts = percona-xtrabackup; # Added 2024-10-13
  peroxide = throw "'peroxide' has been dropped due to lack of upstream maintenance."; # Added 2025-03-31
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  perldevel = throw "'perldevel' has been dropped due to lack of updates in nixpkgs and lack of consistent support for devel versions by 'perl-cross' releases, use 'perl' instead";
  perldevelPackages = perldevel;
  petrinizer = throw "'petrinizer' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  pg-gvm = throw "pg-gvm has been moved to postgresql.pkgs.pg-gvm to make it work with all versions of PostgreSQL"; # added 2024-11-30
  pgadmin = pgadmin4;
  pharo-spur64 = pharo; # Added 2022-08-03
  phlare = throw "'phlare' has been removed as the upstream project was archived."; # Added 2025-03-27
  picom-next = picom; # Added 2024-02-13
  pict-rs_0_3 = throw "pict-rs_0_3 has been removed, as it was an outdated version and no longer compiled"; # Added 2024-08-20
  pilipalax = throw "'pilipalax' has been removed from nixpkgs due to it not being maintained"; # Added 2025-07-25
  pio = throw "pio has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  pipewire_0_2 = throw "pipewire_0_2 has been removed as it is outdated and no longer used"; # Added 2024-07-28
  pipewire-media-session = throw "pipewire-media-session is no longer maintained and has been removed. Please use Wireplumber instead.";
  platypus = throw "platypus is unmaintained and has not merged Python3 support"; # Added 2025-03-20
  pleroma-otp = throw "'pleroma-otp' has been renamed to/replaced by 'pleroma'"; # Converted to throw 2024-10-17
  plex-media-player = throw "'plex-media-player' has been discontinued, the new official client is available as 'plex-desktop'"; # Added 2025-05-28
  plots = throw "'plots' has been replaced by 'gnome-graphs'"; # Added 2025-02-05
  pltScheme = racket; # just to be sure
  poac = cabinpkg; # Added 2025-01-22
  podofo010 = podofo_0_10; # Added 2025-06-01
  polkit-kde-agent = throw ''
    The top-level polkit-kde-agent alias has been removed.

    Please explicitly use kdePackages.polkit-kde-agent-1 for the latest Qt 6-based version,
    or libsForQt5.polkit-kde-agent for the deprecated Qt 5 version.

    Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.
  ''; # Added 2025-03-07
  polypane = throw "'polypane' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-25
  poretools = throw "poretools has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-06-03
  posix_man_pages = throw "'posix_man_pages' has been renamed to/replaced by 'man-pages-posix'"; # Converted to throw 2024-10-17
  powerdns = pdns; # Added 2022-03-28
  presage = throw "presage has been removed, as it has been unmaintained since 2018"; # Added 2024-03-24
  projectm = throw "Since version 4, 'projectm' has been split into 'libprojectm' (the library) and 'projectm-sdl-cpp' (the SDL2 frontend). ProjectM 3 has been moved to 'projectm_3'"; # Added 2024-11-10

  cstore_fdw = throw "'cstore_fdw' has been removed. Use 'postgresqlPackages.cstore_fdw' instead."; # Added 2025-07-19
  pg_cron = throw "'pg_cron' has been removed. Use 'postgresqlPackages.pg_cron' instead."; # Added 2025-07-19
  pg_hll = throw "'pg_hll' has been removed. Use 'postgresqlPackages.pg_hll' instead."; # Added 2025-07-19
  pg_repack = throw "'pg_repack' has been removed. Use 'postgresqlPackages.pg_repack' instead."; # Added 2025-07-19
  pg_similarity = throw "'pg_similarity' has been removed. Use 'postgresqlPackages.pg_similarity' instead."; # Added 2025-07-19
  pg_topn = throw "'pg_topn' has been removed. Use 'postgresqlPackages.pg_topn' instead."; # Added 2025-07-19
  pgf1 = throw "'pgf1' has been removed since it is unmaintained. Consider using 'pgf' instead"; # Added 2025-05-10
  pgjwt = throw "'pgjwt' has been removed. Use 'postgresqlPackages.pgjwt' instead."; # Added 2025-07-19
  pgroonga = throw "'pgroonga' has been removed. Use 'postgresqlPackages.pgroonga' instead."; # Added 2025-07-19
  pgtap = throw "'pgtap' has been removed. Use 'postgresqlPackages.pgtap' instead."; # Added 2025-07-19
  plv8 = throw "'plv8' has been removed. Use 'postgresqlPackages.plv8' instead."; # Added 2025-07-19
  postcss-cli = throw "postcss-cli has been removed because it was broken"; # added 2025-03-24
  postgis = throw "'postgis' has been removed. Use 'postgresqlPackages.postgis' instead."; # Added 2025-07-19
  tex-match = throw "'tex-match' has been removed due to lack of maintenance upstream. Consider using 'hieroglyphic' instead"; # Added 2024-09-24
  texinfo5 = throw "'texinfo5' has been removed from nixpkgs"; # Added 2024-09-10
  timescaledb = throw "'timescaledb' has been removed. Use 'postgresqlPackages.timescaledb' instead."; # Added 2025-07-19
  tsearch_extras = throw "'tsearch_extras' has been removed from nixpkgs"; # Added 2024-12-15

  postgresql_12 = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql_12_jit = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql12Packages = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql12JitPackages = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14

  # Ever since building with JIT by default, those are the same.
  postgresqlJitPackages = postgresqlPackages; # Added 2025-04-12
  postgresql13JitPackages = postgresql13Packages; # Added 2025-04-12
  postgresql14JitPackages = postgresql14Packages; # Added 2025-04-12
  postgresql15JitPackages = postgresql15Packages; # Added 2025-04-12
  postgresql16JitPackages = postgresql16Packages; # Added 2025-04-12
  postgresql17JitPackages = postgresql17Packages; # Added 2025-04-12

  # pinentry was using multiple outputs, this emulates the old interface for i.e. home-manager
  # soon: throw "'pinentry' has been removed. Pick an appropriate variant like 'pinentry-curses' or 'pinentry-gnome3'";
  pinentry = pinentry-all // {
    curses = pinentry-curses;
    emacs = pinentry-emacs;
    gnome3 = pinentry-gnome3;
    gtk2 = pinentry-gtk2;
    qt = pinentry-qt;
    tty = pinentry-tty;
    flavors = [
      "curses"
      "emacs"
      "gnome3"
      "gtk2"
      "qt"
      "tty"
    ];
  }; # added 2024-01-15
  pinentry_qt5 = throw "'pinentry_qt5' has been renamed to/replaced by 'pinentry-qt'"; # Converted to throw 2024-10-17
  pivx = throw "pivx has been removed as it was marked as broken"; # Added 2024-07-15
  pivxd = throw "pivxd has been removed as it was marked as broken"; # Added 2024-07-15

  PlistCpp = plistcpp; # Added 2024-01-05
  pocket-updater-utility = pupdate; # Added 2024-01-25
  polipo = throw "'polipo' has been removed as it is unmaintained upstream"; # Added 2025-05-18
  poppler_utils = poppler-utils; # Added 2025-02-27
  powerline-rs = throw "'powerline-rs' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  premake3 = throw "'premake3' has been removed since it is unmaintained. Consider using 'premake' instead"; # Added 2025-05-10
  prismlauncher-qt5 = throw "'prismlauncher-qt5' has been removed from nixpkgs. Please use 'prismlauncher'"; # Added 2024-04-20
  prismlauncher-qt5-unwrapped = throw "'prismlauncher-qt5-unwrapped' has been removed from nixpkgs. Please use 'prismlauncher-unwrapped'"; # Added 2024-04-20
  private-gpt = throw "'private-gpt' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2025-07-28
  probe-rs = probe-rs-tools; # Added 2024-05-23
  probe-run = throw "probe-run is deprecated upstream.  Use probe-rs instead."; # Added 2024-05-23
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-dovecot-exporter = dovecot_exporter; # Added 2024-06-10
  prometheus-openldap-exporter = throw "'prometheus-openldap-exporter' has been removed from nixpkgs, as it was unmaintained"; # Added 2024-09-01
  prometheus-minio-exporter = throw "'prometheus-minio-exporter' has been removed from nixpkgs, use Minio's built-in Prometheus integration instead"; # Added 2024-06-10
  prometheus-tor-exporter = throw "'prometheus-tor-exporter' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-10-30
  protobuf_23 = throw "'protobuf_23' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-04-20
  protobuf_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_26 = throw "'protobuf_26' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-29
  protobuf_28 = throw "'protobuf_28' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-14
  protobuf3_24 = protobuf_24;
  protobuf3_23 = protobuf_23;
  protobuf3_21 = protobuf_21;
  protoc-gen-connect-es = throw "'protoc-gen-connect-es' has been removed because it is deprecated upstream. Functionality has been integrated into 'protoc-gen-es' v2."; # Added 2025-02-18
  protonup = protonup-ng; # Added 2022-11-06
  protonvpn-gui_legacy = throw "protonvpn-gui_legacy source code was removed from upstream. Use protonvpn-gui instead."; # Added 2024-10-12
  proton-vpn-local-agent = lib.warnOnInstantiate "'proton-vpn-local-agent' has been renamed to 'python3Packages.proton-vpn-local-agent'" (
    python3Packages.toPythonApplication python3Packages.proton-vpn-local-agent
  ); # Added 2025-04-23
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  psensor = throw "'psensor' has been removed due to lack of maintenance upstream. Consider using 'mission-center', 'resources' or 'monitorets' instead"; # Added 2024-09-14
  psstop = throw "'psstop' has been removed because the upstream repo has been archived"; # Added 2025-05-10
  ptask = throw "'ptask' has been removed because its upstream is unavailable"; # Added 2025-05-10
  purple-signald = throw "'purple-signald' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  pwndbg = throw "'pwndbg' has been removed due to dependency version incompatibilities that are infeasible to maintain in nixpkgs. Use the downstream flake that pwndbg provides instead: https://github.com/pwndbg/pwndbg"; # Added 2025-02-09
  pxlib = throw "pxlib has been removed due to failing to build and lack of upstream maintenance"; # Added 2025-04-28
  pxview = throw "pxview has been removed due to failing to build and lack of upstream maintenance"; # Added 2025-04-28
  pynac = throw "'pynac' has been removed as it was broken and unmaintained"; # Added 2025-03-18
  pyo3-pack = maturin;
  pypi2nix = throw "pypi2nix has been removed due to being unmaintained";
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  pypy39Packages = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-07
  python = python2; # Added 2022-01-11
  python-swiftclient = throw "'python-swiftclient' has been renamed to/replaced by 'swiftclient'"; # Converted to throw 2024-10-17
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11
  pypy39 = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-03

  ### Q ###

  qbittorrent-qt5 = throw "'qbittorrent-qt5' has been removed as qBittorrent 5 dropped support for Qt 5. Please use 'qbittorrent'"; # Added 2024-09-30
  qcsxcad = throw "'qcsxcad' has been renamed to/replaced by 'libsForQt5.qcsxcad'"; # Converted to throw 2024-10-17
  qflipper = qFlipper; # Added 2022-02-11
  qnial = throw "'qnial' has been removed due to failing to build and being unmaintained"; # Added 2025-06-26
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt515 = qt5; # Added 2022-11-24
  qt5ct = throw "'qt5ct' has been renamed to/replaced by 'libsForQt5.qt5ct'"; # Converted to throw 2024-10-17
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qtchan = throw "'qtchan' has been removed due to lack of maintenance upstream"; # Added 2025-07-01
  qtcurve = throw "'qtcurve' has been renamed to/replaced by 'libsForQt5.qtcurve'"; # Converted to throw 2024-10-17
  qtile-unwrapped = python3.pkgs.qtile; # Added 2023-05-12
  quantum-espresso-mpi = quantum-espresso; # Added 2023-11-23
  quaternion-qt5 = throw "'quaternion-qt5' has been removed as quaternion dropped Qt5 support with v0.0.97.1"; # Added 2025-05-24
  quickbms = throw "'quickbms' has been removed due to being unmaintained for many years."; # Added 2025-05-17
  quicklispPackages = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesABCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesCCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesClisp = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesECL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesFor = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesGCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesSBCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quickserve = throw "'quickserve' has been removed because its upstream is unavailable"; # Added 2025-05-10
  quicksynergy = throw "'quicksynergy' has been removed due to lack of maintenance upstream. Consider using 'deskflow' instead."; # Added 2025-06-18
  qv2ray = throw "'qv2ray' has been removed as it was unmaintained"; # Added 2025-06-03
  qxw = throw "'qxw' has been removed due to lack of maintenance upstream. Consider using 'crosswords' instead"; # Added 2024-10-19

  ### R ###

  rabbitmq-java-client = throw "rabbitmq-java-client has been removed due to its dependency on Python2 and a lack of maintenance within the nixpkgs tree"; # Added 2025-03-29
  rabbitvcs = throw "rabbitvcs has been removed from nixpkgs, because it was broken"; # Added 2024-07-15
  racket_7_9 = throw "Racket 7.9 has been removed because it is insecure. Consider using 'racket' instead."; # Added 2024-12-06
  radare2-cutter = throw "'radare2-cutter' has been renamed to/replaced by 'cutter'"; # Converted to throw 2024-10-17
  radicale2 = throw "'radicale2' was removed because it was broken. Use 'radicale' (version 3) instead"; # Added 2024-11-29
  radicale3 = radicale; # Added 2024-11-29
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rapidjson-unstable = lib.warnOnInstantiate "'rapidjson-unstable' has been renamed to 'rapidjson'" rapidjson; # Added 2024-07-28
  rargs = throw "'rargs' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  rebazel = throw "'rebazel' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  redpanda-server = throw "'redpanda-server' has been removed because it was broken for a long time"; # Added 2024-06-10
  relibc = throw "relibc has been removed due to lack of maintenance"; # Added 2024-09-02
  replay-sorcery = throw "replay-sorcery has been removed as it is unmaintained upstream. Consider using gpu-screen-recorder or obs-studio instead."; # Added 2024-07-13
  restinio_0_6 = throw "restinio_0_6 has been removed from nixpkgs as it's not needed by downstream packages"; # Added 2024-07-04
  retroarchBare = retroarch-bare; # Added 2024-11-23
  retroarchFull = retroarch-full; # Added 2024-11-23
  retroshare06 = retroshare;
  responsively-app = throw "'responsively-app' has been removed due to lack of maintainance upstream."; # Added 2025-06-25
  rftg = throw "'rftg' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  ring-daemon = throw "'ring-daemon' has been renamed to/replaced by 'jami-daemon'"; # Converted to throw 2024-10-17
  riko4 = throw "'riko4' has been removed as it was unmaintained, failed to build and dependend on outdated libraries"; # Added 2025-05-18
  rippled = throw "rippled has been removed as it was broken and had not been updated since 2022"; # Added 2024-11-25
  rippled-validator-keys-tool = throw "rippled-validator-keys-tool has been removed as it was broken and had not been updated since 2022"; # Added 2024-11-25
  rke2_1_29 = throw "'rke2_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  rke2_testing = throw "'rke2_testing' has been removed from nixpkgs as the RKE2 testing channel no longer serves releases"; # Added 2025-06-02
  rl_json = tclPackages.rl_json; # Added 2025-05-03
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rocmPackages_5 = throw "ROCm 5 has been removed in favor of newer versions"; # Added 2025-02-18
  root5 = throw "root5 has been removed from nixpkgs because it's a legacy version"; # Added 2025-07-17
  rnix-hashes = throw "'rnix-hashes' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  rpiboot-unstable = throw "'rpiboot-unstable' has been renamed to/replaced by 'rpiboot'"; # Converted to throw 2024-10-17
  rr-unstable = rr; # Added 2022-09-17
  rtx = mise; # Added 2024-01-05
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  run-scaled = throw "run-scaled has been removed due to being deprecated. Consider using run_scaled from 'xpra' instead"; # Added 2025-03-17
  rust-synapse-state-compress = rust-synapse-compress-state;
  rustc-wasm32 = rustc; # Added 2023-12-01
  rustfilt = throw "'rustfilt' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  rustic-rs = rustic; # Added 2024-08-02
  rxvt_unicode = throw "'rxvt_unicode' has been renamed to/replaced by 'rxvt-unicode-unwrapped'"; # Converted to throw 2024-10-17
  rxvt_unicode-with-plugins = throw "'rxvt_unicode-with-plugins' has been renamed to/replaced by 'rxvt-unicode'"; # Converted to throw 2024-10-17
  ryujinx-greemdev = ryubing; # Added 2025-01-20

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = throw "'rtlwifi_new-firmware' has been renamed to/replaced by 'rtw88-firmware'"; # Converted to throw 2024-10-17
  rtw88-firmware = throw "rtw88-firmware has been removed because linux-firmware now contains it."; # Added 2024-06-28

  ### S ###

  SDL_classic = SDL1; # Added 2024-09-03
  SDL1 = throw "'SDL1' has been removed as development ended long ago with SDL 2.0 replacing it, use SDL_compat instead"; # Added 2025-03-27
  SDL_gpu = throw "'SDL_gpu' has been removed due to lack of upstream maintenance and known users"; # Added 2025-03-15
  SDL_image_2_0 = throw "'SDL_image_2_0' has been removed in favor of the latest version"; # Added 2025-04-20
  SDL2_mixer_2_0 = throw "'SDL2_mixer_2_0' has been removed in favor of the latest version"; # Added 2025-04-27
  SDL2_classic = throw "'SDL2_classic' has been removed. Consider upgrading to 'sdl2-compat', also available as 'SDL2'."; # Added 2025-05-20
  SDL2_classic_image = throw "'SDL2_classic_image' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_image' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_mixer_2_0 = throw "'SDL2_classic_mixer_2_0' has been removed in favor of the latest version"; # Added 2025-04-27
  SDL2_classic_mixer = throw "'SDL2_classic_mixer' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_mixer' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_ttf = throw "'SDL2_classic_ttf' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_ttf' built with 'sdl2-compat'."; # Added 2025-05-20
  s2n = throw "'s2n' has been renamed to/replaced by 's2n-tls'"; # Converted to throw 2024-10-17
  sandboxfs = throw "'sandboxfs' has been removed due to being unmaintained, consider using linux namespaces for sandboxing instead"; # Added 2024-06-06
  sane-backends-git = throw "'sane-backends-git' has been renamed to/replaced by 'sane-backends'"; # Converted to throw 2024-10-17
  samtools_0_1_19 = throw "'samtools_0_1_19' has been removed because it is unmaintained. Consider using 'samtools' instead"; # Added 2025-05-10
  scantailor = scantailor-advanced; # Added 2022-05-26
  schildichat-web = throw ''
    schildichat has been removed as it is severely lacking behind the Element upstream and does not receive regular security fixes.
    Please participate in upstream discussion on getting out new releases:
    https://github.com/SchildiChat/schildichat-desktop/issues/212
    https://github.com/SchildiChat/schildichat-desktop/issues/215''; # Added 2023-12-05
  schildichat-desktop = schildichat-web;
  schildichat-desktop-wayland = schildichat-web;
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  scry = throw "'scry' has been removed as it was archived upstream. Use 'crystalline' instead"; # Added 2025-02-12
  scudcloud = throw "'scudcloud' has been removed as it was archived by upstream"; # Added 2025-07-24
  semeru-bin-16 = throw "Semeru 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  semeru-jre-bin-16 = throw "Semeru 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  sensu = throw "sensu has been removed as the upstream project is deprecated. Consider using `sensu-go`"; # Added 2024-10-28
  serial-unit-testing = throw "'serial-unit-testing' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  serious-sans = throw "'serious-sans' has been renamed to 'serious-shanns', which is not currently packaged"; # Added 2025-01-26
  session-desktop-appimage = session-desktop;
  setserial = throw "'setserial' has been removed as it had been abandoned upstream"; # Added 2025-05-18
  sequoia = sequoia-sq; # Added 2023-06-26
  sexp = sexpp; # Added 2023-07-03
  sgrep = throw "'sgrep' has been removed as it was unmaintained upstream since 1998 and broken with gcc 14"; # Added 2025-05-17
  shallot = throw "'shallot' has been removed as it is broken and the upstream repository was removed. Consider using 'mkp224o'"; # Added 2025-03-16
  inherit (libsForQt5.mauiPackages) shelf; # added 2022-05-17
  shell-hist = throw "'shell-hist' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  shipyard = jumppad; # Added 2023-06-06
  siduck76-st = st-snazzy; # Added 2024-12-24
  signald = throw "'signald' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  signaldctl = throw "'signaldctl' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  signal-desktop-beta = throw "signal-desktop-beta has been removed to make the signal-desktop package easier to maintain";
  signal-desktop-source = lib.warnOnInstantiate "'signal-desktop-source' is now exposed at 'signal-desktop'." signal-desktop; # Added 2025-04-16
  silc_server = throw "'silc_server' has been removed because it is unmaintained"; # Added 2025-05-12
  silc_client = throw "'silc_client' has been removed because it is unmaintained"; # Added 2025-05-12
  siproxd = throw "'siproxd' has been removed as it was unmaintained and incompatible with newer libosip versions"; # Added 2025-05-18
  sheesy-cli = throw "'sheesy-cli' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  shout = nodePackages.shout; # Added unknown; moved 2024-10-19
  sky = throw "'sky' has been removed because its upstream website disappeared"; # Added 2024-07-21
  SkypeExport = skypeexport; # Added 2024-06-12
  skypeforlinux = throw "Skype has been shut down in May 2025"; # Added 2025-05-05
  slack-dark = throw "'slack-dark' has been renamed to/replaced by 'slack'"; # Converted to throw 2024-10-17
  slimerjs = throw "slimerjs does not work with any version of Firefox newer than 59; upstream ended the project in 2021. <https://slimerjs.org/faq.html#end-of-development>"; # added 2025-01-06
  sloccount = throw "'sloccount' has been removed because it is unmaintained. Consider migrating to 'loccount'"; # added 2025-05-17
  slrn = throw "'slrn' has been removed because it is unmaintained upstream and broken."; # Added 2025-06-11
  slurm-llnl = slurm; # renamed July 2017
  sm64ex-coop = throw "'sm64ex-coop' was removed as it was archived upstream. Consider migrating to 'sm64coopdx'"; # added 2024-11-23
  smartgithg = smartgit; # renamed March 2025
  snapTools = throw "snapTools was removed because makeSnap produced broken snaps and it was the only function in snapTools. See https://github.com/NixOS/nixpkgs/issues/100618 for more details."; # 2024-03-04;
  snort2 = throw "snort2 has been removed as it is deprecated and unmaintained by upstream. Consider using snort (snort3) package instead."; # 2025-05-21
  soldat-unstable = opensoldat; # Added 2022-07-02
  soulseekqt = throw "'soulseekqt' has been removed due to lack of maintenance in Nixpkgs in a long time. Consider using 'nicotine-plus' or 'slskd' instead."; # Added 2025-06-07
  soundOfSorting = sound-of-sorting; # Added 2023-07-07
  SP800-90B_EntropyAssessment = sp800-90b-entropyassessment; # Added on 2024-06-12
  SPAdes = spades; # Added 2024-06-12
  spark2014 = gnatprove; # Added 2024-02-25
  space-orbit = throw "'space-orbit' has been removed because it is unmaintained; Debian upstream stopped tracking it in 2011."; # Added 2025-06-08
  spatialite_gui = throw "spatialite_gui has been renamed to spatialite-gui"; # Added 2025-01-12
  spatialite_tools = throw "spatialite_tools has been renamed to spatialite-tools"; # Added 2025-02-06

  # Added 2020-02-10
  sourceHanSansPackages = {
    japanese = source-han-sans;
    korean = source-han-sans;
    simplified-chinese = source-han-sans;
    traditional-chinese = source-han-sans;
  };
  source-han-sans-japanese = source-han-sans;
  source-han-sans-korean = source-han-sans;
  source-han-sans-simplified-chinese = source-han-sans;
  source-han-sans-traditional-chinese = source-han-sans;
  sourceHanSerifPackages = {
    japanese = source-han-serif;
    korean = source-han-serif;
    simplified-chinese = source-han-serif;
    traditional-chinese = source-han-serif;
  };
  source-han-serif-japanese = source-han-serif;
  source-han-serif-korean = source-han-serif;
  source-han-serif-simplified-chinese = source-han-serif;
  source-han-serif-traditional-chinese = source-han-serif;

  sourcehut = throw "'sourcehut.*' has been removed due to being broken and unmaintained"; # Added 2025-06-15
  solana-validator = throw "'solana-validator' is obsoleted by solana-cli, which also includes the validator binary"; # Added 2024-12-20
  spectral = throw "'spectral' has been renamed to/replaced by 'neochat'"; # Converted to throw 2024-10-17
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey = throw "'spidermonkey' has been renamed to/replaced by 'spidermonkey_91'"; # Converted to throw 2024-10-17
  spidermonkey_78 = throw "'spidermonkey_78' has been removed because it was unused."; # Added 2025-02-02
  spidermonkey_102 = throw "'spidermonkey_102' is EOL since 2023/03"; # Added 2024-08-07
  spotify-unwrapped = spotify; # added 2022-11-06
  spring-boot = throw "'spring-boot' has been renamed to/replaced by 'spring-boot-cli'"; # Converted to throw 2024-10-17
  sqldeveloper = throw "sqldeveloper was dropped due to being severely out-of-date and having a dependency on JavaFX for Java 8, which we do not support"; # Added 2024-11-02
  srvc = throw "'srvc' has been removed, as it was broken and unmaintained"; # Added 2024-09-09
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starpls-bin = starpls;
  starspace = throw "starspace has been removed from nixpkgs, as it was broken"; # Added 2024-07-15
  station = throw "station has been removed from nixpkgs, as there were no committers among its maintainers to unblock security issues"; # added 2025-06-16
  steamPackages = {
    steamArch = throw "`steamPackages.steamArch` has been removed as it's no longer applicable";
    steam = lib.warnOnInstantiate "`steamPackages.steam` has been moved to top level as `steam-unwrapped`" steam-unwrapped;
    steam-fhsenv = lib.warnOnInstantiate "`steamPackages.steam-fhsenv` has been moved to top level as `steam`" steam;
    steam-fhsenv-small = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-small` has been moved to top level as `steam`; there is no longer a -small variant" steam;
    steam-fhsenv-without-steam = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-without-steam` has been moved to top level as `steam-fhsenv-without-steam`" steam-fhsenv-without-steam;
    steam-runtime = throw "`steamPackages.steam-runtime` has been removed, as it's no longer supported or necessary";
    steam-runtime-wrapped = throw "`steamPackages.steam-runtime-wrapped` has been removed, as it's no longer supported or necessary";
    steamcmd = lib.warnOnInstantiate "`steamPackages.steamcmd` has been moved to top level as `steamcmd`" steamcmd;
  };
  steam-small = steam; # Added 2024-09-12
  steam-run-native = steam-run; # added 2022-02-21
  StormLib = stormlib; # Added 2024-01-21
  strawberry-qt5 = throw "strawberry-qt5 has been replaced by strawberry"; # Added 2024-11-22 and updated 2025-07-19
  strawberry-qt6 = throw "strawberry-qt6 has been replaced by strawberry"; # Added 2025-07-19
  strelka = throw "strelka depends on Python 2.6+, and does not support Python 3."; # Added 2025-03-17
  subberthehut = throw "'subberthehut' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  substituteAll = throw "`substituteAll` has been removed. Use `replaceVars` instead."; # Added 2025-05-23
  substituteAllFiles = throw "`substituteAllFiles` has been removed. Use `replaceVars` for each file instead."; # Added 2025-05-23
  suidChroot = throw "'suidChroot' has been dropped as it was unmaintained, failed to build and had questionable security considerations"; # Added 2025-05-17
  suitesparse_4_2 = throw "'suitesparse_4_2' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  suitesparse_4_4 = throw "'suitesparse_4_4' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sumaclust = throw "'sumaclust' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumalibs = throw "'sumalibs' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumatra = throw "'sumatra' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  sumokoin = throw "sumokoin has been removed as it was abandoned upstream"; # Added 2024-11-23
  supertag = throw "supertag has been removed as it was abandoned upstream and fails to build"; # Added 2025-04-20
  suyu = throw "suyu has been removed from nixpkgs, as it is subject to a DMCA takedown"; # Added 2025-05-12
  swiProlog = lib.warnOnInstantiate "swiProlog has been renamed to swi-prolog" swi-prolog; # Added 2024-09-07
  swiPrologWithGui = lib.warnOnInstantiate "swiPrologWithGui has been renamed to swi-prolog-gui" swi-prolog-gui; # Added 2024-09-07
  swig1 = throw "swig1 has been removed as it is obsolete"; # Added 2024-08-23
  swig2 = throw "swig2 has been removed as it is obsolete"; # Added 2024-08-23
  swig3 = throw "swig3 has been removed as it is obsolete"; # Added 2024-11-18
  swig4 = swig; # Added 2024-09-12
  swigWithJava = throw "swigWithJava has been removed as the main swig package has supported Java since 2009"; # Added 2024-09-12
  swtpm-tpm2 = throw "'swtpm-tpm2' has been renamed to/replaced by 'swtpm'"; # Converted to throw 2024-10-17
  swt_jdk8 = throw "'swt_jdk8' has been removed due to being unused and broken for a long time"; # Added 2025-01-07
  Sylk = sylk; # Added 2024-06-12
  symbiyosys = sby; # Added 2024-08-18
  syn2mas = throw "'syn2mas' has been removed. It has been integrated into the main matrix-authentication-service CLI as a subcommand: 'mas-cli syn2mas'."; # Added 2025-07-07
  sync = taler-sync; # Added 2024-09-04
  syncthing-cli = throw "'syncthing-cli' has been renamed to/replaced by 'syncthing'"; # Converted to throw 2024-10-17
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06
  syncthing-tray = throw "syncthing-tray has been removed because it is broken and unmaintained";

  ### T ###

  t1lib = throw "'t1lib' has been removed as it was broken and unmaintained upstream."; # Added 2025-06-11
  tabula = throw "tabula has been removed from nixpkgs, as it was broken"; # Added 2024-07-15
  tailor = throw "'tailor' has been removed from nixpkgs, as it was unmaintained upstream."; # Added 2024-11-02
  tangogps = throw "'tangogps' has been renamed to/replaced by 'foxtrotgps'"; # Converted to throw 2024-10-17
  taskwarrior = lib.warnOnInstantiate "taskwarrior was replaced by taskwarrior3, which requires manual transition from taskwarrior 2.6, read upstream's docs: https://taskwarrior.org/docs/upgrade-3/" taskwarrior2;
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  targetcli = targetcli-fb; # Added 2025-03-14
  taro = taproot-assets; # Added 2023-07-04
  tcl-fcgi = tclPackages.tcl-fcgi; # Added 2024-10-02
  tclcurl = tclPackages.tclcurl; # Added 2024-10-02
  tcllib = tclPackages.tcllib; # Added 2024-10-02
  tclmagick = tclPackages.tclmagick; # Added 2024-10-02
  tcltls = tclPackages.tcltls; # Added 2024-10-02
  tcludp = tclPackages.tcludp; # Added 2024-10-02
  tclvfs = tclPackages.tclvfs; # Added 2024-10-02
  tclx = tclPackages.tclx; # Added 2024-10-02
  tcp-cutter = throw "tcp-cutter has been removed because it fails to compile and the source url is dead"; # Added 2025-05-25
  tdesktop = telegram-desktop; # Added 2023-04-07
  tdom = tclPackages.tdom; # Added 2024-10-02
  teamspeak_client = teamspeak3; # Added 2024-11-07
  teamspeak5_client = teamspeak6-client; # Added 2025-01-29
  teck-programmer = throw "teck-programmer was removed because it was broken and unmaintained"; # Added 2024-08-23
  telepathy-gabble = throw "'telepathy-gabble' has been removed as it was unmaintained, unused, broken and used outdated libraries"; # Added 2025-04-20
  telepathy-logger = throw "'telepathy-logger' has been removed as it was unmaintained, unused and broken"; # Added 2025-04-20
  teleport_13 = throw "teleport 13 has been removed as it is EOL. Please upgrade to Teleport 14 or later"; # Added 2024-05-26
  teleport_14 = throw "teleport 14 has been removed as it is EOL. Please upgrade to Teleport 15 or later"; # Added 2024-10-18
  teleport_15 = throw "teleport 15 has been removed as it is EOL. Please upgrade to Teleport 16 or later"; # Added 2025-03-28
  temporalite = throw "'temporalite' has been removed as it is obsolete and unmaintained, please use 'temporal-cli' instead (with `temporal server start-dev`)"; # Added 2025-06-26
  terminus-nerdfont = lib.warnOnInstantiate "terminus-nerdfont is redundant. Use nerd-fonts.terminess-ttf instead." nerd-fonts.terminess-ttf; # Added 2024-11-10
  temurin-bin-20 = throw "Temurin 20 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-20 = throw "Temurin 20 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-19 = throw "Temurin 19 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-19 = throw "Temurin 19 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-18 = throw "Temurin 18 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-18 = throw "Temurin 18 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-16 = throw "Temurin 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-22 = throw "Temurin 22 has been removed as it has reached its end of life"; # Added 2024-09-24
  temurin-bin-22 = throw "Temurin 22 has been removed as it has reached its end of life"; # Added 2024-09-24
  tepl = libgedit-tepl; # Added 2024-04-29
  termplay = throw "'termplay' has been removed due to lack of maintenance upstream"; # Added 2025-01-25
  testVersion = testers.testVersion; # Added 2022-04-20
  texinfo4 = throw "'texinfo4' has been removed in favor of the latest version"; # Added 2025-06-08
  tezos-rust-libs = ligo; # Added 2025-06-03
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  thiefmd = throw "'thiefmd' has been removed due to lack of maintenance upstream and incompatible with newer Pandoc. Please use 'apostrophe' or 'folio' instead"; # Added 2025-02-20
  thefuck = throw "'thefuck' has been removed due to lack of maintenance upstream and incompatible with python 3.12+. Consider using 'pay-respects' instead"; # Added 2025-05-30
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  tijolo = throw "'tijolo' has been removed due to being unmaintained"; # Added 2024-12-27
  timescale-prometheus = throw "'timescale-prometheus' has been renamed to/replaced by 'promscale'"; # Converted to throw 2024-10-17
  tightvnc = throw "'tightvnc' has been removed as the version 1.3 is not maintained upstream anymore and is insecure"; # Added 2024-08-22
  timelens = throw "'timelens' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  tix = tclPackages.tix; # Added 2024-10-02
  tkcvs = tkrev; # Added 2022-03-07
  tkgate = throw "'tkgate' has been removed as it is unmaintained"; # Added 2025-05-17
  tkimg = tclPackages.tkimg; # Added 2024-10-02
  todiff = throw "'todiff' was removed due to lack of known users"; # Added 2025-01-25
  toil = throw "toil was removed as it was broken and requires obsolete versions of libraries"; # Added 2024-09-22
  tokodon = plasma5Packages.tokodon;
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tomcat_connectors = apacheHttpdPackages.mod_jk; # Added 2024-06-07
  ton = throw "'ton' has been removed as there were insufficient maintainer resources to keep up with updates"; # Added 2025-04-27
  tooling-language-server = deputy; # Added 2025-06-22
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  torrenttools = throw "torrenttools has been removed due to lack of maintanance upstream"; # Added 2025-04-06
  torq = throw "torq has been removed because the project went closed source"; # Added 2024-11-24
  torzu = throw "torzu has been removed from nixpkgs, as it is subject to a DMCA takedown"; # Added 2025-05-12
  transmission = lib.warnOnInstantiate (transmission3Warning { }) transmission_3; # Added 2024-06-10
  transmission-gtk = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-gtk";
  }) transmission_3-gtk; # Added 2024-06-10
  transmission-qt = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-qt";
  }) transmission_3-qt; # Added 2024-06-10
  treefmt1 = throw "treefmt1 has been removed as it is not maintained anymore. Consider using `treefmt` instead."; # 2025-03-06
  treefmt2 = lib.warnOnInstantiate "treefmt2 has been renamed to treefmt" treefmt; # 2025-03-06
  libtransmission = lib.warnOnInstantiate (transmission3Warning {
    prefix = "lib";
  }) libtransmission_3; # Added 2024-06-10
  lpcnetfreedv = throw "lpcnetfreedv was removed in favor of LPCNet"; # Added 2025-05-05
  LPCNet = lpcnet; # Added 2025-05-05
  tracker = lib.warnOnInstantiate "tracker has been renamed to tinysparql" tinysparql; # Added 2024-09-30
  tracker-miners = lib.warnOnInstantiate "tracker-miners has been renamed to localsearch" localsearch; # Added 2024-09-30
  transcode = throw "transcode has been removed as it is unmaintained"; # Added 2024-12-11
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  trfl = throw "trfl has been removed, because it has not received an update for 3 years and was broken"; # Added 2024-07-25
  trezor_agent = trezor-agent; # Added 2024-01-07
  trust-dns = hickory-dns; # Added 2024-08-07
  ttyrec = throw "'ttyrec' has been renamed to/replaced by 'ovh-ttyrec'"; # Converted to throw 2024-10-17
  tuic = throw "`tuic` has been removed due to lack of upstream maintenance, consider using other tuic implementations"; # Added 2025-02-08
  tumpa = throw "tumpa has been removed, as it is broken"; # Added 2024-07-15
  turbogit = throw "turbogit has been removed as it is unmaintained upstream and depends on an insecure version of libgit2"; # Added 2024-08-25
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  tvheadend = throw "tvheadend has been removed as it nobody was willing to maintain it and it was stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  typst-fmt = typstfmt; # Added 2023-07-15
  typst-lsp = throw "'typst-lsp' has been removed due to lack of upstream maintenance, consider using 'tinymist' instead"; # Added 2025-01-25
  typst-preview = throw "The features of 'typst-preview' have been consolidated to 'tinymist', an all-in-one language server for typst"; # Added 2024-07-07

  ### U ###

  uade123 = uade; # Added 2022-07-30
  uae = throw "'uae' has been removed due to lack of upstream maintenance. Consider using 'fsuae' instead."; # Added 2025-06-11
  uberwriter = throw "'uberwriter' has been renamed to/replaced by 'apostrophe'"; # Converted to throw 2024-10-17
  ubootBeagleboneBlack = throw "'ubootBeagleboneBlack' has been renamed to/replaced by 'ubootAmx335xEVM'"; # Converted to throw 2024-10-17
  ubuntu_font_family = ubuntu-classic; # Added 2024-02-19
  uclibc = uclibc-ng; # Added 2022-06-16
  unicap = throw "'unicap' has been removed because it is unmaintained"; # Added 2025-05-17
  unicorn-emu = throw "'unicorn-emu' has been renamed to/replaced by 'unicorn'"; # Converted to throw 2024-10-17
  uniffi-bindgen = throw "uniffi-bindgen has been removed since upstream no longer provides a standalone package for the CLI";
  unifi-poller = unpoller; # Added 2022-11-24
  unifi-video = throw "unifi-video has been removed as it has been unsupported upstream since 2021"; # Added 2024-10-01
  unifi5 = throw "'unifi5' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifi6 = throw "'unifi6' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifi7 = throw "'unifi7' has been removed since it is vulnerable to CVE-2024-42025 and its required MongoDB version is EOL."; # Added 2024-10-01
  unifi8 = throw "'unifi8' has been removed. Use `pkgs.unifi` instead."; # Converted to throw 2025-05-10
  unifiLTS = throw "'unifiLTS' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Added 2024-04-11
  unifiStable = throw "'unifiStable' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Converted to throw 2024-04-11
  unl0kr = throw "'unl0kr' is now included with buffybox. Use `pkgs.buffybox` instead."; # Removed 2024-12-20
  untrunc = throw "'untrunc' has been renamed to/replaced by 'untrunc-anthwlock'"; # Converted to throw 2024-10-17
  unzoo = throw "'unzoo' has been removed since it is unmaintained upstream and doesn't compile with newer versions of GCC anymore"; # Removed 2025-05-24
  uq = throw "'uq' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  urxvt_autocomplete_all_the_things = throw "'urxvt_autocomplete_all_the_things' has been renamed to/replaced by 'rxvt-unicode-plugins.autocomplete-all-the-things'"; # Converted to throw 2024-10-17
  urxvt_bidi = throw "'urxvt_bidi' has been renamed to/replaced by 'rxvt-unicode-plugins.bidi'"; # Converted to throw 2024-10-17
  urxvt_font_size = throw "'urxvt_font_size' has been renamed to/replaced by 'rxvt-unicode-plugins.font-size'"; # Converted to throw 2024-10-17
  urxvt_perl = throw "'urxvt_perl' has been renamed to/replaced by 'rxvt-unicode-plugins.perl'"; # Converted to throw 2024-10-17
  urxvt_perls = throw "'urxvt_perls' has been renamed to/replaced by 'rxvt-unicode-plugins.perls'"; # Converted to throw 2024-10-17
  urxvt_tabbedex = throw "'urxvt_tabbedex' has been renamed to/replaced by 'rxvt-unicode-plugins.tabbedex'"; # Converted to throw 2024-10-17
  urxvt_theme_switch = throw "'urxvt_theme_switch' has been renamed to/replaced by 'rxvt-unicode-plugins.theme-switch'"; # Converted to throw 2024-10-17
  urxvt_vtwheel = throw "'urxvt_vtwheel' has been renamed to/replaced by 'rxvt-unicode-plugins.vtwheel'"; # Converted to throw 2024-10-17
  ut2004Packages = throw "UT2004 requires libstdc++5 which is not supported by nixpkgs anymore"; # Added 2024-11-24
  ut2004demo = ut2004Packages; # Added 2024-11-24
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24, keep until node2nix is phased out, see https://github.com/NixOS/nixpkgs/issues/229475

  ### V ###

  v8 = throw "`v8` has been removed as it's unmaintained for several years and has vulnerabilites. Please migrate to `nodejs.libv8`"; # Added 2024-12-21
  validphys2 = throw "validphys2 has been removed, since it has a broken dependency that was removed"; # Added 2024-08-21
  vamp = {
    vampSDK = vamp-plugin-sdk;
  }; # Added 2020-03-26
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaapiVdpau = libva-vdpau-driver; # Added 2024-06-05
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  varnish74 = throw "varnish 7.4 is EOL. Either use the LTS or upgrade."; # Added 2024-10-31
  varnish74Packages = throw "varnish 7.4 is EOL. Either use the LTS or upgrade."; # Added 2024-10-31
  varnish75 = throw "varnish 7.5 is EOL. Either use the LTS or upgrade."; # Added 22025-03-29
  varnish75Packages = throw "varnish 7.5 is EOL. Either use the LTS or upgrade."; # Added 2025-03-29
  varnish76 = throw "varnish 7.6 is EOL. Either use the LTS or upgrade."; # Added 2025-05-15
  varnish76Packages = throw "varnish 7.6 is EOL. Either use the LTS or upgrade."; # Added 2025-05-15
  vbetool = throw "'vbetool' has been removed as it is broken and not maintained upstream."; # Added 2025-06-11
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  verilog = iverilog; # Added 2024-07-12
  vieb = throw "'vieb' has been removed as it doesn't satisfy our security criteria for browsers."; # Added 2025-06-25
  ViennaRNA = viennarna; # Added 2023-08-23
  vimHugeX = vim-full; # Added 2022-12-04
  vim_configurable = vim-full; # Added 2022-12-04
  vinagre = throw "'vinagre' has been removed as it has been archived upstream. Consider using 'gnome-connections' or 'remmina' instead"; # Added 2024-09-14
  libviper = throw "'libviper' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libviperfx = throw "'libviperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  vimix-cursor-theme = throw "'vimix-cursor-theme' has been superseded by 'vimix-cursors'"; # Added 2025-03-04
  viper4linux-gui = throw "'viper4linux-gui' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  viper4linux = throw "'viper4linux' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  virtscreen = throw "'virtscreen' has been removed, as it was broken and unmaintained"; # Added 2024-10-17
  vistafonts = vista-fonts; # Added 2025-02-03
  vistafonts-chs = vista-fonts-chs; # Added 2025-02-03
  vistafonts-cht = vista-fonts-cht; # Added 2025-02-03
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  vmware-horizon-client = throw "'vmware-horizon-client' has been renamed to 'omnissa-horizon-client'"; # Added 2025-04-24
  vocal = throw "'vocal' has been archived upstream. Consider using 'gnome-podcasts' or 'kasts' instead."; # Added 2025-04-12
  void = throw "'void' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  volnoti = throw "'volnoti' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  vtk_9 = lib.warnOnInstantiate "'vtk_9' has been renamed to 'vtk_9_5'" vtk_9_5; # Added 2025-07-18
  vtk_9_egl = lib.warnOnInstantiate "'vtk_9_5' now build with egl support by default, so `vtk_9_egl` is deprecated, consider using 'vtk_9_5' instead." vtk_9_5; # Added 2025-07-18
  vtk_9_withQt5 = throw "'vtk_9_withQt5' has been removed, Consider using 'vtkWithQt5' instead." vtkWithQt5; # Added 2025-07-18
  vuze = throw "'vuze' was removed because it is unmaintained upstream and insecure (CVE-2018-13417). BiglyBT is a maintained fork."; # Added 2024-11-22
  vwm = throw "'vwm' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  inherit (libsForQt5.mauiPackages) vvave; # added 2022-05-17

  ### W ###
  wakatime = wakatime-cli; # 2024-05-30
  wal_e = throw "wal_e was removed as it is unmaintained upstream and depends on the removed boto package; upstream recommends using wal-g or pgbackrest"; # Added 2024-09-22
  wapp = tclPackages.wapp; # Added 2024-10-02
  wavebox = throw "'wavebox' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-24
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_100;
  watershot = throw "'watershot' has been removed as it is unmaintained upstream and no longer works"; # Added 2025-06-01
  wayfireApplications-unwrapped = throw ''
    'wayfireApplications-unwrapped.wayfire' has been renamed to/replaced by 'wayfire'
    'wayfireApplications-unwrapped.wayfirePlugins' has been renamed to/replaced by 'wayfirePlugins'
    'wayfireApplications-unwrapped.wcm' has been renamed to/replaced by 'wayfirePlugins.wcm'
    'wayfireApplications-unwrapped.wlroots' has been removed
  ''; # Add 2023-07-29
  waypoint = throw "waypoint has been removed from nixpkgs as the upstream project was archived"; # Added 2024-04-24
  wcurl = throw "'wcurl' has been removed due to being bundled with 'curl'"; # Added 2025-07-04
  webfontkitgenerator = webfont-bundler; # Added 2025-07-27
  webkitgtk = throw "'webkitgtk' attribute has been removed from nixpkgs, use attribute with ABI version set explicitly"; # Added 2025-06-11
  webmetro = throw "'webmetro' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  wg-bond = throw "'wg-bond' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  whatsapp-for-linux = wasistlos; # Added 2025-01-30
  wineWayland = wine-wayland;
  winhelpcgi = throw "'winhelpcgi' has been removed as it was unmaintained upstream and broken with GCC 14"; # Added 2025-06-14
  win-virtio = virtio-win; # Added 2023-10-17
  wireguard-vanity-address = throw "'wireguard-vanity-address' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  wkhtmltopdf-bin = wkhtmltopdf; # Added 2024-07-17
  wlroots_0_16 = throw "'wlroots_0_16' has been removed in favor of newer versions"; # Added 2024-07-14
  wlroots = wlroots_0_19; # wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wordpress6_3 = throw "'wordpress6_3' has been removed in favor of the latest version"; # Added 2024-08-03
  wordpress6_4 = throw "'wordpress6_4' has been removed in favor of the latest version"; # Added 2024-08-03
  wordpress6_5 = wordpress_6_5; # Added 2024-08-03
  wordpress_6_5 = throw "'wordpress_6_5' has been removed in favor of the latest version"; # Added 2024-11-11
  wordpress_6_6 = throw "'wordpress_6_6' has been removed in favor of the latest version"; # Added 2024-11-17
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wpa_supplicant_ro_ssids = lib.warnOnInstantiate "Deprecated package: Please use wpa_supplicant instead. Read-only SSID patches are now upstream!" wpa_supplicant;
  wrapLisp_old = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  wmii_hg = wmii;
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  write_stylus = styluslabs-write-bin; # Added 2024-10-09

  ### X ###

  x11idle = throw "'x11idle' has been removed as the upstream is no longer available. Please see 'xprintidle' as an alternative"; # Added 2025-03-10
  x509-limbo = throw "'x509-limbo' has been removed from nixpkgs"; # Added 2024-10-22
  xarchive = throw "'xarchive' has been removed due to lack of maintenance upstream. Consider using 'file-roller' instead"; # Added 2024-10-19
  xbmc-retroarch-advanced-launchers = throw "'xbmc-retroarch-advanced-launchers' has been renamed to/replaced by 'kodi-retroarch-advanced-launchers'"; # Converted to throw 2024-10-17
  xboxdrv = throw "'xboxdrv' has been dropped as it has been superseded by an in-tree kernel driver"; # Added 2024-12-25
  xbursttools = throw "'xbursttools' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-12
  xdg_utils = throw "'xdg_utils' has been renamed to/replaced by 'xdg-utils'"; # Converted to throw 2024-10-17
  xdragon = dragon-drop; # Added 2025-03-22
  xen-light = throw "'xen-light' has been renamed to/replaced by 'xen-slim'"; # Added 2024-06-30
  xen-slim = throw "'xen-slim' has been renamed to 'xen'. The old Xen package with built-in components no longer exists"; # Added 2024-10-05
  xen_4_16 = throw "While Xen 4.16 was still security-supported when it was removed from Nixpkgs, it would have reached its End of Life a couple of days after NixOS 24.11 released. To avoid shipping an insecure version of Xen, the Xen Project Hypervisor Maintenance Team decided to delete the derivation entirely"; # Added 2024-10-05
  xen_4_17 = throw "Due to technical challenges involving building older versions of Xen with newer dependencies, the Xen Project Hypervisor Maintenance Team decided to switch to a latest-only support cycle. As Xen 4.17 would have been the 'n-2' version, it was removed"; # Added 2024-10-05
  xen_4_18 = throw "Due to technical challenges involving building older versions of Xen with newer dependencies, the Xen Project Hypervisor Maintenance Team decided to switch to a latest-only support cycle. As Xen 4.18 would have been the 'n-1' version, it was removed"; # Added 2024-10-05
  xen_4_19 = throw "Use 'xen' instead"; # Added 2024-10-05
  xenPackages = throw "The attributes in the xenPackages set have been promoted to the top-level. (xenPackages.xen_4_19 -> xen)";
  xineLib = throw "'xineLib' has been renamed to/replaced by 'xine-lib'"; # Converted to throw 2024-10-17
  xineUI = throw "'xineUI' has been renamed to/replaced by 'xine-ui'"; # Converted to throw 2024-10-17
  xlsxgrep = throw "'xlsxgrep' has been dropped due to lack of maintenance."; # Added 2024-11-01
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xmlroff = throw "'xmlroff' has been removed as it is unmaintained and broken"; # Added 2025-05-18
  xmr-stak = throw "xmr-stak has been removed from nixpkgs because it was broken"; # Added 2024-07-15
  xmake-core-sv = throw "'xmake-core-sv' has been removed, use 'libsv' instead"; # Added 2024-10-10
  xournal = throw "'xournal' has been removed due to lack of activity upstream and depending on gnome2. Consider using 'xournalpp' instead."; # Added 2024-12-06
  xonsh-unwrapped = python3Packages.xonsh; # Added 2024-06-18
  xplayer = throw "xplayer has been removed as the upstream project was archived"; # Added 2024-12-27
  xprite-editor = throw "'xprite-editor' has been removed due to lack of maintenance upstream. Consider using 'pablodraw' or 'aseprite' instead"; # Added 2024-09-14
  xsd = throw "'xsd' has been removed."; # Added 2025-04-02
  xsv = throw "'xsv' has been removed due to lack of upstream maintenance. Please see 'xan' for a maintained alternative";
  xtrlock-pam = throw "xtrlock-pam has been removed because it is unmaintained for 10 years and doesn't support Python 3.10 or newer"; # Added 2025-01-25
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  xvfb_run = throw "'xvfb_run' has been renamed to/replaced by 'xvfb-run'"; # Converted to throw 2024-10-17
  xwaylandvideobridge = makePlasma5Throw "xwaylandvideobridge"; # Added 2024-09-27
  xxv = throw "'xxv' has been removed due to lack of upstream maintenance"; # Added 2025-01-25

  ### Y ###

  yacc = throw "'yacc' has been renamed to/replaced by 'bison'"; # Converted to throw 2024-10-17
  yesplaymusic = throw "YesPlayMusic has been removed as it was broken, unmaintained, and used deprecated Node and Electron versions"; # Added 2024-12-13
  yafaray-core = libyafaray; # Added 2022-09-23
  yandex-browser = throw "'yandex-browser' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  yandex-browser-beta = throw "'yandex-browser-beta' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  yandex-browser-corporate = throw "'yandex-browser-corporate' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  youtrack_2022_3 = throw "'youtrack_2022_3' has been removed as it was deprecated. Please update to the 'youtrack' package."; # Added 2024-10-17
  yabar = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yabar-unstable = yabar; # Added 2025-06-10
  yeahwm = throw "'yeahwm' has been removed, as it was broken and unmaintained upstream."; # Added 2025-06-12
  yrd = throw "'yrd' has been removed, as it was broken and unmaintained"; # added 2024-05-27
  yubikey-manager-qt = throw "'yubikey-manager-qt' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  yubikey-personalization-gui = throw "'yubikey-personalization-gui' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  yuzu-ea = throw "yuzu-ea has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu-early-access = throw "yuzu-early-access has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu = throw "yuzu has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu-mainline = throw "yuzu-mainline has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzuPackages = throw "yuzuPackages has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04

  ### Z ###

  z3_4_11 = throw "'z3_4_11' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_12 = throw "'z3_4_12' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_13 = throw "'z3_4_13' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_14 = throw "'z3_4_14' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_8_5 = throw "'z3_4_8_5' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_8 = throw "'z3_4_8' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  zabbix50 = throw "'zabbix50' has been removed, it would have reached its End of Life a few days after the release of NixOS 25.05. Consider upgrading to 'zabbix60' or 'zabbix70'.";
  zabbix64 = throw "'zabbix64' has been removed because it reached its End of Life. Consider upgrading to 'zabbix70'.";
  zeroadPackages = recurseIntoAttrs {
    zeroad = lib.warnOnInstantiate "'zeroadPackages.zeroad' has been renamed to 'zeroad'" zeroad; # Added 2025-03-22
    zeroad-data = lib.warnOnInstantiate "'zeroadPackages.zeroad-data' has been renamed to 'zeroad-data'" zeroad-data; # Added 2025-03-22
    zeroad-unwrapped = lib.warnOnInstantiate "'zeroadPackages.zeroad-unwrapped' has been renamed to 'zeroad-unwrapped'" zeroad-unwrapped; # Added 2025-03-22
  };
  zeromq4 = zeromq; # Added 2024-11-03
  zfsStable = zfs; # Added 2024-02-26
  zfsUnstable = zfs_unstable; # Added 2024-02-26
  zfs_2_1 = throw "zfs 2.1 has been removed as it is EOL. Please upgrade to a newer version"; # Added 2024-12-25
  zig_0_9 = throw "zig 0.9 has been removed, upgrade to a newer version instead"; # Added 2025-01-24
  zig_0_10 = throw "zig 0.10 has been removed, upgrade to a newer version instead"; # Added 2025-01-24
  zig_0_11 = throw "zig 0.11 has been removed, upgrade to a newer version instead"; # Added 2025-04-09
  zimlib = throw "'zimlib' has been removed because it was an outdated and unused version of 'libzim'"; # Added 2025-03-07
  zinc = zincsearch; # Added 2023-05-28
  zint = zint-qt; # Added 2025-05-15
  zplugin = throw "'zplugin' has been renamed to/replaced by 'zinit'"; # Converted to throw 2024-10-17
  zk-shell = throw "zk-shell has been removed as it was broken and unmaintained"; # Added 2024-08-10
  zkg = throw "'zkg' has been replaced by 'zeek'";
  zsh-history = throw "'zsh-history' has been removed as it was unmaintained"; # Added 2025-04-17
  zq = zed.overrideAttrs (old: {
    meta = old.meta // {
      mainProgram = "zq";
    };
  }); # Added 2023-02-06
  zyn-fusion = zynaddsubfx; # Added 2022-08-05
  zz = throw "'zz' has been removed because it was archived in 2022 and had no maintainer"; # added 2024-05-10

  ### UNSORTED ###

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22
  inherit (stdenv) buildPlatform hostPlatform targetPlatform; # Added 2023-01-09

  freebsdCross = freebsd; # Added 2024-09-06
  netbsdCross = netbsd; # Added 2024-09-06
  openbsdCross = openbsd; # Added 2024-09-06

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_20;

  /*
    If these are in the scope of all-packages.nix, they cause collisions
      between mixed versions of qt. See:
    https://github.com/NixOS/nixpkgs/pull/101369
  */

  kalendar = merkuro; # Renamed in 23.08
  kfloppy = throw "kfloppy has been removed upstream in KDE Gear 23.08";

  inherit (pidginPackages)
    pidgin-indicator
    pidgin-latex
    pidgin-msn-pecan
    pidgin-mra
    pidgin-skypeweb
    pidgin-carbons
    pidgin-xmpp-receipts
    pidgin-otr
    pidgin-osd
    pidgin-sipe
    pidgin-window-merge
    purple-discord
    purple-googlechat
    purple-hangouts
    purple-lurch
    purple-matrix
    purple-mm-sms
    purple-plugin-pack
    purple-slack
    purple-vk-plugin
    purple-xmpp-http-upload
    tdlib-purple
    pidgin-opensteamworks
    purple-facebook
    ;

}
// plasma5Throws
