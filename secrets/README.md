# SSH Key Management with SOPS + Age

This directory contains encrypted SSH private keys managed using [SOPS](https://github.com/mozilla/sops) with [Age](https://github.com/FiloSottile/age) encryption.

## Overview

The SSH private keys are encrypted using SOPS with Age encryption and can be automatically decrypted and deployed to `~/.ssh/` when switching Nix configurations.

## Prerequisites

1. **Age key pair**: You need an Age private key to decrypt the secrets
2. **SOPS**: For managing encrypted secrets

## Files in this directory

- `id_ed25519.enc` - Encrypted SSH private key
- `id_ed25519_personal.enc` - Encrypted personal SSH private key  
- `age-public.txt` - Age public key used for encryption
- `README.md` - This file

## Setup Instructions

### 1. Set up Age private key

Create the Age key directory and save your private key (Google Password Manager):

```bash
mkdir -p ~/.config/sops/age

# Save your Age private key (starts with AGE-SECRET-KEY-1...)
echo "AGE-SECRET-KEY-1..." > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

## Manual Decryption

To manually decrypt and view a secret:

```bash
# Decrypt to stdout
sops -d secrets/id_ed25519.enc

# Decrypt to a file
sops -d secrets/id_ed25519.enc > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
```

## Adding New Secrets

### Encrypt a new SSH key

```bash
# Encrypt an existing SSH key
sops -e /path/to/your/private/key > secrets/new_key.enc
```

## Verification

After deployment, verify your SSH keys are properly decrypted:

```bash
# Check that the key exists and has correct permissions
ls -la ~/.ssh/id_ed25519

# Test the key (should show key fingerprint)
ssh-keygen -l -f ~/.ssh/id_ed25519

# Test SSH connection (replace with your server)
ssh -i ~/.ssh/id_ed25519 user@your-server.com
```

## Security Notes

1. **Private key protection**: Your Age private key (`~/.config/sops/age/keys.txt`) is the master key - keep it secure
2. **File permissions**: SSH keys should have `600` permissions (owner read/write only)
3. **Backup**: Keep a secure backup of your Age private key
4. **Rotation**: Regularly rotate SSH keys and Age keys as needed

## References

- [SOPS Documentation](https://github.com/mozilla/sops)
- [Age Documentation](https://github.com/FiloSottile/age)
- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
