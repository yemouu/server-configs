{ ... }: {
  environment.persistence."/data/persistent".directories = [ "/var/lib/fail2ban" ];

  services.fail2ban = {
    enable = true;
    bantime = "12h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * (2 ** ban.Count)";
      overalljails = true;
      rndtime = "1h";
    };
    ignoreIP = [
      # NetBird IPs
      "100.77.87.147" # lutea
    ];
    maxretry = 1;
  };
}
