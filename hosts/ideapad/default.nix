{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/podman.nix
    ../../modules/networking.nix
    ../../modules/desktop/niri.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/fcitx5.nix
    ../../modules/desktop/greetd.nix
    ../../modules/services/howdy.nix
    ../../modules/services/mihomo.nix
    ../../modules/services/ssh.nix
    ../../modules/users.nix
    ../../modules/k3s.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;  

  networking.hostName = "ideapad";

  # Other Hardware Toggles
  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true; # firmware update daemon

  # Enable shared modules
  local.base.enable = true;
  local.networking.enable = true;
  local.podman.enable = true;
  local.users.enable = true;
  local.k3s.enable = true;

  local.desktop.niri.enable = true;
  local.desktop.fonts.enable = true;
  local.desktop.fcitx5.enable = true;
  local.desktop.greetd.enable = true;

  local.services.ssh.enable = true;
  local.services.mihomo.enable = false;
  local.services.howdy.enable = true;


  system.stateVersion = "25.11";
}
