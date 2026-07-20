{ config, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules.homeManager.user-reedh-graphical =
    { lib, osConfig, ... }:
    {
      imports = [
        modules.homeManager.profile-common
        modules.homeManager.profile-graphical
      ];

      home = {
        username = "reedh";
        homeDirectory = "/home/reedh";
        sessionVariables = {
          AWS_PROFILE = "insurgent";
          CLAUDE_CODE_USE_BEDROCK = 1;
        };

        # Noctalia wallpaper configuration (official approach).
        file.".cache/noctalia/wallpapers.json" = lib.mkIf (osConfig.networking.hostName != "jz") {
          text = builtins.toJSON {
            defaultWallpaper = "${../../home/wallpapers/Anby.png}";
          };
        };

        stateVersion = "25.11";
      };
    };
}
