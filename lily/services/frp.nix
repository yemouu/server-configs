{ config, lib, pkgs, ... }: {
  sops = {
    secrets."frp/token".sopsFile = ../../secrets/dali.yaml;
    templates.frpc-toml.content = builtins.readFile ((pkgs.formats.toml { }).generate "frpc.toml" {
      serverAddr = "2a01:4f8:c0c:580d::1";
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
        subdomain = "matrix";
        # This causes an error for some reason?
        # remotePort = 443;
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

  systemd.services.frp.serviceConfig = {
    LoadCredential = "frpc.toml:${config.sops.templates.frpc-toml.path}";
    ExecStart = lib.mkForce "${pkgs.frp}/bin/frpc --strict_config -c %d/frpc.toml";
  };
}
