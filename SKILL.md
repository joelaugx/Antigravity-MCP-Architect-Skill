---
name: mcp-architect
description: Expert guide for creating, configuring, troubleshooting, and managing MCP (Model Context Protocol) servers. Covers Python and Node.js implementations, configuration management, diagnostics, and common issues resolution. Use when building new MCPs, fixing broken MCPs, or managing MCP configurations.
license: MIT
---

# MCP Architect - Complete MCP Management Guide

## Overview

This skill provides comprehensive guidance for the complete lifecycle of MCP servers:

- **Creating** new MCP servers (Python, Node.js)
- **Configuring** MCP servers in various environments
- **Troubleshooting** common MCP issues
- **Managing** MCP registries and configurations
- **Testing** MCP functionality

---

# Quick Reference

## Common Issues & Solutions

### 1. Package Not Found (404 Error)

**Symptom**: `npm error 404 Not Found - @package/name`

**Common Causes**:

- Incorrect package name
- Package renamed or deprecated
- Typo in configuration

**Solution**:

```bash
# Search for the correct package name
npm search @modelcontextprotocol

# Verify package exists
npm view @modelcontextprotocol/server-gdrive
```

**Real Example**: `@modelcontextprotocol/server-google-drive` → `@modelcontextprotocol/server-gdrive`

### 2. Missing Credentials / OAuth Issues

**Symptom**: `Cannot find module 'gcp-oauth.keys.json'` or `Credentials not found`

**Solution**:

1. Create credentials file in the correct location
2. Use environment variables to specify paths
3. Run authentication flow

```json
{
  "google-drive": {
    "command": "/opt/homebrew/bin/npx",
    "args": ["-y", "@modelcontextprotocol/server-gdrive"],
    "env": {
      "GDRIVE_OAUTH_PATH": "/absolute/path/to/gcp-oauth.keys.json"
    }
  }
}
```

### 3. Python Virtual Environment Issues

**Symptom**: `ModuleNotFoundError` or import errors

**Solution**:

```bash
# Create dedicated venv
python3 -m venv /path/to/mcp_tools/venv

# Install dependencies
/path/to/mcp_tools/venv/bin/pip install -r requirements.txt

# Update config to use venv python
{
  "command": "/path/to/venv/bin/python",
  "args": ["/path/to/script.py"]
}
```

### 4. MCP Server Not Starting

**Diagnostic Steps**:

1. Test the command manually
2. Check logs for errors
3. Verify all dependencies installed
4. Check file permissions
5. Validate JSON configuration

```bash
# Test manually
npx -y @modelcontextprotocol/server-gdrive --help

# Check if Python script runs
python /path/to/mcp_server.py
```

---

# Configuration Management

## Master Registry Pattern

Use a master registry to manage MCPs across multiple tools:

```json
{
  "tools": {
    "mcp-name": {
      "command": "/path/to/executable",
      "args": ["arg1", "arg2"],
      "env": {
        "KEY": "value"
      },
      "enabled": true
    }
  },
  "targets": {
    "antigravity_agent": {
      "path": "/Users/user/.gemini/antigravity/mcp_config.json",
      "include": ["mcp-name"],
      "wrapper": "mcpServers"
    },
    "claude_desktop": {
      "path": "/Users/user/Library/Application Support/Claude/claude_desktop_config.json",
      "include": ["mcp-name"],
      "wrapper": "mcpServers"
    }
  }
}
```

## Configuration Best Practices

1. **Use Absolute Paths**: Always use absolute paths for commands, scripts, and credentials
2. **Environment Variables**: Store sensitive data and paths in env variables
3. **Dedicated Virtual Environments**: Create separate venvs for Python MCPs
4. **Consistent Naming**: Use consistent naming across configurations
5. **Version Control**: Track configuration files (excluding secrets)

---

# Creating New MCPs

## Python MCP Template

```python
#!/usr/bin/env python3
"""
MCP Server for [Service Name]
"""
import asyncio
import json
import sys
from typing import Any

# MCP Protocol implementation
async def handle_request(request: dict[str, Any]) -> dict[str, Any]:
    """Handle MCP protocol requests"""
    method = request.get("method")
    
    if method == "tools/list":
        return {
            "tools": [
                {
                    "name": "tool_name",
                    "description": "Tool description",
                    "inputSchema": {
                        "type": "object",
                        "properties": {
                            "param": {"type": "string", "description": "Parameter description"}
                        },
                        "required": ["param"]
                    }
                }
            ]
        }
    
    elif method == "tools/call":
        tool_name = request["params"]["name"]
        arguments = request["params"]["arguments"]
        
        if tool_name == "tool_name":
            result = await execute_tool(arguments)
            return {
                "content": [
                    {"type": "text", "text": str(result)}
                ]
            }
    
    return {"error": "Unknown method"}

async def execute_tool(args: dict[str, Any]) -> Any:
    """Execute the actual tool logic"""
    # Implementation here
    pass

async def main():
    """Main MCP server loop"""
    while True:
        try:
            line = sys.stdin.readline()
            if not line:
                break
            
            request = json.loads(line)
            response = await handle_request(request)
            
            print(json.dumps(response), flush=True)
        except Exception as e:
            error_response = {"error": str(e)}
            print(json.dumps(error_response), flush=True)

if __name__ == "__main__":
    asyncio.run(main())
```

