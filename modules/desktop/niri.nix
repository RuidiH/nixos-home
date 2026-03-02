{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.niri;
in
{
  options.local.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager (system-level)";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      adwaita-icon-theme
      cantarell-fonts
    ];

    services.udisks2.enable = true;
  };
}
