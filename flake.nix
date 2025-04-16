{
  description = "My modular Nix config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      user = "neo";
      
      # Define a helper function to create system configurations
      mkSystem = { hostname, extraModules ? [] }: 
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit user;
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
              home-manager.users.${user} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit user;
              };
            }
          ] ++ extraModules;
        };
    in {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit user;
        };
        modules = [
          ./home
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
      
      # Add nixosConfigurations section
      nixosConfigurations = {
        # Define a configuration for a machine named "mainpc"
        mainpc = mkSystem {
          hostname = "mainpc";
          extraModules = [
            # Add machine-specific modules here
            ./systems/desktop.nix
          ];
        };
        
        # You can define additional machines
        laptop = mkSystem {
          hostname = "t480";
          extraModules = [
            ./systems/laptop.nix
          ];
        };
        virtualmachine = mkSystem {
          hostname = "vm";
          extraModules = [
            ./systems/vm.nix
          ];
        };
      };
    };
}
