{ config, lib, pkgs, ... }:
let
  cfg = config.local.k3s;
in
{
  options.local.k3s = {
    enable = lib.mkEnableOption "k3s configuration";
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = toString [
        "--write-kubeconfig-mode" "644"
      ];
    };
    environment = {
      systemPackages = with pkgs; [ 
        k3s
        kubectl
      ];   
      etc."rancher/k3s/registries.yaml".text = ''
        mirrors:
          "localhost:5000":
            endpoint:
              - "http://localhost:5000"
      '';
    };
  };
}
