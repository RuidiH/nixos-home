{
  flake.modules = {
    nixos.niri = ../../../modules/desktop/niri.nix;
    homeManager.niri = ../../../home/programs/niri.nix;
  };
}
