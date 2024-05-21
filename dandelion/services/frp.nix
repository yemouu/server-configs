{ config, lib, pkgs, ... }: {
  sops = {
    secrets."frp/token".sopsFile = ../../secrets/dali.yaml;
    templates.frp-token.content = builtins.readFile ((pkgs.formats.toml { }).generate "auth-token.toml" {
      bindPort = 7000;
      transport.tls.force = true;
      vhostHTTPPort = 8008;
      auth = {
        method = "token";
        token = "${config.sops.placeholder."frp/token"}";
      };
      allowPorts = [{ single = 8008; }];
      subDomainHost = "butwho.org";
    });
  };

  services.frp = {
    enable = true;
    role = "server";
  };

  systemd.services.frp.serviceConfig = {
    LoadCredential = "frps.toml:${config.sops.templates.frp-token.path}";
    ExecStart = lib.mkForce "${pkgs.frp}/bin/frps --strict_config -c %d/frps.toml";
  };
}
