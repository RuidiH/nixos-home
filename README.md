# nixos-home

Unified NixOS configuration for multiple machines.

## Hosts

- `x1c` — ThinkPad X1 Carbon Gen 7
- `ideapad` — Lenovo IdeaPad (placeholder)

## Usage

### Build (without activating)

```bash
nixos-rebuild build --flake ~/projects/nixos-home#x1c
```

### Switch (build and activate)

```bash
sudo nixos-rebuild switch --flake ~/projects/nixos-home#x1c
```

Log out and back in for user-level changes (niri, noctalia, shell) to take effect.

### Update flake inputs

```bash
cd ~/projects/nixos-home

# Update all inputs
nix flake update

# Update a single input
nix flake update nixpkgs
```

Then rebuild to apply.

### Tmux

Start a new session or reattach:

```bash
tmux new -s work    # new session
tmux a              # reattach
```

#### Keybindings

All tmux operations use `Alt` as the modifier (no prefix key needed):

| Key | Action |
|-----|--------|
| `Alt+h/j/k/l` | Navigate panes |
| `Alt+Shift+h/j/k/l` | Resize panes |
| `Alt+p` | Split pane vertically |
| `Alt+o` | Split pane horizontally |
| `Alt+w` | Close pane |
| `Alt+z` | Toggle pane zoom (fullscreen/split) |
| `Alt+c` | New window |
| `Alt+x` | Close window |
| `Alt+1..5` | Switch to window 1-5 |
| `Alt+v` | Enter copy mode |

#### Copy mode

1. `Alt+v` to enter copy mode
2. Navigate with vi keys (`h/j/k/l`, `/` to search)
3. `v` to start selection
4. `y` to yank to system clipboard
5. Paste with `Ctrl+Shift+v` (terminal) or `p` (nvim)

### Secrets (sops-nix)

Secrets are encrypted in `secrets/secrets.yaml` using age keys derived from each machine's SSH host key.

```bash
cd ~/projects/nixos-home

# Edit secrets (decrypts in editor, re-encrypts on save)
sops secrets/secrets.yaml

# Or without sops installed globally
sudo nix-shell -p sops --run 'sops secrets/secrets.yaml'
```

#### New machine setup

1. Generate host SSH key (if missing):
   ```bash
   sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
   ```

2. Derive age public key and add to `.sops.yaml`:
   ```bash
   nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
   ```

3. Derive age private key and store locally:
   ```bash
   sudo mkdir -p /root/.config/sops/age
   sudo sh -c "nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key' > /root/.config/sops/age/keys.txt"
   ```

4. Re-encrypt secrets so the new machine can decrypt:
   ```bash
   sudo nix-shell -p sops --run 'sops updatekeys secrets/secrets.yaml'
   ```
