{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  fetchpatch,
  flex,
  db4,
  gettext,
  audit,
  libxcrypt,
  nixosTests,
  autoreconfHook269,
  pkg-config-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "linux-pam";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
    hash = "sha256-+JI8dAFZBS1xnb/CovgZQtaN00/K9hxwagLJuA/u744=";
  };

  patches = [
    ./suid-wrapper-path.patch
    # required for fixing CVE-2025-6020
    (fetchpatch {
      url = "https://github.com/linux-pam/linux-pam/commit/10b80543807e3fc5af5f8bcfd8bb6e219bb3cecc.patch";
      hash = "sha256-VS3D3wUbDxDXRriIuEvvgeZixzDA58EfiLygfFeisGg=";
    })
    # Manually cherry-picked from 475bd60c552b98c7eddb3270b0b4196847c0072e
    ./CVE-2025-6020.patch
  ];

  # Case-insensitivity workaround for https://github.com/linux-pam/linux-pam/issues/569
  postPatch =
    lib.optionalString (stdenv.buildPlatform.isDarwin && stdenv.buildPlatform != stdenv.hostPlatform)
      ''
        rm CHANGELOG
        touch ChangeLog
      '';

  outputs = [
    "out"
    "doc"
    "man" # "modules"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  # autoreconfHook269 is needed for `suid-wrapper-path.patch` above.
  # pkg-config-unwrapped is needed for `AC_CHECK_LIB` and `AC_SEARCH_LIBS`
  nativeBuildInputs = [
    flex
    autoreconfHook269
    pkg-config-unwrapped
  ]
  ++ lib.optional stdenv.buildPlatform.isDarwin gettext;

  buildInputs = [
    db4
    libxcrypt
  ]
  ++ lib.optional stdenv.buildPlatform.isLinux audit;

  enableParallelBuilding = true;

  configureFlags = [
    "--includedir=${placeholder "out"}/include/security"
    "--enable-sconfigdir=/etc/security"
    # The module is deprecated. We re-enable it explicitly until NixOS
    # module stops using it.
    "--enable-lastlog"
  ];

  installFlags = [
    "SCONFIGDIR=${placeholder "out"}/etc/security"
  ];

  doCheck = false; # fails

  passthru.tests = {
    inherit (nixosTests)
      pam-oath-login
      pam-u2f
      shadow
      sssd-ldap
      ;
  };

  meta = with lib; {
    homepage = "https://github.com/linux-pam/linux-pam";
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
