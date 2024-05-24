{ config, lib, pkgs, ... }: {
  sops = {
    secrets."frp/token".sopsFile = ../../secrets/dali.yaml;
    templates.frpc-toml.content = builtins.readFile ((pkgs.formats.toml { }).generate "frpc.toml" {
      serverAddr = "2a01:4ff:f0:41c7::1";
      serverPort = 7000;
      auth = {
        method = "token";
        token = "${config.sops.placeholder."frp/token"}";
      };
      transport.tls.enable = true;
      proxies = [{
        name = "dendrite";
        type = "http";
        localIP = "::1";
        localPort = 8008;
        customDomains = [ "matrix.butwho.org" ];
        transport = {
          useEncryption = true;
          useCompression = true;
        };
      }];
    });
  };

  services.frp = {
    enable = true;
    role = "client";
  };

  systemd.services.frp = {
    restartTriggers = [ config.sops.templates.frpc-toml.content];
    serviceConfig = {
      LoadCredential = "frpc.toml:${config.sops.templates.frpc-toml.path}";
      ExecStart = lib.mkForce "${pkgs.frp}/bin/frpc --strict_config -c %d/frpc.toml";
    };
  };
}
