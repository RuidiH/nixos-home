{ config, lib, pkgs, ... }:
let
  cfg = config.local.gaming;
in
{
  options.local.gaming = {
    enable = lib.mkEnableOption "Gaming configuration with Steam and utilities";
  };

  config = lib.mkIf cfg.enable {
    # Steam with Proton
    programs.steam = {
      enable = true;

      # Gamescope: dedicated gaming compositor for better performance
      gamescopeSession.enable = true;

      # Enable remote play and local network game streaming
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      # Extra compatibility tools
      extraCompatPackages = with pkgs; [
        proton-ge-bin  # GloriousEggroll's Proton with extra patches
      ];
    };

    # GameMode: System optimizations when games are running
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;  # Increase game process priority
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };

    # Gaming utilities
    environment.systemPackages = with pkgs; [
      # Performance monitoring
      mangohud  # FPS overlay and monitoring
      # Use in Steam launch options: mangohud %command%

      # Compatibility tools
      wine
      winetricks

      # Lutris: game launcher for non-Steam games
      lutris

      # Bottles: modern Wine prefix manager
      bottles

      # ProtonUp-Qt: Manage Proton-GE and other compatibility tools
      protonup-qt
    ];

    # Enable 32-bit graphics support for older games
    # (already enabled in nvidia.nix, but included here for completeness)
    hardware.graphics.enable32Bit = true;

    # An Anime Game Launcher for HoYoverse games
    programs.honkers-railway-launcher.enable = true;  # Honkai: Star Rail

    # Uncomment these if you want other HoYoverse games:
    # programs.anime-game-launcher.enable = true;  # Genshin Impact
    # programs.honkers-launcher.enable = true;      # Honkai Impact 3rd
  };
}
