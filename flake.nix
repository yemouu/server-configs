{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    esquid = {
      url = "github:Things-N-Stuff/eSquid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yemou-dotfiles = {
      url = "git+https://codeberg.org/yemou/dotfiles";
      flake = false;
    };
    yemou-scripts = {
      url = "git+https://codeberg.org/yemou/scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, impermanence, ... }@inputs:
    let genSystemConfigs = nixpkgs.lib.genAttrs [ "dandelion" "fly-agaric" "lily" ]; in {
      nixosConfigurations = genSystemConfigs (hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            impermanence.nixosModules.impermanence
            ./${hostname}/config.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = inputs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mou = import ./${hostname}/home.nix;
              };
            }
          ];
        });
    };
}
