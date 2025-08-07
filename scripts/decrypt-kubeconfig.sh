#!/usr/bin/env bash
set -euo pipefail

SRC_FILE="${HOME}/nix-config/secrets/kubeconfig.enc.yaml"
DEST_FILE="${HOME}/.kube/config"

# Ensure sops is installed
if ! command -v sops &>/dev/null; then
  echo "❌ sops is not installed. Install it first." >&2
  exit 1
fi

# Ensure the source file exists
if [ ! -f "$SRC_FILE" ]; then
  echo "❌ Encrypted kubeconfig not found at $SRC_FILE" >&2
  exit 1
fi

# Ensure destination directory exists
mkdir -p "$(dirname "$DEST_FILE")"

# Decrypt and write to kubeconfig
sops --decrypt "$SRC_FILE" > "$DEST_FILE"

# Secure the kubeconfig permissions
chmod 600 "$DEST_FILE"

echo "✅ Decrypted kubeconfig written to: $DEST_FILE"

