{
  programs = {
    niri.settings.outputs = {
      # Portrait Dell on the left, MSI on the right at 165 Hz.
      "Dell Inc. DELL P2417H KH0NG93F1KYB" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        scale = 1.0;
        position = {
          x = 0;
          y = 0;
        };
        transform.rotation = 90;
      };

      "Microstep MSI G271CQR CC3H212200308" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 165.0;
        };
        scale = 1.0;
        position = {
          x = 1080;
          y = 0;
        };
      };
    };

    noctalia.settings = {
      wallpaper = {
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
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@DP-3"
          "lockscreen-login-box@HDMI-A-1"
        ];

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
    };
  };
}
