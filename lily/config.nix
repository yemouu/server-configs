{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./packages.nix
    ./services/frp.nix
    ../modules/services/dendrite.nix
    # ../modules/services/dufs.nix
    ../modules/services/esquid.nix
    ../modules/services/libvirt.nix
    ../modules/services/netbird.nix
    ../modules/services/openssh.nix
  ];

  sops = {
    defaultSopsFile = ../secrets/lily.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/data/keys.txt";
    secrets = {
      "passwordHashes/root".neededForUsers = true;
      "passwordHashes/mou".neededForUsers = true;
    };
  };

  time.timeZone = "America/New_York";
  networking = {
    hostName = "lily";
    firewall.enable = true;
  };

  services = {
    acpid.enable = true;
    fail2ban.enable = true;
    smartd.enable = true;
    thermald.enable = true;
  };

  security.polkit.enable = true;

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    loginShellInit = ''
      if [ -e /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh ]
      then
          . /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
      fi
    '';
    persistence."/data/persistent" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        { directory = "/var/lib/private"; mode = "0700"; }
      ];
      files = [ "/etc/machine-id" ];
    };
  };

  users = {
    groups.mou.gid = 1000;
    users = {
      root.hashedPasswordFile = config.sops.secrets."passwordHashes/root".path;
      mou = {
        isNormalUser = true;
        group = "mou";
        extraGroups = [ "users" "wheel" ];
        shell = pkgs.loksh;
        hashedPasswordFile = config.sops.secrets."passwordHashes/mou".path;
      };
    };
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older
  # NixOS versions. Most users should NEVER change this value after the initial install, for any
  # reason, even if you've upgraded your system to a new NixOS release. This value does NOT affect
  # the Nixpkgs version your packages and OS are pulled from, so changing it will NOT upgrade your
  # system. This value being lower than the current NixOS release does NOT mean your system is out
  # of date, out of support, or vulnerable. Do NOT change this value unless you have manually
  # inspected all the changes it would make to your configuration, and migrated your data
  # accordingly. For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
