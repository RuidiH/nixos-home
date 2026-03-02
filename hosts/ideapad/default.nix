# TODO: Fill in after NixOS is installed on the IdeaPad.
# Mirrors x1c structure — host-specific settings only.
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/podman.nix
    ../../modules/networking.nix
    ../../modules/desktop/niri.nix
    ../../modules/desktop/fonts.nix
    ../../modules/services/mihomo.nix
    ../../modules/services/ssh.nix
    ../../modules/users.nix
  ];

  # TODO: Replace with actual boot/hardware config after NixOS install.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ideapad";

  # Enable shared modules
  local.base.enable = true;
  local.networking.enable = true;
  local.podman.enable = true;
  local.users.enable = true;
  local.desktop.niri.enable = true;
  local.desktop.fonts.enable = true;
  local.services.ssh.enable = true;
  local.services.mihomo.enable = false;

  system.stateVersion = "25.11";
}
