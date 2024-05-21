{ ... }: {
  environment.persistence."/data/persistent".directories = [ "/var/lib/caddy" ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    email = "admin@butwho.org";
    virtualHosts."matrix.butwho.org".extraConfig = ''
      encode zstd gzip
      reverse_proxy /_matrix/* localhost:8008
    '';
  };
}
