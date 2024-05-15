{ config, esquid, ... }:
{
  imports = [ esquid.nixosModules."x86_64-linux".eSquid ];
  nixpkgs.overlays = [ esquid.overlays.default ];

  sops.secrets."esquid/token".owner = "esquid";

  services.eSquid = {
    enable = true;
    tokenFile = config.sops.secrets."esquid/token".path;
    # defaultGuild = "375409834197123092";
    botAdminIDs = [ "1085405405972279336" ];
  };
}
