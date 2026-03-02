{ pkgs, lib, isGraphical, ... }:
{
  home.packages = with pkgs; [
    # CLI tools
    neofetch
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
  ] ++ lib.optionals isGraphical [
    # Graphical apps
    firefox
    teams-for-linux
  ];
}
