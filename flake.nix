# TODO: Instead of including my dotfiles with this repo, try and pull them in from git instead
# Could use a git submodule?
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
            home-manager.extraSpecialArgs = inputs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mou = import ./lily/home.nix;
          }
        ];
      };
    };
  };
}
