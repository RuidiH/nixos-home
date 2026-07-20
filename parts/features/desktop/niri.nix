{
  flake.modules = {
    nixos.niri = ./_niri/nixos.nix;
    homeManager.niri = ./_niri/home.nix;
  };
}
