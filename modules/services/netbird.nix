{ ... }: {
  environment.persistence."/data/persistent" = {
    # Each tunnel needs to be added here
    directories = [ "/var/lib/netbird" ];
  };

  services.netbird.tunnels = {
    wt0.stateDir = "netbird";
  };
}

