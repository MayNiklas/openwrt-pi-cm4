{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    {
      devShells = nixpkgs.lib.genAttrs systems
        (system: rec {
          default = openwrt.env;
          # https://github.com/nix-community/nix-environments/blob/master/envs/openwrt/shell.nix
          # for CI environments without .env
          openwrt = import ./shell.nix { pkgs = import nixpkgs { inherit system; }; };
        });
    };
}
