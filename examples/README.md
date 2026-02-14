# Real-World MCP Examples

This directory contains real-world examples based on actual MCP implementations and troubleshooting scenarios.

## Google Drive MCP - Complete Example

### Problem Encountered

The Google Drive MCP was failing with a 404 error because the package name was incorrect.

### Original (Broken) Configuration

```json
{
  "google-drive": {
    "command": "/opt/homebrew/bin/npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-google-drive",
      "/Users/user/credentials.json"
    ]
  }
}
```

### Issues Identified

1. ❌ Package name was wrong: `server-google-drive` → should be `server-gdrive`
2. ❌ Credentials path passed as argument instead of environment variable
3. ❌ Missing OAuth path configuration

### Fixed Configuration

```json
{
  "google-drive": {
    "command": "/opt/homebrew/bin/npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-gdrive"
    ],
    "env": {
      "GDRIVE_OAUTH_PATH": "/Users/user/path/to/gcp-oauth.keys.json"
    }
  }
}
```

### Authentication Steps

```bash
# 1. Copy OAuth credentials to the correct location
cp /path/to/credentials.json /path/to/mcp_tools/gcp-oauth.keys.json

# 2. Run authentication flow
GDRIVE_OAUTH_PATH="/path/to/gcp-oauth.keys.json" npx @modelcontextprotocol/server-gdrive auth

# 3. Verify credentials were saved
ls -la ~/.config/google-drive-mcp/tokens.json
```

### Verification

```bash
# Test the package exists
npm view @modelcontextprotocol/server-gdrive

# Test it runs
GDRIVE_OAUTH_PATH="/path/to/gcp-oauth.keys.json" npx @modelcontextprotocol/server-gdrive --help
```

---

## Apple Mail MCP - Python Example

### Configuration

```json
{
  "apple-mail": {
    "command": "/Users/user/mcp_tools/venv/bin/python",
    "args": [
      "/Users/user/mcp_tools/apple_mail_mcp.py"
    ],
    "env": {
      "IMAP_USER": "user@example.com",
      "IMAP_PASSWORD": "app-specific-password"
    }
  }
}
```

### Setup Steps

```bash
# 1. Create virtual environment
python3 -m venv /Users/user/mcp_tools/venv

# 2. Install dependencies
/Users/user/mcp_tools/venv/bin/pip install imaplib2

# 3. Test the script
/Users/user/mcp_tools/venv/bin/python /Users/user/mcp_tools/apple_mail_mcp.py
```

### Common Issues

- **Missing dependencies**: Install in the venv, not globally
- **IMAP password**: Use app-specific password, not main password
- **Import errors**: Ensure venv Python is used in config

---

## GitHub MCP - Docker Example

### Configuration

```json
{
  "github-mcp-server": {
    "command": "/usr/local/bin/docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "-e",
      "GITHUB_PERSONAL_ACCESS_TOKEN",
      "ghcr.io/github/github-mcp-server"
    ],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxx"
    }
  }
}
```

### Setup Steps

```bash
# 1. Verify Docker is installed
docker --version

# 2. Pull the image
docker pull ghcr.io/github/github-mcp-server

# 3. Test it runs
docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxx ghcr.io/github/github-mcp-server
```

---

## Master Registry Example

Complete example of managing MCPs across multiple tools:

```json
{
  "tools": {
    "apple-photos": {
      "command": "/Users/user/apple-photos-mcp/venv/bin/python",
      "args": ["/Users/user/apple-photos-mcp/server.py"],
      "enabled": true
    },
    "google-drive": {
      "command": "/opt/homebrew/bin/npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GDRIVE_OAUTH_PATH": "/Users/user/mcp_tools/gcp-oauth.keys.json"
      },
      "enabled": true
    },
    "brave-search": {
      "command": "/opt/homebrew/bin/npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "BSA_xxxxxxxxxxxxx"
      },
      "enabled": true
    },
    "cloudrun": {
      "command": "/opt/homebrew/bin/npx",
      "args": ["-y", "@google-cloud/cloud-run-mcp"],
      "enabled": true
    },
    "github-mcp-server": {
      "command": "/usr/local/bin/docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxx"
      },
      "enabled": true
    }
  },
  "targets": {
    "antigravity_agent": {
      "path": "/Users/user/.gemini/antigravity/mcp_config.json",
      "include": [
        "cloudrun",
        "github-mcp-server",
        "apple-photos",
        "google-drive",
        "brave-search"
      ],
      "wrapper": "mcpServers"
    },
    "claude_desktop": {
      "path": "/Users/user/Library/Application Support/Claude/claude_desktop_config.json",
      "include": [
        "apple-photos",
        "google-drive",
        "brave-search"
      ],
      "wrapper": "mcpServers"
    }
  }
}
```

---

## Troubleshooting Scenarios

### Scenario 1: "Cannot find module"

**Error**: `Cannot find module '/path/to/gcp-oauth.keys.json'`

**Diagnosis**:

```bash
# Check if file exists
ls -la /path/to/gcp-oauth.keys.json

# Check if path is absolute
echo "/path/to/gcp-oauth.keys.json" | grep "^/"
```

**Solution**:

1. Create the file if missing
2. Use absolute path
3. Set environment variable

### Scenario 2: "npm error 404"

**Error**: `npm error 404 Not Found - @package/name`

**Diagnosis**:

```bash
# Search for similar packages
npm search @modelcontextprotocol

# Check exact package name
npm view @modelcontextprotocol/server-gdrive
```

**Solution**:

1. Find correct package name
2. Update configuration
3. Test manually

### Scenario 3: Python Import Error

**Error**: `ModuleNotFoundError: No module named 'xxx'`

**Diagnosis**:

```bash
# Check which Python is being used
which python3

# Check installed packages
/path/to/venv/bin/pip list

# Verify venv is activated in config
cat mcp_config.json | grep python
```

**Solution**:

1. Install missing package in venv
2. Ensure config uses venv Python
3. Verify PYTHONPATH if needed

---

## Testing Checklist

### Before Adding to Configuration

- [ ] Package/script exists and runs
- [ ] Dependencies are installed
- [ ] Authentication works (if required)
- [ ] Paths are absolute
- [ ] Environment variables are set
- [ ] JSON configuration is valid
- [ ] Tested manually with success

### After Adding to Configuration

- [ ] MCP shows as enabled in UI
- [ ] No error messages in logs
- [ ] Tools are listed correctly
- [ ] Tool calls work as expected
- [ ] Configuration persists after restart
