{
  description = "Homelab configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs pkgs;};
      modules = [./config/configuration.nix];
    };
  };
}
