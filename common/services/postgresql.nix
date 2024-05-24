{ ... }: {
  environment.persistence."/data/persistent".directories = [ "/var/lib/postgresql" ];

  # Additional options are set in other files that use postgresql
  services.postgresql.enable = true;
}
