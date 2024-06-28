{ pkgs, yemou-scripts, ... }: {
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
  # nixpkgs.config.permittedInsecurePackages = [ ];

  imports = [
    ../modules/development
    ../modules/editor.nix
  ];

  nixpkgs.overlays = [ yemou-scripts.overlays.default ];

  environment.systemPackages = with pkgs; [
    git
    htop
  ];

  users.users.mou.packages = with pkgs; [
    magic-wormhole-rs
    thm
  ];
}
