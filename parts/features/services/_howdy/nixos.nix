{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.howdy;
in
{
  options.local.services.howdy = {
    enable = lib.mkEnableOption "Howdy face authentication";
  };

  config = lib.mkIf cfg.enable {
    services.howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        video = {
          device_path = "/dev/video0";
          dark_threshold = 60;
          timeout = 4;
          certainty = 3.5;
        };
        core = {
          detection_notice = true;
          abort_if_lid_closed = true;
          abort_if_ssh = true;
        };
      };
    };

    # IR emitter support (activates the IR LED on the camera)
    services.linux-enable-ir-emitter.enable = true;
  };
}
