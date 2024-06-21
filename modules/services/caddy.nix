{ ... }: {
  environment.persistence."/data/persistent".directories = [ "/var/lib/caddy" ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    email = "acme@lilac.pink";
  };
}
