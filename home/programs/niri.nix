{ config, pkgs, inputs, lib, ... }:
let
  noctalia = cmd: [ "noctalia-shell" "ipc" "call" ] ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [ inputs.niri.homeModules.config ];
  programs.niri = {
    package = pkgs.niri;
    settings = {

      # Input
      input = {
        keyboard = {
          numlock = true;
          xkb = { };
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
        };

        mouse = { };
        trackpoint = { };
      };

      # Output (Monitor) configuration
      # Note: This file is shared across all hosts. Niri safely ignores
      # configurations for outputs that don't exist on the current machine.
      outputs = {
        # jz: MSI G271CQR 165Hz gaming monitor on DP-3
        "DP-3" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 165.0;   # Using maximum supported refresh rate
          };
          position = { x = 0; y = 0; };
        };

        # Add configurations for other hosts' monitors here as needed
        # Other machines will safely ignore non-existent outputs
      };

      # Layout
      layout = {
        gaps = 16;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = { proportion = 0.5; };

        focus-ring = {
          enable = true;
          width = 4;
          active.color = "#7fc8ff";
          inactive.color = "#505050";
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#ffc87f";
          inactive.color = "#505050";
          urgent.color = "#9b0000";
        };

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
          color = "#0007";
        };

        background-color = "transparent";
      };

      # Animations
      animations = {
        window-open = {
          kind.spring = {
            damping-ratio = 0.6;
            stiffness = 600;
            epsilon = 0.001;
          };
          custom-shader = ''
            vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_progress;
                float y_offset = (1.0 - p) * 0.3;
                vec3 moved_coords = vec3(coords_geo.x, coords_geo.y + y_offset, 1.0);
                vec3 coords_tex = niri_geo_to_tex * moved_coords;
                vec4 color = texture2D(niri_tex, coords_tex.st);
                if (coords_geo.y < 0.0 || coords_geo.y > 1.0 || coords_geo.x < 0.0 || coords_geo.x > 1.0) {
                    color = vec4(0.0);
                }
                return color * niri_clamped_progress;
            }
          '';
        };

        window-close = {
          kind.easing = {
            duration-ms = 1000;
            curve = "linear";
          };
          custom-shader = ''
            float rand(vec2 co){
                return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
            }
            vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                float noise = rand(coords_geo.xy * 30.0);
                if (noise < (p * 1.5 - (1.0 - coords_geo.y) * 0.2)) {
                    return vec4(0.0);
                }
                float drop_p = max(0.0, p - 0.2) / 0.8;
                float gravity = pow(drop_p, 3.0) * 4.0;
                float spread = (noise - 0.5) * gravity * 0.1;
                vec3 moved_coords = vec3(coords_geo.x + spread, coords_geo.y - gravity, 1.0);
                vec3 coords_tex = niri_geo_to_tex * moved_coords;
                vec4 color = texture2D(niri_tex, coords_tex.st);
                if (moved_coords.y < 0.0 || moved_coords.y > 1.0 || moved_coords.x < 0.0 || moved_coords.x > 1.0) {
                    return vec4(0.0);
                }
                return color * (1.0 - p);
            }
          '';
        };

        window-resize = {
          kind.spring = {
            damping-ratio = 0.7;
            stiffness = 800;
            epsilon = 0.0001;
          };
          custom-shader = ''
            vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
                vec4 color = texture2D(niri_tex_next, coords_tex_next.st);
                return color;
            }
          '';
        };

        window-movement.kind.spring = {
          damping-ratio = 0.7;
          stiffness = 800;
          epsilon = 0.00001;
        };

        horizontal-view-movement.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 600;
          epsilon = 0.00001;
        };

        workspace-switch.kind.spring = {
          damping-ratio = 0.7;
          stiffness = 600;
          epsilon = 0.0001;
        };
      };

      # Rounded corners + clip window contents to geometry.
      prefer-no-csd = true;
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 20.0;
            top-right = 20.0;
            bottom-left = 20.0;
            bottom-right = 20.0;
          };
          clip-to-geometry = true;
        }
      ];

      # Wallpaper
      layer-rules = [
        {
          matches = [ { namespace = "^noctalia-wallpaper*"; } ];
          place-within-backdrop = true;
        }
      ];
      overview.workspace-shadow.enable = false;

      spawn-at-startup = [
        {
          command = [
            "noctalia-shell"
          ];
        }
        {
          command = [
            "fcitx5"
            "-d"
          ];
        }
      ];

      environment."NIXOS_OZONE_WL" = "1";

      binds = with config.lib.niri.actions; {

        # Hotkey overlay
        "Mod+Shift+Slash".action.show-hotkey-overlay = [];

        # Terminal
        "Mod+T".action.spawn = "alacritty";
        "Mod+T".hotkey-overlay.title = "Open a Terminal: alacritty";

        # Noctalia core UI
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+S".action.spawn     = noctalia "controlCenter toggle";
        "Mod+Ctrl+Comma".action.spawn = noctalia "settings toggle";

        # Session menu / lock
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";
        "Super+Alt+L".action.spawn = noctalia "lockScreen lock";
        "Super+Alt+L".allow-when-locked = true;

        # Audio
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioRaiseVolume".allow-when-locked = true;

        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioLowerVolume".allow-when-locked = true;

        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        "XF86AudioMute".allow-when-locked = true;

        "XF86AudioMicMute".action.spawn = noctalia "volume muteInput";
        "XF86AudioMicMute".allow-when-locked = true;

        # Media
        "XF86AudioPlay".action.spawn = noctalia "media playPause";
        "XF86AudioPlay".allow-when-locked = true;

        "XF86AudioStop".action.spawn = noctalia "media pause";
        "XF86AudioStop".allow-when-locked = true;

        "XF86AudioPrev".action.spawn = noctalia "media previous";
        "XF86AudioPrev".allow-when-locked = true;

        "XF86AudioNext".action.spawn = noctalia "media next";
        "XF86AudioNext".allow-when-locked = true;

        # Brightness
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
        "XF86MonBrightnessUp".allow-when-locked = true;

        "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
        "XF86MonBrightnessDown".allow-when-locked = true;

        # Window management
        "Mod+O" = {
          action.toggle-overview = [];
          repeat = false;
        };

        "Mod+Q".action.close-window = [];
        "Mod+Q".repeat = false;

        "Mod+Left".action.focus-column-left = [];
        "Mod+Down".action.focus-window-down = [];
        "Mod+Up".action.focus-window-up = [];
        "Mod+Right".action.focus-column-right = [];

        "Mod+H".action.focus-column-left = [];
        "Mod+J".action.focus-window-or-workspace-down = [];
        "Mod+K".action.focus-window-or-workspace-up = [];
        "Mod+L".action.focus-column-right = [];

        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Down".action.move-window-down = [];
        "Mod+Ctrl+Up".action.move-window-up = [];
        "Mod+Ctrl+Right".action.move-column-right = [];

        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+J".action.move-window-down = [];
        "Mod+Ctrl+K".action.move-window-up = [];
        "Mod+Ctrl+L".action.move-column-right = [];

        "Mod+Home".action.focus-column-first = [];
        "Mod+End".action.focus-column-last = [];
        "Mod+Ctrl+Home".action.move-column-to-first = [];
        "Mod+Ctrl+End".action.move-column-to-last = [];

        "Mod+Shift+Left".action.focus-monitor-left = [];
        "Mod+Shift+Down".action.focus-monitor-down = [];
        "Mod+Shift+Up".action.focus-monitor-up = [];
        "Mod+Shift+Right".action.focus-monitor-right = [];

        "Mod+Shift+H".action.focus-monitor-left = [];
        "Mod+Shift+J".action.focus-monitor-down = [];
        "Mod+Shift+K".action.focus-monitor-up = [];
        "Mod+Shift+L".action.focus-monitor-right = [];

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];

        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [];

        "Mod+Page_Down".action.focus-workspace-down = [];
        "Mod+Page_Up".action.focus-workspace-up = [];
        "Mod+U".action.focus-workspace-down = [];
        "Mod+I".action.focus-workspace-up = [];

        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
        "Mod+Ctrl+U".action.move-column-to-workspace-down = [];
        "Mod+Ctrl+I".action.move-column-to-workspace-up = [];

        "Mod+WheelScrollDown".action.focus-workspace-down = [];
        "Mod+WheelScrollDown".cooldown-ms = 150;

        "Mod+WheelScrollUp".action.focus-workspace-up = [];
        "Mod+WheelScrollUp".cooldown-ms = 150;

        "Mod+Ctrl+WheelScrollDown".action.move-column-to-workspace-down = [];
        "Mod+Ctrl+WheelScrollDown".cooldown-ms = 150;

        "Mod+Ctrl+WheelScrollUp".action.move-column-to-workspace-up = [];
        "Mod+Ctrl+WheelScrollUp".cooldown-ms = 150;

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Comma".action.consume-or-expel-window-left = [];
        "Mod+Period".action.consume-or-expel-window-right = [];

        "Mod+BracketLeft".action.consume-window-into-column = [];
        "Mod+BracketRight".action.expel-window-from-column = [];

        "Mod+R".action.switch-preset-column-width = [];
        "Mod+Shift+R".action.switch-preset-window-height = [];
        "Mod+Ctrl+R".action.reset-window-height = [];

        "Mod+F".action.maximize-column = [];
        "Mod+Shift+F".action.fullscreen-window = [];

        "Mod+C".action.center-column = [];
        "Mod+Shift+C".action.center-visible-columns = [];

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+V".action.toggle-window-floating = [];
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

        "Mod+W".action.toggle-column-tabbed-display = [];

        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = [];
        "Mod+Escape".allow-inhibiting = false;

        "Print".action.screenshot = [];
        "Ctrl+Print".action.screenshot-screen = [];
        "Alt+Print".action.screenshot-window = [];

        "Mod+Shift+E".action.quit = [];
        "Ctrl+Alt+Delete".action.quit = [];
      };
    };
  };
}
