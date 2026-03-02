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

### Secrets (sops-nix)

Secrets are encrypted in `secrets/secrets.yaml` using age keys derived from each machine's SSH host key.

```bash
cd ~/projects/nixos-home

# Edit secrets (decrypts in editor, re-encrypts on save)
sops secrets/secrets.yaml

# Or without sops installed globally
nix-shell -p sops --run 'sops secrets/secrets.yaml'
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
   sops updatekeys secrets/secrets.yaml
   ```
