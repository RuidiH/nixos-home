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
      export PATH="$PATH:''${GOPATH:-$HOME/go}/bin"

      # Homebrew: put /opt/homebrew/bin on PATH so the `asdf` binary (and other
      # brew tools) are resolvable. Required by asdf shims, which exec `asdf`.
      for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew" ]; then
          eval "$("$brew" shellenv)"
          break
        fi
      done
      unset brew

      # asdf (Go rewrite, >= 0.16): prepend the shims dir. The `asdf` binary is
      # found via Homebrew above; sourcing asdf.sh only adds the `asdf shell`
      # helper function.
      export PATH="''${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
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
