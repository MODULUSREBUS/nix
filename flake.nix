{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    flake-utils.url = github:numtide/flake-utils/master;
    devshell = {
      url = "github:numtide/devshell/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    rust-overlay = {
      url = github:oxalica/rust-overlay/master;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, devshell, rust-overlay }:
    {
      lib = flake-utils.lib;

      templates.default = {
        path = ./template;
        description = "MODULUSREBUS rust flake";
      };
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
    {
      packages = let
        pkgs = (import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlay
            rust-overlay.overlays.default
          ];
        });
      in pkgs // {
        twiggy = pkgs.callPackage ./pkgs/twiggy.nix { };
        wasm-bindgen-cli = pkgs.callPackage ./pkgs/wasm-bindgen-cli.nix { };
      };

      devShells.default = (import ./shell.nix {
        pkgs = self.packages.${system};
      });
    });
}
