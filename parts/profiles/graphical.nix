{ config, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules = {
    nixos.profile-graphical = {
      imports = [
        modules.nixos.niri
        modules.nixos.fonts
        modules.nixos.fcitx5
        modules.nixos.greetd
      ];

      local.desktop = {
        niri.enable = true;
        fonts.enable = true;
        fcitx5.enable = true;
        greetd.enable = true;
      };
    };

    homeManager.profile-graphical = {
      imports = [
        modules.homeManager.niri
        modules.homeManager.noctalia
        modules.homeManager.fcitx5
      ];
    };
  };
}
