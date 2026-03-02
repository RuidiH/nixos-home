{ config, lib, pkgs, ... }:
let
  cfg = config.local.networking;
in
{
  options.local.networking = {
    enable = lib.mkEnableOption "networking configuration";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };
}
