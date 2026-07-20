{ config, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules.homeManager.user-reedh-graphical = {
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

      stateVersion = "25.11";
    };
  };
}
