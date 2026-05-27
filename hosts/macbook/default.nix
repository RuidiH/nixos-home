{ pkgs, ... }:
{
  networking.hostName = "macbook";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "rhuang" ];
  };

  users.users.rhuang = {
    home = "/Users/rhuang";
  };

  system.primaryUser = "rhuang";

  nixpkgs.config.allowUnfree = true;

  # direnv's zsh test suite hangs on macOS; not cached for aarch64-darwin
  nixpkgs.overlays = [
    (final: prev: {
      direnv = prev.direnv.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  # Homebrew for GUI apps and casks
  homebrew = {
    enable = true;
    taps = [
      "robusta-dev/homebrew-holmesgpt"
    ];
    brews = [
      "go"
      "cloudflared"
      "robusta-dev/homebrew-holmesgpt/holmesgpt"
    ];
    casks = [
      "docker-desktop"
      "obsidian"
      "firefox"
      "font-jetbrains-mono-nerd-font"
    ];
    onActivation.cleanup = "none";
  };

  # Enable zsh (default macOS shell)
  programs.zsh.enable = true;

  environment.variables.EDITOR = "nvim";

  # macOS system preferences
  system.defaults = {
    dock.autohide = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  system.stateVersion = 6;
}
