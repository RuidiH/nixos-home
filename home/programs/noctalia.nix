{ pkgs, inputs, lib, osConfig, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];
  programs.noctalia = {
    enable = true;
    settings = {
      backdrop = {
        enabled = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };

      bar.main = {
        position = "top";
        capsule = false;
        start = [ "control-center" "workspaces" ];
        center = [ "sysmon" ];
        end = [ "network" "bluetooth" "battery" "clock" ];
      };

      widget = {
        control-center = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          custom_image_colorize = false;
        };

        sysmon = {
          stat = "cpu_usage";
          display = "gauge";
          show_label = false;
        };

        network.show_label = true;
        bluetooth.show_label = false;
        battery.show_label = true;

        clock = {
          format = "{:%H:%M}";
          vertical_format = "{:%H %M}";
          font_family = "monospace";
          color = "primary";
        };
      };

      battery.warning_threshold = 20;
      wallpaper = {
        enabled = true;
      } // lib.optionalAttrs (osConfig.networking.hostName == "jz") { 
        directory = "/home/reedh/Downloads/Wallpapers";
        automation = {
          enabled = true;
          interval_seconds = 60;    
          order = "random";
        };
      };
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Nord";
      };

      shell = {
        corner_radius_scale = 0.2;
        date_format = "%A, %m/%d/%Y";
      };

      location.address = "Vancouver, Canada";

      system.monitor = {
        enabled = true;
        cpu_poll_seconds = 3.0;
        memory_poll_seconds = 3.0;
        network_poll_seconds = 3.0;
        disk_poll_seconds = 3.0;
        cpu_usage_activity_threshold = 80;
        cpu_usage_critical_threshold = 90;
        cpu_temp_activity_threshold = 80;
        cpu_temp_critical_threshold = 90;
        ram_pct_activity_threshold = 80;
        ram_pct_critical_threshold = 90;
        disk_pct_activity_threshold = 80;
        disk_pct_critical_threshold = 90;
      };
    };
  };
}
