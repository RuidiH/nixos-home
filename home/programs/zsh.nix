{ osConfig, pkgs, ... }:
let
  isMacbook = osConfig.networking.hostName == "macbook";
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit
      compinit -C
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = if isMacbook then ''
      export GOPATH=/Users/rhuang/go
    '' else ''
      # Linux paths here (if needed)
    '';

    initContent = if isMacbook then ''
      export PATH=$PATH:$(go env GOPATH)/bin
      for asdf_sh in /opt/homebrew/opt/asdf/libexec/asdf.sh /usr/local/opt/asdf/libexec/asdf.sh; do
        if [ -f "$asdf_sh" ]; then
          . "$asdf_sh"
          break
        fi
      done
      unset asdf_sh

      # Local, non-nix-managed overrides (private aliases, work-specific env vars, etc.)
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '' else ''
      # Linux init here (if needed)
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '';
  };
}
