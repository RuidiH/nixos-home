# jz dendritic migration baseline

Baseline Git revision: `0f2825f5874310b92ccb112c3e80a0f981bdb669`

Captured before introducing flake-parts or deferred modules:

```text
NixOS derivation:
/nix/store/yil1ax6q6dvl891lsyk9g1bzp658nqal-nixos-system-jz-26.05.20260427.1c3fe55.drv

NixOS output:
/nix/store/jssgph4gqi1a9ch4s64kkvp0nlr97ngc-nixos-system-jz-26.05.20260427.1c3fe55

Home Manager derivation:
/nix/store/a3vyxwhcn71ivf1i703c0jl95w467xf9-home-manager-generation.drv

Niri finalConfig SHA-256:
18dfc867b65d78a06e5e8c6f93b424b3f29bf072bb9fa4a9ef59c856767eefaf

Noctalia config SHA-256:
e4b40b12138f1001114409fc9d11f8872840016438b79ffb64bffdc771099ae5
```

Run `scripts/check-jz-equivalence` after each migration checkpoint. An
identical NixOS output path is the primary success criterion. When deferred
module nesting changes ordered list merges, the script also verifies the Home
Manager derivation, system package multiset, normalized closure members, Niri
KDL, and Noctalia TOML.

## Checkpoints

### 1. flake-parts host wrapper

`jz` was moved behind `flake.modules.nixos.host-jz` without decomposing its
implementation. Its NixOS output, Home Manager output, Niri KDL, and Noctalia
TOML were all byte-for-byte/store-path identical to the baseline.

### 2. Named NixOS features

The modules imported by `jz` are now registered as named deferred NixOS
modules and selected by `parts/hosts/jz.nix`. Home Manager and the generated
Niri/Noctalia files remain exact. The top-level NixOS derivation changes only
because the extra deferred-module import layer moves AAGL's package within the
ordered `environment.systemPackages` list. The package multiset and normalized
closure members remain identical; `nix-diff` traces the changed generated
system paths back to that ordering difference.

The untouched `x1c`, `ideapad`, `wsl`, and `macbook` derivation paths remain
exactly identical to the baseline after moving their output wiring into
`parts/legacy-configurations.nix`.

### 3. Home Manager features and profiles

The former `home/default.nix` import list is represented by named Home Manager
feature modules. `profile-common` composes the shared shell/development modules,
`profile-graphical` composes Niri, Noctalia, and fcitx5, and
`user-reedh-graphical` supplies user identity and imports both profiles.

The Home Manager derivation now differs because deferred-module nesting
reorders `home.packages`; `nix-diff` traces the change to that ordering. The
Home Manager package multiset, normalized system closure, Niri KDL, and
Noctalia TOML remain identical to the baseline.

### 4. Profile-based NixOS composition

`jz` now imports `profile-workstation` rather than enumerating its common and
graphical features itself. The host leaf is limited to hardware configuration,
NVIDIA, Howdy, host-specific boot/hardware settings, and Home Manager wiring.
The equivalence checks continue to pass with identical package multisets and
normalized closure membership.

### 5. Desktop implementation locality

The Niri, fcitx5, Noctalia, Alacritty, fonts, and greetd implementations now
live beside their registration leaves under `parts/features/desktop/`. Hidden
underscore-prefixed implementation directories keep `import-tree` from treating
NixOS/Home Manager implementation files as flake-parts modules. Compatibility
modules remain at the old `modules/desktop/` and `home/programs/` paths for
hosts that still use the legacy composition.

This relocation does not introduce any additional derivation change for `jz`,
and the legacy `x1c` derivation remains exactly equal to the baseline.

### 6. Shared feature implementation locality

The core, package, container, gaming, hardware, service, development, and shell
implementations now live beside their registration leaves under
`parts/features/`. The previous files in `modules/` and `home/` are temporary
compatibility imports for unmigrated hosts. Relative SOPS file references in
base and SSH were adjusted to continue pointing at the same encrypted source.

The complete `jz` equivalence suite passes without any additional derivation
change. The `x1c`, `ideapad`, `wsl`, and `macbook` derivations all remain exactly
identical to the baseline.
