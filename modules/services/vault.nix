# TODO: in the future switch to OpenBao
{ pkgs, ... }: {
  imports = [ ../unfree.nix ];

  environment.persistence."/data/persistent".directories = [ "/var/lib/vault" ];
  unfree.allowed = [ "vault-bin" ];

  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    storageBackend = "raft";
    extraConfig = ''
      api_addr = "http://127.0.0.1:8200"
      cluster_addr = "http://127.0.0.1:8201"
      disable_mlock = true
      ui = true
    '';
  };
}

