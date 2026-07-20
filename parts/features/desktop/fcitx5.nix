{
  flake.modules = {
    nixos.fcitx5 = ../../../modules/desktop/fcitx5.nix;
    homeManager.fcitx5 = ../../../home/programs/fcitx5.nix;
  };
}
