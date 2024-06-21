{ ... }: {
  systemd = {
    services.nix-daemon.environment.TMPDIR = "/nix/tmp";
    tmpfiles.rules = [ "d /nix/tmp - root root 1d" ];
  };
}
