{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs
    ripgrep
    fd
    # git # in /home/default.nix
  ];
}
