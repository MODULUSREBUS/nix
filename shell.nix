{ pkgs }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gh
  ];
}
