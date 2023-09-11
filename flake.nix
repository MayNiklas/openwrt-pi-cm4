{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-environments.url = "github:nix-community/nix-environments";
  };

  outputs = { self, nixpkgs, nix-environments }:
    let
      systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    {
      devShells = nixpkgs.lib.genAttrs systems
        (system: rec {
          default = nix-environments.devShells.${system}.openwrt;
          openwrt-ci = nix-environments.devShells.${system}.openwrt-ci;
        });
    };
}
