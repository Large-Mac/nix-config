{ config, lib, pkgs, ... }:

{
  # Import the common configuration
  imports = [ ../common ];

  # Add T480-specific packages
  home.packages = with pkgs; [
    pandoc
  ];

