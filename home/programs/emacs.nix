{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    ripgrep
    fd
    # git
  ];
}
