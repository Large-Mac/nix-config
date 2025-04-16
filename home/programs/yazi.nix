{ config, pkgs, lib, ... }:

{
  # Install yazi and its dependencies
  home.packages = with pkgs; [
    yazi  # The file manager itself
    file  # For filetype detection
    #fd    # For better search
    #ripgrep # For content search
    ffmpegthumbnailer # For video thumbnails
    unar  # For archive preview
    poppler # For PDF preview
    imagemagick # For image processing
  ];
}
