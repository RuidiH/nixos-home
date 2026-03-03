{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.fcitx5;
in
{
  options.local.desktop.fcitx5 = {
    enable = lib.mkEnableOption "fcitx5 input method framework";
  };

  config = lib.mkIf cfg.enable {
    # Enable fcitx5 input method
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          qt6Packages.fcitx5-chinese-addons
          qt6Packages.fcitx5-configtool
        ];
      };
    };

    # For Wayland: use native input method protocol instead of GTK/Qt modules
    # This provides better integration with Wayland compositors like niri
    environment.variables = {
      # Unset GTK_IM_MODULE to use Wayland's text-input protocol
      GTK_IM_MODULE = lib.mkForce "";
      # QT can use wayland input method
      QT_IM_MODULE = lib.mkForce "wayland";
      # Keep XMODIFIERS for legacy X11 apps
      XMODIFIERS = lib.mkForce "@im=fcitx";
    };
  };
}
