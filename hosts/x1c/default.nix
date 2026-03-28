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
    ../../modules/services/mihomo.nix
    ../../modules/services/ssh.nix
    ../../modules/services/howdy.nix
    ../../modules/desktop/greetd.nix
    ../../modules/users.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;  

  networking.hostName = "x1c";

  # Other Hardware Toggles
  hardware.bluetooth.enable = false;

  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "iwlwifi" ];
  services.fwupd.enable = true; # firmware update daemon

  # Intel 9560 CNVi WiFi stability: CAM mode prevents firmware crashes from
  # power state transitions, bt_coex disables BT radio arbitration
  boot.extraModprobeConfig = ''
    options iwlmvm power_scheme=1
    options iwlwifi bt_coex_active=0
  '';  

  # enable services
  local.base.enable  = true;
  local.networking.enable = true;
  local.podman.enable = true;
  local.users.enable = true;
  local.desktop.niri.enable = true;
  local.desktop.fonts.enable = true;
  local.desktop.fcitx5.enable = true;
  local.services.ssh.enable = true;
  local.services.mihomo.enable = false;
  local.services.howdy.enable = true;
  local.desktop.greetd.enable = true;

  system.stateVersion = "25.11"; 
}
