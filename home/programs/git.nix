{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Large-Mac";
    userEmail = "bighaodwofad@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
