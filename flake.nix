{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esquid = {
      url = "github:Things-N-Stuff/eSquid";
      # url = "path:/data/local-flakes/eSquid";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    yemou-dotfiles = {
      url = "git+https://codeberg.org/yemou/dotfiles";
      flake = false;
    };
    yemou-scripts = {
      url = "git+https://codeberg.org/yemou/scripts";
      # url = "path:/data/local-flakes/scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, impermanence, ... }@inputs: {
    nixosConfigurations = {
      lily = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          impermanence.nixosModules.impermanence
          ./lily/config.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = inputs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mou = import ./lily/home.nix;
            };
          }
        ];
      };
      dandelion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          impermanence.nixosModules.impermanence
          ./dandelion/config.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = inputs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mou = import ./dandelion/home.nix;
            };
          }
        ];
      };
    };
  };
}