## Node.js MCP Template

```javascript
#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

const server = new Server(
  {
    name: 'mcp-server-name',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define tool
server.setRequestHandler('tools/list', async () => {
  return {
    tools: [
      {
        name: 'tool_name',
        description: 'Tool description',
        inputSchema: {
          type: 'object',
          properties: {
            param: {
              type: 'string',
              description: 'Parameter description',
            },
          },
          required: ['param'],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;
  
  if (name === 'tool_name') {
    const result = await executeTool(args);
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }
  
  throw new Error(`Unknown tool: ${name}`);
});

async function executeTool(args) {
  // Implementation here
}

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
```

---

# Testing MCPs

## Manual Testing Checklist

- [ ] Package/script runs without errors
- [ ] Authentication works (if required)
- [ ] Tools are listed correctly
- [ ] Tool calls execute successfully
- [ ] Error messages are helpful
- [ ] Configuration is valid JSON
- [ ] Paths are absolute
- [ ] Environment variables are set

## Testing Commands

```bash
# Test Node.js MCP
npx -y @package/name --help

# Test Python MCP
/path/to/venv/bin/python /path/to/script.py

# Test with MCP Inspector
npx @modelcontextprotocol/inspector

# Validate JSON configuration
jq . mcp_config.json

# Test authentication flow
OAUTH_PATH=/path/to/creds.json npx @package/name auth
```

---

# Diagnostic Tools

## Configuration Validator

```bash
# Check if MCP config is valid JSON
jq empty mcp_config.json && echo "✅ Valid JSON" || echo "❌ Invalid JSON"

# List all configured MCPs
jq -r '.mcpServers | keys[]' mcp_config.json

# Check specific MCP configuration
jq '.mcpServers["mcp-name"]' mcp_config.json
```

## Dependency Checker

```bash
# Check if npm package exists
npm view @package/name version

# Check Python dependencies
/path/to/venv/bin/pip list

# Verify file exists
ls -la /path/to/file
```

---

# Common MCP Patterns

## OAuth Authentication Pattern

```json
{
  "mcp-name": {
    "command": "/opt/homebrew/bin/npx",
    "args": ["-y", "@package/name"],
    "env": {
      "OAUTH_PATH": "/path/to/credentials.json",
      "TOKEN_PATH": "/path/to/tokens.json"
    }
  }
}
```

## API Key Pattern

```json
{
  "mcp-name": {
    "command": "/opt/homebrew/bin/npx",
    "args": ["-y", "@package/name"],
    "env": {
      "API_KEY": "your-api-key-here"
    }
  }
}
```

## Python Virtual Environment Pattern

```json
{
  "mcp-name": {
    "command": "/path/to/project/venv/bin/python",
    "args": ["/path/to/project/mcp_server.py"],
    "env": {
      "PYTHONPATH": "/path/to/project"
    }
  }
}
```

## Docker Container Pattern

```json
{
  "mcp-name": {
    "command": "/usr/local/bin/docker",
    "args": [
      "run", "-i", "--rm",
      "-e", "ENV_VAR",
      "image:tag"
    ],
    "env": {
      "ENV_VAR": "value"
    }
  }
}
```

---

# Troubleshooting Workflow

## Step 1: Identify the Issue

- Read error messages carefully
- Check MCP status in the UI
- Review recent configuration changes

## Step 2: Isolate the Problem

- Test the MCP command manually
- Verify dependencies are installed
- Check file permissions and paths
- Validate JSON configuration

## Step 3: Research the Solution

- Search for package documentation
- Check GitHub issues
- Look for similar MCPs
- Review MCP protocol documentation

## Step 4: Implement the Fix

- Update configuration
- Install missing dependencies
- Fix file paths
- Run authentication if needed

## Step 5: Verify the Fix

- Test manually
- Check MCP status
- Verify functionality
- Document the solution

---

# Resources

## Official Documentation

- MCP Protocol: <https://modelcontextprotocol.io>
- Python SDK: <https://github.com/modelcontextprotocol/python-sdk>
- TypeScript SDK: <https://github.com/modelcontextprotocol/typescript-sdk>

## Package Registries

- npm: <https://www.npmjs.com/search?q=%40modelcontextprotocol>
- PyPI: <https://pypi.org/search/?q=mcp>

## Tools

- MCP Inspector: `npx @modelcontextprotocol/inspector`
- JSON Validator: `jq`
- Package Search: `npm search`, `pip search`

---

# Best Practices Summary

1. ✅ Always use absolute paths
2. ✅ Create dedicated virtual environments for Python MCPs
3. ✅ Use environment variables for credentials
4. ✅ Test MCPs manually before adding to configuration
5. ✅ Validate JSON configuration files
6. ✅ Document authentication requirements
7. ✅ Keep a master registry for consistency
8. ✅ Version control configurations (excluding secrets)
9. ✅ Provide helpful error messages
10. ✅ Follow MCP naming conventions
