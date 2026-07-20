{ config, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      checks =
        if system == "x86_64-linux" then
          {
            jz-system = config.flake.nixosConfigurations.jz.config.system.build.toplevel;
            jz-home =
              config.flake.nixosConfigurations.jz.config.home-manager.users.reedh.home.activationPackage;
          }
        else
          { };
    };
}
