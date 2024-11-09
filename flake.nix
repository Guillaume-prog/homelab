{
  description = "Homelab configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { nixpkgs, ... }@inputs: 
  let
    system = "aarch64-linux";
    pkgs = import nixpkgs { inherit system; };

  in {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs pkgs; };
      modules = [ ./configuration.nix ];
    };
  };
}