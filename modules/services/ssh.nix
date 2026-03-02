{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.ssh;
in
{
  options.local.services.ssh = {
    enable = lib.mkEnableOption "SSH agent configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh.startAgent = true;
    services.gnome.gcr-ssh-agent.enable = false;
   
    sops.secrets.ssh_private_key = {
      sopsFile = ../../secrets/secrets.yaml;
      owner = "reedh";
      path = "/home/reedh/.ssh/id_ed25519";
    };
  };
}
