#!/bin/bash
# Quick setup script to publish MCP Architect to GitHub

set -e

echo "🚀 Publishing MCP Architect to GitHub"
echo "======================================"
echo ""

# Repository details
REPO_NAME="mcp-architect"
GITHUB_USER="joelaugx"
REPO_DIR="/Users/joelaug/.gemini/antigravity/playground/radiant-solstice/skills_library/skills/mcp-architect"

cd "$REPO_DIR"

echo "📋 Repository Status:"
echo "  Location: $REPO_DIR"
echo "  Branch: $(git branch --show-current)"
echo "  Commits: $(git log --oneline | wc -l | tr -d ' ')"
echo ""

# Check if remote already exists
if git remote get-url origin >/dev/null 2>&1; then
    echo "⚠️  Remote 'origin' already exists:"
    git remote get-url origin
    echo ""
    read -p "Remove and re-add? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
    else
        echo "Keeping existing remote"
        exit 0
    fi
fi

echo "🔗 Adding GitHub remote..."
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo "✅ Remote added successfully!"
echo ""

echo "📤 Ready to push to GitHub!"
echo ""
echo "Next steps:"
echo "1. Create the repository on GitHub:"
echo "   https://github.com/new"
echo ""
echo "   Repository name: $REPO_NAME"
echo "   Description: Expert guide for creating, configuring, troubleshooting, and managing MCP servers"
echo "   Visibility: Public"
echo "   ❌ DO NOT initialize with README, .gitignore, or license"
echo ""
echo "2. After creating the repo, run:"
echo "   cd \"$REPO_DIR\""
echo "   git push -u origin main"
echo ""
echo "3. Add topics on GitHub:"
echo "   mcp, model-context-protocol, antigravity, troubleshooting, developer-tools, ai-tools, skill"
echo ""

read -p "Press Enter to open GitHub in browser..." 
open "https://github.com/new"

echo ""
echo "✨ Setup complete! Follow the steps above to finish publishing."
