{ config, pkgs, user, ... }:

{
  imports = [
    ./programs
  ];

  # Basic home configuration
  home.packages = with pkgs; [
    librewolf
    git
    #neovim
  ];

  home.stateVersion = "24.11";
}
