{ config, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules.nixos.profile-workstation = {
    imports = [
      modules.nixos.profile-common
      modules.nixos.profile-graphical
      modules.nixos.podman
      modules.nixos.gaming
    ];

    local = {
      podman.enable = true;
      gaming.enable = true;
    };
  };
}
