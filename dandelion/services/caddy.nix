{ ... }: {
  services.caddy.virtualHosts = {
    "butwho.org".extraConfig = ''
      encode zstd gzip

      header / Content-Type text/html
      respond / <<HTML
        <html lang="en-US">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width">
            <meta name="description" content="ButWho? Me or You?">
            <title>butwho.org</title>
          </head>
          <body>
            <h1>Under construction</h1>
            <p>More to come soon...</p>
            <p>contact@butwho.org</p>
          </body>
        </html>
        HTML 200

      header /.well-known/matrix/* Content-Type application/json
      header /.well-known/matrix/* Access-Control-Allow-Origin *
      respond /.well-known/matrix/server `{"m.server": "matrix.butwho.org:443"}`
      respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.butwho.org"}}`
    '';
    "matrix.butwho.org".extraConfig = ''
      encode zstd gzip
      reverse_proxy /_matrix/* localhost:8008
    '';
  };
}
