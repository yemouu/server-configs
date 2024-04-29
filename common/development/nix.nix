{ pkgs, ... }:
{
  users.users.mou.packages = with pkgs; [
    age
    nil
    nixpkgs-fmt
    sops
  ];
}

