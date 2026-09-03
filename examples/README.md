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

## Final Cut Pro MCP - macOS Video Editing Example

> ⚠️ **macOS only**: Every Final Cut Pro MCP server depends on Final Cut Pro itself (a macOS app), so these only run on a Mac with FCP installed — they cannot be installed or tested on Linux/Windows or in a headless CI/container environment.

There is no single official server; three actively maintained community servers cover two different approaches. Pick based on what you need:

| Server | Language / Distribution | Approach | Tool count | Best for |
|---|---|---|---|---|
| [`elliotttate/finalcutpro-mcp`](https://github.com/elliotttate/finalcutpro-mcp) | Node.js, build from source | Live control via AppleScript/JXA | 99 tools | Driving a running FCP session directly (timeline edits, playback, color grading, exports) |
| [`DareDev256/fcp-mcp-server`](https://github.com/DareDev256/fcp-mcp-server) | Python, PyPI (`fcp-mcp-server`) | FCPXML file editing, with optional live push | 7 grouped tools (62 operations) | Batch/offline editing of exported FCPXML (transcripts, markers, diagnostics) without needing FCP open |
| [`dreliq9/fcp-mcp`](https://github.com/dreliq9/fcp-mcp) | Python, PyPI (`fcp-mcp`) | Hybrid: FCPXML engine + live AppleScript control + media analysis | 94 tools | Wanting both approaches (and media/QC analysis via ffprobe) in one server |

### Option 1: Live control (`finalcutpro-mcp`)

**Requirements**: macOS 15.6+, Final Cut Pro 12.0+, Node.js 18+, and Accessibility permissions for System Events (System Settings → Privacy & Security → Accessibility).

```bash
# 1. Clone and build
git clone https://github.com/elliotttate/finalcutpro-mcp.git
cd finalcutpro-mcp
npm install
npm run build
```

```json
{
  "finalcutpro": {
    "command": "node",
    "args": ["/Users/user/finalcutpro-mcp/dist/index.js"]
  }
}
```

### Option 2: FCPXML editing (`fcp-mcp-server`)

**Requirements**: Python 3.10+, Final Cut Pro 10.4+ (FCPXML 1.8+). No FCP process needs to be running unless using live push.

```bash
# Via Claude Code
claude mcp add fcpxml -e FCP_PROJECTS_DIR=~/Movies -- uvx fcp-mcp-server

# Or run directly
uvx fcp-mcp-server
```

```json
{
  "fcpxml": {
    "command": "uvx",
    "args": ["fcp-mcp-server"],
    "env": {
      "FCP_PROJECTS_DIR": "/Users/user/Movies"
    }
  }
}
```

**Workflow**: Export XML from Final Cut Pro (`File → Export XML…`) → let the MCP inspect/edit the FCPXML → import the result back into FCP, or use its `push_to_fcp` tool to send it straight into the running app.

### Option 3: Hybrid (`fcp-mcp`)

**Requirements**: macOS 15.6+, Python 3.10+, `ffmpeg` (`brew install ffmpeg`) for media analysis.

```bash
pipx install fcp-mcp
```

```json
{
  "fcp": {
    "type": "stdio",
    "command": "fcp-mcp"
  }
}
```

Verify with `fcp-mcp doctor`.

### Common Issues

- **"Not authorized to send Apple events"**: Grant Accessibility permission to your terminal/Claude client in System Settings → Privacy & Security → Accessibility, then restart the MCP client.
- **Live-control tools time out or no-op**: Final Cut Pro must be open and running for AppleScript/JXA-based tools (Options 1 and 3's live features) — FCPXML-only tools in Option 2 don't need it.
- **FCPXML version mismatch**: Match the exported FCPXML version to what the server supports; older FCP versions export older FCPXML (10.4 → 1.8) which some tools may not accept.
- **`uvx`/`pipx` command not found**: Install with `pip install uv` (provides `uvx`) or `pip install pipx`, then re-run.

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
    "fcpxml": {
      "command": "uvx",
      "args": ["fcp-mcp-server"],
      "env": {
        "FCP_PROJECTS_DIR": "/Users/user/Movies"
      },
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
        "fcpxml",
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
        "brave-search",
        "fcpxml"
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
