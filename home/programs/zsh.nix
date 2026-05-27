{ osConfig, pkgs, ... }:
let
  isMacbook = osConfig.networking.hostName == "macbook";
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = if isMacbook then ''
      export GOPATH=/Users/rhuang/go
    '' else ''
      # Linux paths here (if needed)
    '';

    initContent = if isMacbook then ''
      export PATH=$PATH:$(go env GOPATH)/bin
      . "$(brew --prefix asdf)/libexec/asdf.sh"

      # Local, non-nix-managed overrides (private aliases, work-specific env vars, etc.)
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '' else ''
      # Linux init here (if needed)
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '';
  };
}
