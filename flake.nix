{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
            devshell.overlays.default
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
