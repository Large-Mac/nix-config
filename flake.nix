{
  description = "My modular Nix config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Add nixos-hardware for T480-specific optimizations
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      user = "neo";
      
      # Define a helper function to create system configurations
      mkSystem = { hostname, extraModules ? [] }: 
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit user inputs;
          };
          modules = [
            # Base system configuration
            ./systems/configuration.nix
            # Hostname-specific configuration
            ./hosts/${hostname}
            # Home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home/${hostname};
              home-manager.extraSpecialArgs = {
                inherit user inputs;
              };
            }
          ] ++ extraModules;
        };
        
      # Define a helper function for standalone home-manager configurations
      mkHome = hostname:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit user inputs;
          };
          modules = [
            # Common home configuration
            ./home/common
            # Host-specific home configuration
            ./home/${hostname}
            {
              home = {
                username = user;
                homeDirectory = "/home/${user}";
                stateVersion = "24.11";
              };
              programs.home-manager.enable = true;
            }
          ];
        };
    in {
      # Standalone home-manager configurations for each machine
      homeConfigurations = {
        "${user}@mainpc" = mkHome "mainpc";
        "${user}@t480" = mkHome "t480";
        "${user}@vm" = mkHome "vm";
      };
      
      # NixOS configurations
      nixosConfigurations = {
        # Main desktop PC
        mainpc = mkSystem {
          hostname = "mainpc";
          extraModules = [
            ./systems/desktop.nix
          ];
        };
        
        # T480 laptop
        t480 = mkSystem {
          hostname = "t480";
          extraModules = [
            # Add the T480-specific hardware module
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
            ./systems/laptop.nix
          ];
        };
        
        # Virtual machine
        vm = mkSystem {
          hostname = "vm";
          extraModules = [
            ./systems/vm.nix
          ];
        };
      };
    };
}
