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
    ./programs/yazi.nix
    ./packages.nix
  ] ++ lib.optionals isGraphical [
    ./programs/alacritty.nix
    ./programs/niri.nix
    ./programs/noctalia.nix
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

  home.file."Pictures/Wallpapers/Anby.png".source = ./wallpapers/Anby.png;

  home.stateVersion = "25.11";
}
