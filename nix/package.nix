{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
}: let
  pname = "big-brother";

  version = "1.0.2";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = builtins.path {
      path = ../.;
      name = "${pname}-${version}";
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    useFetchCargoVendor = true;
    cargoHash = "sha256-S04MeFQtcFR6vUlnMRDIZPCpDX/VxWuJyKTzHuws8JU=";

    meta = {
      description = "A nixpkgs tracker with notifications!";
      homepage = "https://github.com/snugnug/big-brother";
      license = lib.licenses.gpl3;
      mainProgram = "big-brother";
    };
  }
