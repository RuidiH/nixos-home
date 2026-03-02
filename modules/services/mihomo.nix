{ config, lib, pkgs, ... }:
let
  cfg = config.local.services.mihomo;
in
{
  options.local.services.mihomo = {
    enable = lib.mkEnableOption "Mihomo proxy service";
  };

  config = lib.mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      configFile = "/etc/mihomo/config.yaml";
      tunMode = true;
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "Mihomo" ];
      checkReversePath = "loose";
    };

    systemd.services.mihomo = {
      serviceConfig.BindReadOnlyPaths = [ "/etc/ssl/certs" ];
      environment = {
        SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
        SSL_CERT_DIR = "/etc/ssl/certs/";
        SAFE_PATHS = "/var/lib/mihomo";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/mihomo 0750 mihomo mihomo - -"
      "d /var/lib/mihomo/proxy_providers 0750 mihomo mihomo - -"
    ];

    environment.systemPackages = [ pkgs.mihomo ];
  };
}
