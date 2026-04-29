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
    '' else ''
      # Linux init here (if needed)
    '';

    shellAliases = if isMacbook then {
      usdev5 = "tsh kube login us-dev-5";
      env5pop = "tsh kube login tdpops-dev-5-va-1";
    } else {
      # Linux aliases here (if needed)
    };
  };
}
