# Basic system configuration shared by all machines
{ config, lib, pkgs, user, ... }:

{
  # Enable nix flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "${user}" ];
    };
  };

  # User account setup, trying to fix an error w/ switching flakes to t480
  users.users.${user} = {
    isNormalUser = true;
    group = "${user}";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" ];
    home = "/home/${user}";
  };

  # Create user group
  users.groups.${user} = {}; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    wget
    curl
    git
    vim
    htop
    podman
  ];

  # Security settings
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = ["${user}"];
    keepEnv = true; 
    persist = true;
  }];

  # Virtualization requirements
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups.libvirtd.members = ["${user}"];

virtualisation = {
  podman = {
    enable = true;
    dockerCompat = true;
  };
  containers = {
    enable = true;
    storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
      };
    };
    containersConf.settings = {
      containers = {
        default_capabilities = [
          "CHOWN"
          "DAC_OVERRIDE"
          "FOWNER"
          "FSETID"
          "KILL"
          "NET_BIND_SERVICE"
          "SETFCAP"
          "SETGID"
          "SETPCAP"
          "SETUID"
          "SYS_CHROOT"
        ];
      };
      engine = {
        runtime = "crun";
      };
    };
  };
};

  # System state version - adjust according to your NixOS version
  system.stateVersion = "24.11";
}
