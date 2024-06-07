{ pkgs, ... }: {
  environment = {
    sessionVariables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };
    systemPackages = with pkgs; [ file kakoune ];
  };

  users.users.mou.packages = with pkgs; [ kak-lsp ];
}
