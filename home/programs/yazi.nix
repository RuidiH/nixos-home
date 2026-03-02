{ ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        ratio = [1 4 3];
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
        linemode = "size";
        scrolloff = 5;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        { on = ["g" "h"]; run = "cd ~"; desc = "Go home"; }
        { on = ["g" "d"]; run = "cd ~/Downloads"; desc = "Go to Downloads"; }
        { on = ["g" "p"]; run = "cd ~/projects"; desc = "Go to projects"; }
      ];
    };
  };
}
