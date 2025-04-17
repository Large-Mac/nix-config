{ config, pkgs, ... }:

{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  home.sessionVariables = { 
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

}
