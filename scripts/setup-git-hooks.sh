#!/bin/bash
# Setup git hooks for the nix-config repository

set -e

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
HOOKS_DIR="${REPO_ROOT}/.git/hooks"

echo "${YELLOW}Setting up git hooks...${NC}"

# Create pre-commit hook
cat > "${HOOKS_DIR}/pre-commit" << 'EOF'
#!/bin/sh
# Git pre-commit hook to generate Brewfile from casks.nix

# Colors for output
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Check if casks.nix has been modified
if git diff --cached --name-only | grep -q "modules/darwin/casks.nix"; then
    echo "${YELLOW}🔄 casks.nix modified, regenerating Brewfile...${NC}"
    
    # Run the Brewfile generation script
    if ./scripts/generate-brewfile.sh; then
        echo "${GREEN}✅ Brewfile updated successfully${NC}"
    else
        echo "${RED}❌ Failed to generate Brewfile${NC}"
        exit 1
    fi
else
    echo "${GREEN}✅ No changes to casks.nix, skipping Brewfile generation${NC}"
fi

exit 0
EOF

# Make the hook executable
chmod +x "${HOOKS_DIR}/pre-commit"

echo "${GREEN}✅ Git hooks installed successfully!${NC}"
echo "${YELLOW}📝 Pre-commit hook will now automatically update Brewfile when casks.nix changes${NC}"