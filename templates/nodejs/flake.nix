{
  inputs = {
    nix.url = github:MODULUSREBUS/nix;
  };

  outputs = { self, nix }:
    with nix.lib;
    eachSystem [ system.x86_64-linux ] (system: {
      devShell = with nix.packages.${system}; mkShell {
        buildInputs = [
          git

          nodejs
          nodePackages.typescript-language-server
        ];
      };
    });
}
