{ config, lib, pkgs, user, inputs, ... }:

{
  # Lightweight desktop environment for VM
  services.xserver = {
    enable = true;
    # Use a lighter DE for VMs
    desktopManager = {
      xfce.enable = true;
    };
    displayManager.lightdm.enable = true;
    xkb.layout = "us";
  };

  # VM-specific optimizations
  services.spice-vdagentd.enable = true; # If using SPICE
  services.qemuGuest.enable = true; # If running on QEMU
  
  # Optional: VirtualBox guest additions
  # virtualisation.virtualbox.guest.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Minimal packages for VM
  environment.systemPackages = with pkgs; [
    firefox
    vim
    git
    htop
    xfce.thunar
    xfce.xfce4-terminal
  ];

  # Lower resource usage for VM
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "${user}";
  };

  # Shared folder mounting (if applicable)
  # fileSystems."/shared" = {
  #   device = "shared_folder";
  #   fsType = "9p";
  #   options = [ "trans=virtio" "version=9p2000.L" ];
  # };
}
