{ config, lib, pkgs, ... }:
let
  cfg = config.local.base;
in
{
  options.local.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/Vancouver";
    i18n.defaultLocale = "en_CA.UTF-8";

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      curl
      dig
    ];

    environment.variables.EDITOR = "nvim";

    programs.zsh.enable = true;

    # aws credentials
    sops.secrets.aws_credentials = {
      sopsFile = ../secrets/secrets.yaml;
      owner = "reedh";
      path = "/home/reedh/.aws/credentials";
    };
    
    # github access
    sops.secrets.github_token = {
      sopsFile = ../secrets/secrets.yaml;
    };

    nix.extraOptions = ''
      !include /run/secrets/github_token
    '';
    
    # define sops age key file
    sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  };
}
