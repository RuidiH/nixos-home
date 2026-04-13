{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.file.".aerospace.toml".text = ''
    # AeroSpace tiling window manager
    # Keybindings mirror niri setup (Super → Alt on macOS)

    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    on-focus-changed = ['move-mouse window-lazy-center']

    accordion-padding = 16

    [gaps]
    inner.horizontal = 16
    inner.vertical = 16
    outer.left = 16
    outer.bottom = 16
    outer.top = 16
    outer.right = 16

    [mode.main.binding]

    # Focus (niri: Mod+H/J/K/L)
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    # Move window (niri: Mod+Ctrl+H/J/K/L)
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # Focus monitor (niri: Mod+Shift+H/J/K/L)
    alt-ctrl-h = 'focus-monitor left'
    alt-ctrl-j = 'focus-monitor down'
    alt-ctrl-k = 'focus-monitor up'
    alt-ctrl-l = 'focus-monitor right'

    # Move window to monitor (niri: Mod+Shift+Ctrl+H/J/K/L)
    alt-ctrl-shift-h = ['move-node-to-monitor --wrap-around left', 'focus-monitor left']
    alt-ctrl-shift-j = ['move-node-to-monitor --wrap-around down', 'focus-monitor down']
    alt-ctrl-shift-k = ['move-node-to-monitor --wrap-around up', 'focus-monitor up']
    alt-ctrl-shift-l = ['move-node-to-monitor --wrap-around right', 'focus-monitor right']

    # Workspaces (niri: Mod+1..9)
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'

    # Move to workspace (niri: Mod+Ctrl+1..9)
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'

    # Fullscreen (niri: Mod+F)
    alt-f = 'fullscreen'

    # Layout toggle (niri: Mod+R preset switching)
    alt-comma = 'layout tiles horizontal vertical'
    alt-period = 'layout tiles vertical horizontal'
    alt-w = 'layout accordion horizontal vertical'

    # Resize (niri: Mod+Minus/Equal)
    alt-minus = 'resize smart -50'
    alt-equal = 'resize smart +50'

    # Flatten tree / join (niri: Mod+BracketLeft/Right consume/expel)
    alt-bracketleft = 'join-with left'
    alt-bracketright = 'join-with right'
  '';
}
