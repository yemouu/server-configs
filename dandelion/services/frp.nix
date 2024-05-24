{ config, lib, pkgs, ... }: {
  sops = {
    secrets."frp/token".sopsFile = ../../secrets/dali.yaml;
    templates.frps-toml.content = builtins.readFile ((pkgs.formats.toml { }).generate "frps.toml" {
      bindPort = 7000;
      transport.tls.force = true;
      vhostHTTPPort = 8008;
      auth = {
        method = "token";
        token = "${config.sops.placeholder."frp/token"}";
      };
      allowPorts = [{ single = 8008; }];
    });
  };

  networking.firewall.allowedTCPPorts = [ 7000 ];

  services.frp = {
    enable = true;
    role = "server";
  };

  systemd.services.frp = {
    restartTriggers = [ config.sops.templates.frps-toml.content ];
    serviceConfig = {
      LoadCredential = "frps.toml:${config.sops.templates.frps-toml.path}";
      ExecStart = lib.mkForce "${pkgs.frp}/bin/frps --strict_config -c %d/frps.toml";
    };
  };
}
