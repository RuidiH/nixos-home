{ inputs, ... }:
let
  inherit (inputs) nixpkgs;

  mkHost =
    {
      hostModule,
      isGraphical ? true,
      username ? "reedh",
      homeDirectory ? "/home/reedh",
    }:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        hostModule
        inputs.sops-nix.nixosModules.sops
        inputs.aagl.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs isGraphical; };
          home-manager.users.${username} = import ../home {
            inherit isGraphical username homeDirectory;
          };
        }
      ];
    };

  mkDarwin =
    {
      hostModule,
      username,
      homeDirectory,
      isGraphical ? false,
    }:
    inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        hostModule
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs isGraphical; };
          home-manager.users.${username} = import ../home {
            inherit isGraphical username homeDirectory;
          };
        }
      ];
    };
in
{
  # These outputs stay on the original composition path until each host gets
  # its own equivalence-tested migration.
  flake.nixosConfigurations = {
    x1c = mkHost {
      hostModule = ../hosts/x1c;
    };
    ideapad = mkHost {
      hostModule = ../hosts/ideapad;
    };
    wsl = mkHost {
      hostModule = ../hosts/wsl;
    };
  };

  flake.darwinConfigurations.macbook = mkDarwin {
    hostModule = ../hosts/macbook;
    username = "rhuang";
    homeDirectory = "/Users/rhuang";
  };
}
