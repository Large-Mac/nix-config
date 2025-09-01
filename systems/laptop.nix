{ config, lib, pkgs, user, inputs, ... }:

{
  # Desktop environment
  services.xserver = {
    enable = true;
    desktopManager.cinnamon.enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+dwm";
    };

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = /home/neo/.config/suckless/dwm;
      };
    };

    xkb.layout = "us";
  };
 
    # Touchpad configuration
    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        middleEmulation = true;
        disableWhileTyping = true;
      };
    };

  # Laptop power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Power saving
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      # Battery conservation
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      
      # PCIe power management
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };
  
  # Disable power-profiles-daemon to avoid conflict with TLP
  services.power-profiles-daemon.enable = false;

  # Thermald for thermal management
  services.thermald.enable = true;
  
  # Enable fingerprint reader (if available)
  services.fprintd.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Save power, enable only when needed
  };

  # Enable sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Display brightness and volume keys
  services.acpid.enable = true;
  
  # Enable CUPS for printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };
  
  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  
  # Sleep/hibernate settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    settings.Login = ''
      HandlePowerKey=suspend
      IdleAction=suspend
      IdleActionSec=20min
    '';
  };

  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # Power management tools
    acpi
    powertop
    
    # Hardware tools
    pciutils
    usbutils
    
    # Networking tools
    networkmanagerapplet
    blueman
    
    # Screen brightness control
    brightnessctl
    
    # Common laptop software
    firefox
    libreoffice
    gimp
    vlc
  ];
}
