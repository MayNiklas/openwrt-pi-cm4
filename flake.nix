{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-environments.url = "github:nix-community/nix-environments";
  };

  outputs = { nixpkgs, flake-utils, nix-environments, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      rec {

        # Use nixpkgs-fmt for `nix fmt'
        formatter = pkgs.nixpkgs-fmt;

        devShells = {

          # `nix develop' will open a shell with the packages needed to work with OpenWrt
          default = nix-environments.devShells.${system}.openwrt.overrideAttrs (old: {
            extraPkgs = with pkgs; [ ];
          });

        };

      }
    );
}
