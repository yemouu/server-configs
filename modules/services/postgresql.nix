{ lib, ... }: {
  environment.persistence."/data/persistent".directories = [ "/var/lib/postgresql" ];

  services.postgresql = {
    enable = true;
    identMap = ''
      # MapName SystemUser DBUser
      myMap     root       postgres
      myMap     postgres   postgres
      myMap     /^(.*)$    \1
    '';
    authentication = lib.mkOverride 10 ''
      # type database dbUser authMethod optionalIdentMap
      local  sameuser all    peer       map=myMap
    '';
  };
}
