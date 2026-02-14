#!/bin/bash
# MCP Diagnostic Script
# Tests MCP configuration and provides detailed diagnostics

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 MCP Diagnostic Tool"
echo "====================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to test MCP configuration
test_mcp_config() {
    local config_file="$1"
    
    echo "📋 Testing configuration: $config_file"
    
    # Check if file exists
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Configuration file not found${NC}"
        return 1
    fi
    
    # Validate JSON
    if ! jq empty "$config_file" 2>/dev/null; then
        echo -e "${RED}❌ Invalid JSON${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Valid JSON configuration${NC}"
    
    # List MCPs
    echo ""
    echo "📦 Configured MCPs:"
    jq -r '.mcpServers | keys[]' "$config_file" 2>/dev/null || jq -r 'keys[]' "$config_file"
}

# Function to test individual MCP
test_mcp() {
    local mcp_name="$1"
    local config_file="$2"
    
    echo ""
    echo "🧪 Testing MCP: $mcp_name"
    echo "---"
    
    # Extract command and args
    local command=$(jq -r ".mcpServers[\"$mcp_name\"].command // .\"$mcp_name\".command" "$config_file")
    local args=$(jq -r ".mcpServers[\"$mcp_name\"].args // .\"$mcp_name\".args" "$config_file")
    
    # Check if command exists
    if [ ! -f "$command" ] && ! command_exists "$command"; then
        echo -e "${RED}❌ Command not found: $command${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Command exists: $command${NC}"
    
    # Check if it's a Python script
    if [[ "$command" == *"python"* ]]; then
        local script=$(echo "$args" | jq -r '.[0]')
        if [ -f "$script" ]; then
            echo -e "${GREEN}✅ Python script exists: $script${NC}"
            
            # Check if venv is used
            if [[ "$command" == *"venv"* ]]; then
                echo -e "${GREEN}✅ Using virtual environment${NC}"
            else
                echo -e "${YELLOW}⚠️  Not using virtual environment${NC}"
            fi
        else
            echo -e "${RED}❌ Python script not found: $script${NC}"
        fi
    fi
    
    # Check if it's an npm package
    if [[ "$command" == *"npx"* ]]; then
        local package=$(echo "$args" | jq -r '.[-1]')
        echo "📦 Checking npm package: $package"
        
        if npm view "$package" version >/dev/null 2>&1; then
            local version=$(npm view "$package" version)
            echo -e "${GREEN}✅ Package exists: $package@$version${NC}"
        else
            echo -e "${RED}❌ Package not found: $package${NC}"
        fi
    fi
    
    # Check environment variables
    local env_vars=$(jq -r ".mcpServers[\"$mcp_name\"].env // .\"$mcp_name\".env // {} | keys[]" "$config_file" 2>/dev/null)
    if [ -n "$env_vars" ]; then
        echo "🔐 Environment variables:"
        echo "$env_vars" | while read -r var; do
            local value=$(jq -r ".mcpServers[\"$mcp_name\"].env[\"$var\"] // .\"$mcp_name\".env[\"$var\"]" "$config_file")
            if [[ "$value" == *"path"* ]] || [[ "$value" == *"/"* ]]; then
                # Check if file exists
                if [ -f "$value" ]; then
                    echo -e "  ${GREEN}✅ $var: $value${NC}"
                else
                    echo -e "  ${RED}❌ $var: $value (file not found)${NC}"
                fi
            else
                echo -e "  ${GREEN}✅ $var: [set]${NC}"
            fi
        done
    fi
}

# Main execution
main() {
    local config_file="${1:-$HOME/.gemini/antigravity/mcp_config.json}"
    
    # Check dependencies
    echo "🔧 Checking dependencies..."
    if ! command_exists jq; then
        echo -e "${RED}❌ jq is required but not installed${NC}"
        echo "Install with: brew install jq"
        exit 1
    fi
    echo -e "${GREEN}✅ jq installed${NC}"
    
    if ! command_exists npm; then
        echo -e "${YELLOW}⚠️  npm not found (required for Node.js MCPs)${NC}"
    else
        echo -e "${GREEN}✅ npm installed${NC}"
    fi
    
    if ! command_exists python3; then
        echo -e "${YELLOW}⚠️  python3 not found (required for Python MCPs)${NC}"
    else
        echo -e "${GREEN}✅ python3 installed${NC}"
    fi
    
    echo ""
    
    # Test configuration
    test_mcp_config "$config_file"
    
    # Test each MCP
    local mcps=$(jq -r '.mcpServers | keys[] // keys[]' "$config_file" 2>/dev/null)
    echo "$mcps" | while read -r mcp; do
        test_mcp "$mcp" "$config_file"
    done
    
    echo ""
    echo "✨ Diagnostic complete!"
}

# Run main function
main "$@"
