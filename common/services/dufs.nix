{ config, lib, pkgs, ... }:
let
  servePath = "/data/dufs";
  dufsConfig = pkgs.writeText "config.yaml" (lib.generators.toYAML { } {
    allow-all = true;
    serve-path = "${servePath}";
  });
  startDufs = pkgs.writeShellScript "dufsStart" ''
    export DUFS_AUTH="mou:$(${pkgs.coreutils}/bin/cat ${config.sops.secrets."dufs/mouPW".path})@/:rw"
    exec ${pkgs.dufs}/bin/dufs -c ${dufsConfig}
  '';
in
{
  sops.secrets."dufs/mouPW".owner = "dufs";

  users = {
    users.dufs = {
      description = "dufs service user";
      isSystemUser = true;
      group = "dufs";
    };
    groups.dufs = { };
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  system.activationScripts.dufsDir.text = ''
    mkdir -p ${servePath}
    chown -R dufs:dufs ${servePath}
    chmod -R 760 ${servePath}
  '';

  systemd.services.dufs = {
    enable = true;
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${startDufs}";
      User = "dufs";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
