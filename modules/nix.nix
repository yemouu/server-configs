{ pkgs, ... }: {
  systemd = {
    services.nix-daemon.environment.TMPDIR = "/nix/tmp";
    tmpfiles.rules = [ "d /nix/tmp - root root 1d" ];
  };

  # nixos-rebuild is a shellscript and inside that shellscript they create a tmpdir using mktemp.
  # This is fine, but TMPDIR environment variable isn't available at this point, so mktemp puts the
  # directory in the wrong place.
  users.users.mou.packages = [
    (pkgs.symlinkJoin {
      name = "nixos-rebuild-tmpdir";
      paths = [ pkgs.nixos-rebuild ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/nixos-rebuild \
          --set TMPDIR /nix/tmp
      '';
    })
  ];
}
