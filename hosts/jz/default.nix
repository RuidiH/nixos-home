{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/podman.nix
    ../../modules/networking.nix
    ../../modules/gaming.nix
    ../../modules/hardware/nvidia.nix
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

  networking.hostName = "jz";

  # Other Hardware Toggles
  hardware.bluetooth.enable = true;

  # Disable built-in Realtek Bluetooth (0bda:0852) in favor of USB dongle
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0852", ATTR{authorized}="0"
  '';

  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "iwlwifi" ];
  services.fwupd.enable = true; # firmware update daemon

  # enable services
  local.base.enable  = true;
  local.networking.enable = true;
  local.podman.enable = true;
  local.gaming.enable = true;
  local.users.enable = true;
  local.hardware.nvidia.enable = true;
  local.desktop.niri.enable = true;
  local.desktop.fonts.enable = true;
  local.desktop.fcitx5.enable = true;
  local.services.ssh.enable = true;
  local.services.mihomo.enable = false;
  local.services.howdy.enable = true;
  local.desktop.greetd.enable = true;

  system.stateVersion = "25.11"; 
}
