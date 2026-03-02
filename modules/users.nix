{ config, lib, pkgs, ... }:
let
  cfg = config.local.users;
in
{
  options.local.users = {
    enable = lib.mkEnableOption "user account definitions";
  };

  config = lib.mkIf cfg.enable {
    users.users.reedh = {
      isNormalUser = true;
      description = "reedh";
      group = "reedh";
      extraGroups = [ "networkmanager" "wheel" "podman" ];
      shell = pkgs.zsh;
    };
    users.groups.reedh = {};
  };
}
