{ config, lib, pkgs, user, inputs, ... }:

{
  # Desktop environment - more full-featured for a desktop
  services.xserver = {
    enable = true;
    desktopManager = {
      cinnamon.enable = true;
      # Potentially add more desktop options for desktop
    };
    displayManager.lightdm.enable = true;
    xkb.layout = "us";
  };

  # Graphics drivers - example for NVIDIA
  # Adjust based on your actual graphics hardware
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  # Example for NVIDIA - uncomment if needed
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   open = false;
  #   nvidiaSettings = true;
  # };

  # Audio configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # For pro audio if needed
  };

  # Printing support
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };

  # Desktop-specific services
  services = {
    # For automatic media mounting
    gvfs.enable = true;
    tumbler.enable = true; # Thumbnail service
    
    # Enable flatpak for desktop applications
    flatpak.enable = true;
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    # Desktop applications
    firefox
    chromium 
    libreoffice
    thunderbird
    vlc
    gimp
    obs-studio
    
    # Development tools
    vscode
    
    # System tools
    gparted
    
    # Gaming (if applicable)
    steam
    lutris
    wine
  ];
}
