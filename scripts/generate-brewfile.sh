#!/bin/bash
# Generate Brewfile from casks.nix
# This script reads the casks.nix file and generates a corresponding Brewfile

set -e

# Colors for output
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CASKS_FILE="${REPO_ROOT}/modules/darwin/casks.nix"
BREWFILE="${REPO_ROOT}/modules/shared/config/Brewfile"

echo -e "${YELLOW}Generating Brewfile from casks.nix...${NC}"

# Check if casks.nix exists
if [[ ! -f "$CASKS_FILE" ]]; then
    echo -e "${RED}Error: casks.nix not found at $CASKS_FILE${NC}"
    exit 1
fi

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$BREWFILE")"

# Generate Brewfile header
cat > "$BREWFILE" << 'EOF'
# Brewfile - Generated automatically from modules/darwin/casks.nix
# DO NOT EDIT MANUALLY - This file is auto-generated
# To modify applications, edit modules/darwin/casks.nix instead

# Taps
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# Casks (GUI Applications)
EOF

# Extract cask names from casks.nix and convert to Brewfile format
# Simple approach: find lines starting with two spaces and a quote
sed -n 's/^  "\([^"]*\)".*/cask "\1"/p' "$CASKS_FILE" | sort >> "$BREWFILE"

# Add newline at end
echo "" >> "$BREWFILE"

echo -e "${GREEN}✅ Brewfile generated successfully!${NC}"
echo -e "${YELLOW}📍 Location: $BREWFILE${NC}"

# Show summary
CASK_COUNT=$(grep -c '^cask ' "$BREWFILE" || echo "0")
echo -e "${YELLOW}📦 Found $CASK_COUNT casks${NC}"

# Add to git if in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    git add "$BREWFILE"
    echo -e "${GREEN}📝 Brewfile added to git staging${NC}"
fi