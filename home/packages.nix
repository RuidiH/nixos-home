{ pkgs, lib, isGraphical, ... }:
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
    wl-clipboard
    nerd-fonts.jetbrains-mono

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
    iotop
    iftop

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
    zathura
    poppler-utils

  ] ++ lib.optionals isGraphical [
    # Graphical apps
    firefox
    teams-for-linux
  ];
}
