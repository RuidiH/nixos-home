{ config, inputs, ... }:
let
  modules = config.flake.modules;
in
{
  flake.modules.homeManager.host-jz = ./_jz/home.nix;

  flake.modules.nixos.host-jz =
    { pkgs, ... }:
    {
      imports = [
        ./_jz/hardware-configuration.nix

        modules.nixos.profile-workstation
        modules.nixos.nvidia
        modules.nixos.mihomo
        modules.nixos.howdy

        inputs.sops-nix.nixosModules.sops
        inputs.aagl.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
      ];

      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 3;
          };
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        kernelModules = [ "iwlwifi" ];
      };

      networking.hostName = "jz";

      hardware = {
        bluetooth.enable = true;
        enableRedistributableFirmware = true;
      };

      # Disable built-in Realtek Bluetooth (0bda:0852) in favor of USB dongle.
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0852", ATTR{authorized}="0"
      '';
      services.fwupd.enable = true;

      local = {
        hardware.nvidia.enable = true;
        services = {
          mihomo.enable = false;
          howdy.enable = true;
        };
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          isGraphical = true;
        };
        users.reedh.imports = [
          modules.homeManager.user-reedh-graphical
          modules.homeManager.host-jz
        ];
      };

      system.stateVersion = "25.11";
    };

  flake.nixosConfigurations.jz = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [ modules.nixos.host-jz ];
  };
}
