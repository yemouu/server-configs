{ pkgs, ... }:
{
  environment = {
    sessionVariables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };

    systemPackages = with pkgs; [
      file
      kak-lsp
      kakoune
    ];
  };
}
