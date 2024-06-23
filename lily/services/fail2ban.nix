{ ... }: {
  # Since this server is on my local network, I'm also ignoring my local ip
  services.fail2ban.ignoreIP = [ "192.168.86.38" ];
}
