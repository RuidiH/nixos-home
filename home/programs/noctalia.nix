{ config, inputs, lib, osConfig, ... }:
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

      plugins.enabled = [ "noctalia/bongocat" ];
    
      theme.templates.enable_builtin_templates = true;

      bar.main = {
        position = "top";
        background_opacity = 0.95;
        border = "primary";
        border_width = 1.0;
        capsule = true;
        font_family = "Iosevka NF ExtraBold";
        font_weight = 800;
        thickness = 30;
        start = [ "control-center" "workspaces" "media" "audio_visualizer" ];
        center = [ "bongocat" "cpu" "ram" "keyboard_layout" ];
        end = [ "network" "bluetooth" "battery" "weather" "clock" "date" ];
      };

      widget = {
        control-center = {
          custom_image = "${config.programs.noctalia.package}/share/noctalia/assets/images/distros/nixos.svg";
          custom_image_colorize = false;
        };

        audio_visualizer.mirrored = false;

        sysmon = {
          stat = "cpu_usage";
          display = "text";
          glyph = "cpu-usage";
          show_label = false;
        };

        cpu.show_label = false;

        ram = {
          show_label = false;
          stat = "ram_pct";
        };

        network.show_label = false;

        bluetooth = {
          hide_when_no_connected_device = true;
          show_label = true;
        };

        battery.show_label = true;

        weather.show_condition = false;

        bongocat = {
          type = "noctalia/bongocat:cat";
          # The cat is visible without this, but keyboard tapping needs evtest
          # plus input_devices and permission to read them.
        };

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
      } // (if osConfig.networking.hostName == "jz" then {
        directory = "/home/reedh/Downloads/Wallpapers";
        default.path = "/home/reedh/Downloads/Wallpapers/127396735_p0.png";
        monitors = {
          "DP-3".path = "/home/reedh/Downloads/Wallpapers/127396735_p0.png";
          "HDMI-A-1".path = "/home/reedh/Downloads/Wallpapers/127396735_p0.png";
        };
        automation = {
          enabled = true;
          interval_seconds = 60;
          order = "random";
        };
      } else {
        directory = ../wallpapers;
        default.path = ../wallpapers/Estella.jpg;
      });
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Nord";
      };

      shell = {
        corner_radius_scale = 0.2;
        date_format = "%A, %m/%d/%Y";
        telemetry_enabled = true;
      };

      lockscreen_widgets = lib.optionalAttrs (osConfig.networking.hostName == "jz") {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@DP-3" "lockscreen-login-box@HDMI-A-1" ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "lockscreen-login-box@DP-3" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 1280.0;
            cy = 1321.0;
            output = "DP-3";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_password_hint = true;
            };
          };

          "lockscreen-login-box@HDMI-A-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 540.0;
            cy = 1801.0;
            output = "HDMI-A-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_password_hint = true;
            };
          };
        };
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
