{
  description = "Homelab configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

  outputs = {nixpkgs, ...} @ inputs: 
  let
    params = {
      config-dir = "/config";
      data-dir = "/data";
      user = "lexi";
      hostname = "homelab";
    };
  in {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs params; };
      modules = [./config/configuration.nix];
    };
  };
}
