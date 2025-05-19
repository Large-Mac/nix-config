# hosts/mainpc/default.nix
{ config, lib, pkgs, user, inputs, ... }:

{
  imports = [
    # Import hardware configuration
    ./hardware-configuration.nix
  ];

  # Machine identity
  networking = {
    hostName = "mainpc";
    # Using networkmanager or fixed config based on preference
    networkmanager.enable = true;
  };

  # Boot configuration
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # Kernel and parameters for desktop use
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Time zone
  time.timeZone = "America/Los_Angeles";

  # Machine-specific packages
  environment.systemPackages = with pkgs; [
    # Any desktop-specific utilities
  ];

  # System state version
  system.stateVersion = "24.11";
}
