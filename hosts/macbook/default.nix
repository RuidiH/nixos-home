{ pkgs, ... }:
{
  networking.hostName = "macbook";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "rhuang" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Homebrew for GUI apps and casks
  homebrew = {
    enable = true;
    casks = [
      "docker"
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
