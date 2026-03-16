{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
    ];

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Pane navigation (Alt+h/j/k/l)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Pane splitting (Alt+\ vertical, Alt+- horizontal)
      bind -n M-\\ split-window -h -c "#{pane_current_path}"
      bind -n M-- split-window -v -c "#{pane_current_path}"

      # Close pane (Alt+w)
      bind -n M-w confirm-before -p "kill pane? (y/n)" kill-pane

      # Pane resizing (Alt+Shift+h/j/k/l)
      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5

      # Zoom toggle (Alt+z)
      bind -n M-z resize-pane -Z

      # Direct window switching (Alt+1..5)
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5

      # New/close window (Alt+c / Alt+x)
      bind -n M-c new-window -c "#{pane_current_path}"
      bind -n M-x confirm-before -p "kill window? (y/n)" kill-window

      # Copy mode (Alt+v to enter, vi keys to navigate, v to select, y to yank)
      bind -n M-v copy-mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
