{ pkgs }:

with pkgs;

mkShell {
  buildInputs = [
    git
    hub
  ];
}
