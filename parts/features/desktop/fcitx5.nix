{
  flake.modules = {
    nixos.fcitx5 = ./_fcitx5/nixos.nix;
    homeManager.fcitx5 = ./_fcitx5/home.nix;
  };
}
