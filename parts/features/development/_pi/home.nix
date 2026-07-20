{ inputs, pkgs, ... }:
{
  programs.pi-coding-agent = {
    enable = true;
    package = inputs.nixpkgs-pi.legacyPackages.${pkgs.system}.pi-coding-agent;
  };
}
