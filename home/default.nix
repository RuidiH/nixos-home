{ isGraphical, username ? "reedh", homeDirectory ? "/home/reedh" }:

{ lib, osConfig, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/nixvim.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./packages.nix
    ./programs/alacritty.nix
  ] ++ lib.optionals isGraphical [
    ./programs/niri.nix
    ./programs/noctalia.nix
    ./programs/fcitx5.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.sessionVariables = {
    AWS_PROFILE="insurgent";
    CLAUDE_CODE_USE_BEDROCK=1;
  };

  # Noctalia wallpaper configuration (official approach)
  home.file.".cache/noctalia/wallpapers.json" = lib.mkIf (isGraphical && osConfig.networking.hostName != "jz") {
    text = builtins.toJSON {
      defaultWallpaper = "${./wallpapers/Anby.png}";
    };
  };

  home.stateVersion = "25.11";
}
