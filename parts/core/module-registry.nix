{ inputs, ... }:
{
  # flake.modules stores modules now and evaluates them later in the module
  # system selected by their class (nixos, homeManager, darwin, ...).
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
