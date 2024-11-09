{ pkgs, ... }:
let
  user = "lexi";
  password = "password";
  hostname = "homelab";
in {

  # File system config
  # Loads hard drives permanently

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };


  # RPI specific configuration

  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
    
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
    ];
  };

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";


  # Base configuration

  networking.hostName = hostname;
  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [ 
    vim 
  ];


  system.stateVersion = "24.05";
  nixpkgs.hostPlatform.system = pkgs.system;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}