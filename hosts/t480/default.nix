{ config, lib, pkgs, user, inputs, ... }:

{
  imports = [
    # Import hardware configuration
    ./hardware-configuration.nix
  ];

  # Machine identity
  networking = {
    hostName = "t480";
    networkmanager.enable = true;
  };

  # Boot configuration
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # ZFS configuration
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/disk/by-id";
    
    # Kernel and parameters
    kernelPackages = pkgs.linuxPackages_6_6;
    kernelParams = [ "zfs.zfs_arc_max=2147483648" ];
    
    # Kernel settings for ZFS
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 10;
      "vfs.zfs.prefetch_disable" = 1;
      "vfs.zfs.mdcomp_disable" = 0;
    };
    
    # LUKS configuration
    initrd.luks.devices = {
      "crypted" = {
        device = "/dev/disk/by-uuid/7487b393-930c-4820-831b-0acf498f439e";
        preLVM = true;
      };
    };
  };

  # ZFS services
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
    trim.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 2;
      hourly = 12;
      daily = 5;
      weekly = 2;
      monthly = 6;
    };
    zed = {
      settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";
        ZED_SYSLOG_PRIORITY = "warning"; 
      };
    };
  };

  # Set host ID for ZFS
  networking.hostId = "cebd22b3";

  # Time zone
  time.timeZone = "America/Los_Angeles";

  # Machine-specific packages
  environment.systemPackages = with pkgs; [
    zfs-prune-snapshots
  ];

  # This value is used to determine compatibility
  # Do not change this after initial installation
  system.stateVersion = "24.11";
}
