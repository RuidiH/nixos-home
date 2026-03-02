{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.greetd;
in
{
  options.local.desktop.greetd = {
    enable = lib.mkEnableOption "greetd login greeter";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = builtins.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--time-format '%a %H:%M'"
          # "--greeting 'Welcome back!'"
          "--cmd niri-session"
          "--remember"
          "--remember-session"
          "--asterisks"
          "--window-padding 2"
          "--container-padding 2"
          "--width 40"
        ];
        user = "greeter";
      };
    };
  };
}
