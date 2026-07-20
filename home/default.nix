{ isGraphical, username ? "reedh", homeDirectory ? "/home/reedh" }:

{ lib, osConfig, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/pi.nix
    ./programs/nixvim.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./packages.nix
    ./programs/alacritty.nix
  ] ++ lib.optionals isGraphical [
    ./programs/niri.nix
    ./programs/noctalia.nix
    ./programs/fcitx5.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";
}
