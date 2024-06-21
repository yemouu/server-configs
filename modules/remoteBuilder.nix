{ pkgs, ... }: {
  users = {
    groups.nixremote = { };
    users.nixremote = {
      createHome = true;
      group = "nixremote";
      home = "/home/nixremote";
      homeMode = "550";
      isSystemUser = true;
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuJaCiwaXH6O7WDSmDsj1jRBzw+CJkRi1lBcdn7sON1 nixremote"
      ];
    };
  };

  nix.settings.trusted-users = [ "nixremote" ];
}
