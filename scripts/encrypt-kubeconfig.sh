#!/usr/bin/env bash
set -euo pipefail

SRC_KUBECONFIG="${HOME}/.kube/config"
DEST_DIR="${HOME}/nix-config/secrets"
DEST_FILE="${DEST_DIR}/kubeconfig.enc.yaml"

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Copy kubeconfig to destination with .yaml extension
cp "$SRC_KUBECONFIG" "$DEST_FILE"

# Encrypt it in-place as YAML
sops --encrypt --in-place "$DEST_FILE"

echo "✅ kubeconfig encrypted and saved to: $DEST_FILE"
