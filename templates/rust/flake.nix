{
  inputs = {
    nix.url = github:MODULUSREBUS/nix;
  };

  outputs = { self, nix }:
    with nix.lib;
    eachSystem [ system.x86_64-linux ] (system: {
      devShell = with nix.packages.${system}; let
        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rls-preview"
          ];
          targets = [
            "x86_64-unknown-linux-gnu"
          ];
        };
      in mkShell {
        buildInputs = [
          git
          gnumake

          rust
          rls

          pkg-config
          openssl
        ];
      };
    });
}
