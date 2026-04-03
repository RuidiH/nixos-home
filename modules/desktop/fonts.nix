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
      noto-fonts-cjk-sans  # Chinese/Japanese/Korean fonts
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    # Font configuration for better CJK rendering
    fonts.fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
