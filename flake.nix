{
  description = ''
    A Nixpkgs tracker with notifications!
  '';

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;
    eachSystem = f:
      lib.genAttrs ["x86_64-linux"]
      (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = eachSystem (pkgs: {
      big-brother = pkgs.callPackage ./nix/package.nix {};
      default = self.packages.${pkgs.stdenv.system}.big-brother;
    });

    nixosModules = {
      big-brother = import ./nix/module.nix inputs;
      default = self.nixosModules.big-brother;
    };

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          cargo
          rustc
          rust-analyzer
          rustfmt
          pkg-config
          openssl
          sqlx-cli
        ];
      };
    });
  };
}
