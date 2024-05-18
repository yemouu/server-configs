# TODO: put this into common?
{ config, ... }: {
  home.username = "mou";
  home.homeDirectory = "/home/${config.home.username}";

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    configFile = {
      "kak" = {
        source = config.lib.file.mkOutOfStoreSymlink "/config/data/configs/kak";
        recursive = true;
      };
      "kak-lsp".source = config.lib.file.mkOutOfStoreSymlink "/config/data/configs/kak-lsp";
      "loksh".source = config.lib.file.mkOutOfStoreSymlink "/config/data/configs/loksh";
      "thm".source = config.lib.file.mkOutOfStoreSymlink "/config/data/configs/thm";
    };
  };

  home.sessionVariables = {
    ENV = "${config.xdg.configHome}/loksh/rc";
    HISTCONTROL = "ignoredups:ignorespace";
    HISTFILE = "${config.xdg.cacheHome}/loksh_history";
  };

  programs = {
    git = {
      enable = true;
      userEmail = "dev@lilac.pink";
      userName = "yemou";
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };

  home.stateVersion = "24.05";
}
