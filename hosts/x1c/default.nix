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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;  

  networking.hostName = "x1c";

  # Other Hardware Toggles
  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "iwlwifi" ];
  services.fwupd.enable = true; # firmware update daemon

  # enable services
  local.base.enable  = true;
  local.networking.enable = true;
  local.podman.enable = true;
  local.users.enable = true;
  local.desktop.niri.enable = true;
  local.desktop.fonts.enable = true;
  local.services.ssh.enable = true;
  local.services.mihomo.enable = false;

  system.stateVersion = "25.11"; 
}
