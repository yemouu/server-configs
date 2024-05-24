{ config, ... }: {
  imports = [ ./postgresql.nix ];

  sops = {
    secrets."dendrite/postgresqlPW" = { };
    templates = {
      postgresql-dendrite-pw = ''
        alter user dendrite with password '${config.sops.placeholder."dendrite/postgresqlPW"}';
      '';
      dendrite-env.content = ''
        POSTGRESQL_PW=${config.sops.placeholder."dendrite/postgresqlPW"}
      '';
    };
  };

  environment.persistence."/data/persistent".directories = [{
    directory = "/var/lib/private/dendrite";
    mode = "0700";
  }];

  services.postgresql = {
    initialScript = config.sops.templates.postgresql-dendrite-pw.path;
    ensureDatabases = [ "dendrite" ];
    ensureUsers = [{
      name = "dendrite";
      ensureDBOwnership = true;
    }];
  };

  services.dendrite = {
    enable = true;
    # tlsKey = ;
    # tlsCert = ;
    environmentFile = config.sops.templates.dendrite-env.path;
    settings = {
      global = {
        private_key = "$CREDENTIALS_DIRECTORY/private_key";
        server_name = "butwho.org";
        database.connection_string = "postgresql://dendrite:$POSTGRESQL_PW@localhost/dendrite?sslmode=disable";
        presence = {
          enable_inbound = true;
          enable_outbound = true;
        };
        # dns_cache.enable = true;
      };
      app_service_api.database.connection_string = "";
      client_api = {
        registration_disabled = true;
        guests_disabled = true;
        # registration_shared_secret = "";
        enable_registration_captcha = false; # I need keys for this. Use hcaptcha?
      };
      federation_api.database.connection_string = "";
      media_api = {
        max_file_size_bytes = 52428800;
        dynamic_thumbnails = true;
        database.connection_string = "";
      };
      mscs = {
        mscs = [ "msc2836" ];
        database.connection_string = "";
      };
      sync_api = {
        search.enable = true;
        database.connection_string = "";
      };
      user_api = {
        device_database.connection_string = "";
        account_database.connection_string = "";
      };
      room_server.database.connection_string = "";
      relay_api.database.connection_string = "";
      key_server.database.connection_string = "";
    };
    openRegistration = false;
    loadCredential = [ "private_key:/data/matrix/matrix_key.pem" ];
  };
}
