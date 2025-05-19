# hosts/vm/default.nix
{ config, lib, pkgs, user, inputs, ... }:

{
  imports = [
    # Import hardware configuration
    ./hardware-configuration.nix
  ];

  # Machine identity
  networking = {
    hostName = "vm";
    networkmanager.enable = true;
  };

  # Boot configuration - simplified for a VM
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; # or appropriate device

  # Time zone
  time.timeZone = "America/Los_Angeles";

  # Machine-specific packages
  environment.systemPackages = with pkgs; [
    # VM-specific utilities
  ];

  # System state version
  system.stateVersion = "24.11";
}
