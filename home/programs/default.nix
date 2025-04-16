{ config, pkgs, lib, ... }:

let
  # Get all .nix files from this directory except default.nix, and is called in /home/default.nix
  programFiles = builtins.attrNames (builtins.readDir ./.);
  programImports = map 
    (name: ./. + "/${name}") 
    (builtins.filter (name: name != "default.nix" && lib.hasSuffix ".nix" name) programFiles);
in
{
  imports = programImports;
}
