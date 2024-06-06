{ config, yemou-dotfiles, ... }: {
  home = {
    username = "mou";
    homeDirectory = "/home/${config.home.username}";
  };

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    configFile = {
      "kak-lsp".source = "${yemou-dotfiles}/config/kak-lsp";
      "kak" = {
        source = "${yemou-dotfiles}/config/kak";
        recursive = true;
      };
      "loksh".source = "${yemou-dotfiles}/config/loksh";
      "thm".source = "${yemou-dotfiles}/config/thm";
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
}
