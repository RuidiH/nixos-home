{ config, lib, pkgs, ... }:
let
  cfg = config.local.desktop.fonts;
in
{
  options.local.desktop.fonts = {
    enable = lib.mkEnableOption "font packages";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
    ];
  };
}
