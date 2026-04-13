{ pkgs, lib, isGraphical, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # CLI tools
    fastfetch
    nnn
    ripgrep
    jq
    eza
    fzf
    file
    which
    tree

    # Archive tools
    zip
    xz
    unzip
    p7zip

    # Network tools
    dnsutils
    ldns

    # System monitoring
    lsof
    btop

    # Nix tools
    nix-output-monitor

    # Dev tools
    awscli2
    claude-code
    uv
    opentofu
    gnumake
    gh

    # Others
    poppler-utils

  ] ++ lib.optionals isLinux [
    # Linux-only
    wl-clipboard
    nerd-fonts.jetbrains-mono
    iotop
    iftop
    zathura

  ] ++ lib.optionals isGraphical [
    # Graphical apps
    firefox
    teams-for-linux
  ];
}
