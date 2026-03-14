{ isGraphical }:

{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/nixvim.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./packages.nix
  ] ++ lib.optionals isGraphical [
    ./programs/alacritty.nix
    ./programs/niri.nix
    ./programs/noctalia.nix
    ./programs/fcitx5.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home.username = "reedh";
  home.homeDirectory = "/home/reedh";
  home.sessionVariables = {
    AWS_PROFILE="insurgent";
    CLAUDE_CODE_USE_BEDROCK=1;
  };

  # Noctalia wallpaper configuration (official approach)
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "${./wallpapers/Anby.png}";
    };
  };

  home.stateVersion = "25.11";
}
