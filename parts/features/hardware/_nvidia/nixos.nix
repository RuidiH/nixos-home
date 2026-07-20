{ config, lib, pkgs, ... }:
let
  cfg = config.local.hardware.nvidia;
in
{
  options.local.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA proprietary drivers";
  };

  config = lib.mkIf cfg.enable {
    # Load NVIDIA driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    # Hardware graphics acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # NVIDIA driver configuration
    hardware.nvidia = {
      # Required for Wayland compositors like Niri
      modesetting.enable = true;

      # Power management
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Use production driver for RTX 5070 Ti
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Enable NVIDIA settings GUI
      nvidiaSettings = true;

      # RTX 5070 Ti (50-series Blackwell) REQUIRES open kernel modules
      open = true;

      # PRIME sync mode: Always use NVIDIA for maximum performance
      prime = {
        sync.enable = true;

        # PCI Bus IDs discovered from logs:
        # AMD: 0000:11:00.0 → PCI:17:0:0
        # NVIDIA: 0000:01:00.0 → PCI:1:0:0
        amdgpuBusId = "PCI:17:0:0";   # AMD integrated graphics
        nvidiaBusId = "PCI:1:0:0";    # NVIDIA RTX 5070 Ti
      };
    };

    # Kernel parameters for NVIDIA
    boot.kernelParams = [
      "nvidia-drm.modeset=1"  # Enable DRM kernel mode setting
    ];

    # NVIDIA modules will be available through services.xserver.videoDrivers
    # No need to add them to boot.extraModulePackages which would bloat initrd

    # Wayland environment variables for NVIDIA
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";  # Fixes cursor issues
    };

    # NVIDIA utilities
    environment.systemPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libva-utils
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      mesa-demos
    ];
  };
}
