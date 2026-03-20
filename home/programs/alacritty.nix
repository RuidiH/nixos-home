{ ... }:
let
  escCR = builtins.fromJSON "\"\\u001b\\r\"";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        normal.family = "JetBrainsMono Nerd Font";
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
