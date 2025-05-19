# home/t480/default.nix
{ config, lib, pkgs, ... }:

{
  # Import the common configuration
  imports = [ ../common ];

  # Add T480-specific packages
  home.packages = with pkgs; [
    # Power management tools
    powertop
    acpi
    tlp
    
    # Laptop-specific tools
    xorg.xbacklight # For screen brightness
    networkmanager_dmenu # Network management
  ];

  # T480-specific program configurations
  programs = {
    # Override any settings from common
    bash.shellAliases = {
      # Inherit all common aliases, DO NOT UNCOMMENT, CAUSES INFINTE RECURSION
      #inherit (config.programs.bash.shellAliases) ll update home-update cleanup;
      
      # Add laptop-specific aliases
      battery = "acpi -b";
      powersave = "sudo tlp start";
    };
  };

  # Laptop-specific services
  services = {
    # Battery notification service
    batsignal = {
      enable = true;
      extraArgs = ["-w" "15" "-c" "5" "-d" "2" "-I" "battery-low"];
    };
  };
}
