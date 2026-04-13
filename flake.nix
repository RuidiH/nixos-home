{
  description = "Reed's nixos configurations";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, sops-nix, aagl, ... }:
    let
      mkHost = { hostModule, isGraphical ? true, username ? "reedh", homeDirectory ? "/home/reedh" }: nixpkgs.lib.nixosSystem {
      	system = "x86_64-linux";
      	specialArgs = { inherit inputs; };
      	modules = [
      	  hostModule
      	  sops-nix.nixosModules.sops
      	  aagl.nixosModules.default
      	  home-manager.nixosModules.home-manager
      	  {
      	    home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
      	    home-manager.extraSpecialArgs = { inherit inputs isGraphical; };
                  home-manager.users.${username} = import ./home { inherit isGraphical username homeDirectory; };
      	  }
      	];
      };
      mkDarwin = { hostModule, username, homeDirectory, isGraphical ? false }: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          hostModule
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs isGraphical; };
            home-manager.users.${username} = import ./home { inherit isGraphical username homeDirectory; };
          }
        ];
      };
    in
    {
      nixosConfigurations.x1c = mkHost {
        hostModule = ./hosts/x1c;
        isGraphical = true;
      };
      nixosConfigurations.ideapad = mkHost {
        hostModule = ./hosts/ideapad;
        isGraphical = true;
      };
      nixosConfigurations.wsl = mkHost {
        hostModule = ./hosts/wsl;
        isGraphical = true;
      };
      nixosConfigurations.jz = mkHost {
        hostModule = ./hosts/jz;
        isGraphical = true;
      };
      darwinConfigurations.macbook = mkDarwin {
        hostModule = ./hosts/macbook;
        username = "rhuang";
        homeDirectory = "/Users/rhuang";
      };
    };
}
