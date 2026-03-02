{ isGraphical }:

{ config, lib, pkgs, ... }:
{
  imports = [
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

  home.username = "reedh";
  home.homeDirectory = "/home/reedh";
  home.stateVersion = "25.11";  
}
