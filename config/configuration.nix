{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName = "homelab"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Headless mode
  services.xserver.enable = false;
  console.keyMap = "fr";

  # SSH
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  services.logind.lidSwitch = "ignore";

  users.users.lexi = {
    isNormalUser = true;
    description = "lexi";
    extraGroups = ["networkmanager" "wheel"];
  };

  system.stateVersion = "24.05";
}
