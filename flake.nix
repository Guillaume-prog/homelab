{
  description = "Development shell with Python and Ansible";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system: 
  let
    pkgs = import nixpkgs { inherit system; };
  in {
    devShell = pkgs.mkShell {
      buildInputs = [
        pkgs.python3
        pkgs.ansible
      ];
      shellHook = ''
        export PS1="\[\e[1;32m\]snake 🐍  \[\e[1;34m\]\$(realpath --relative-to=$PWD $PWD) \[\e[0m\]$ "
        clear
      '';
    };
  });
}