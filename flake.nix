{
  description = "Reed's nixos configurations";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };
  outputs = inputs@{ nixpkgs, home-manager, sops-nix, ... }:
    let 
      system = "x86_64-linux";
      mkHost = { hostModule, isGraphical ? true }: nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
	  hostModule
	  sops-nix.nixosModules.sops
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs isGraphical; };
            home-manager.users.reedh = import ./home { inherit isGraphical; };
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
    };
}
