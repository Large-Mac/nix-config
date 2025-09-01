{ config, lib, pkgs, user, inputs, ... }:

{

  # Basic packages you want everywhere
  home.packages = with pkgs; [
    # Terminal utilities
    btop
    htop
    neofetch
    ripgrep
    fd
    jq
    tmux
    wget
    curl
    unzip
    tree
    gnumake
    cmake
    chezmoi
    podman
    distrobox
    yazi
    yt-dlp
    ispell
    xclip
    file
  
    # Development tools
    gcc
    #clang
    nodejs
    git
    neovim
    emacs
    kitty
    alacritty
    xterm

    # WM Packages
    feh
    picom
    pywal
    devour
    pamixer
    acpi
    lm_sensors

    (dwm.overrideAttrs {
      src = builtins.path {
        name = "dwmblocks-source";
        path = "${config.home.homeDirectory}/.config/suckless/dwm";
      };
    })

    (dwmblocks.overrideAttrs {
      src = builtins.path {
        name = "dwmblocks-source";
        path = "${config.home.homeDirectory}/.config/suckless/dwmblocks";
      };
    })

    (dmenu.overrideAttrs {
      src = builtins.path {
        name = "dmenu-source";
        path = "${config.home.homeDirectory}/.config/suckless/dmenu";
      };
    })    
   
   # Text processing
    bat # Better cat with syntax highlighting
    fzf # Fuzzy finder
    
    # Fonts
    nerd-fonts.iosevka
    nerd-fonts.hack
    nerd-fonts.terminess-ttf
    nerd-fonts.symbols-only
    iosevka-comfy.comfy-wide
    aporetic

    # Nix-specific tools
    nixfmt # Nix formatter
    nix-index # Files database for Nix
    nix-tree # Interactive browser for Nix
  ];

  xsession = {
    enable = true;
  };


  # Configure programs you use on all machines
  programs = {
    # Shell configuration
    bash = {
      enable = true;
    };

    # Git configuration
    git = {
      enable = true;
      userName = "Large-Mac";
      userEmail = "bighaodwofad@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
  };

  # Don't forget to add this state version
  # This value determines the Home Manager release with which your
  # configuration is compatible. This helps avoid breakage when a
  # new Home Manager release changes configuration options.
  #
  # You should not change this value, even if you update Home Manager.
  # If you do want to update the value, then make sure to first
  # check the Home Manager release notes.
  home.stateVersion = "24.11";
}
