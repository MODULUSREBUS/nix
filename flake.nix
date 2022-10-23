{
  inputs = {
    flake-utils.url = github:numtide/flake-utils/master;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    rust-overlay = {
      url = github:oxalica/rust-overlay/master;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay }:
    {
      lib = flake-utils.lib;
      templates.default = {
        path = ./template;
        description = "MODULUSREBUS rust flake";
      };
    }
    //
    flake-utils.lib.eachDefaultSystem (system: rec
    {
      packages = (import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlay
        ];
      });

      devShells.default = (import ./shell.nix {
        pkgs = packages;
      });
    });
}
