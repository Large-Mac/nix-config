{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
    # Core dependencies
      gcc
      #ripgrep # in emacs.nix
      #fd # in emacs.nix
    ];
  };
}
  
