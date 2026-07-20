{ config, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules = {
    nixos.profile-common = {
      imports = [
        modules.nixos.base
        modules.nixos.networking
        modules.nixos.users
        modules.nixos.ssh
      ];

      local = {
        base.enable = true;
        networking.enable = true;
        users.enable = true;
        services.ssh.enable = true;
      };
    };

    homeManager.profile-common = {
      imports = [
        modules.homeManager.git
        modules.homeManager.zsh
        modules.homeManager.starship
        modules.homeManager.direnv
        modules.homeManager.pi
        modules.homeManager.nixvim
        modules.homeManager.tmux
        modules.homeManager.yazi
        modules.homeManager.packages
        modules.homeManager.alacritty
      ];
    };
  };
}
