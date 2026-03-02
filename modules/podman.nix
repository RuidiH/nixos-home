{ config, lib, pkgs, ...}:
let
  cfg = config.local.podman;
in
{
  options.local.podman = {
    enable = lib.mkEnableOption "Podman container runtime";
  };
  
  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      # "docker" command -> podman (handy for many scripts)
      dockerCompat = true;
      # Needed so containers can resolve each other by name on the default network
      defaultNetwork.settings.dns_enabled = true;
      # Optional but useful if you want Docker tools to find Podman at /var/run/docker.sock
      dockerSocket.enable = true;
    }; 

    environment.systemPackages = with pkgs; [ 
      podman 
      docker-compose 
      podman-tui 
      dive 
    ];   
  };
}
