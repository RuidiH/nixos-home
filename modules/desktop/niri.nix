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

    # Enable XWayland for X11 application compatibility
    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      adwaita-icon-theme
      cantarell-fonts
      xwayland-satellite  # Required for XWayland integration with Niri
    ];

    services.udisks2.enable = true;
  };
}
