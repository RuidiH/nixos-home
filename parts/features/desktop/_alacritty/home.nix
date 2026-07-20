{ ... }:
let
  escCR = builtins.fromJSON "\"\\u001b\\r\"";
in
{
  programs.alacritty = {
    enable = true;
    theme = "nord";
    settings = {
      env.TERM = "xterm-256color";
      window = {
        padding = {
          x = 0;
          y = 0;
        };
        # dynamic_padding = false;
        resize_increments = true;
        option_as_alt = "Both";
      };
      font = {
        size = 16;
        # normal.family = "JetBrainsMono Nerd Font";
        normal.family = "Iosevka Nerd Font";
      };

      keyboard.bindings = [
        {
          key = "Enter";
          mods = "Shift";
          chars = escCR;
        }
      ];
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
}
