{ config, inputs, ... }:
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
      wallpaper.enabled = true;
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

      lockscreen_widgets = { };

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
