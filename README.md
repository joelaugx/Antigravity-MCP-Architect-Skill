# MCP Architect

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/mcp-architect?style=social)](https://github.com/YOUR_USERNAME/mcp-architect)

> Expert guide for creating, configuring, troubleshooting, and managing MCP (Model Context Protocol) servers

## 🎯 Why This Exists

Antigravity has excellent MCP marketplace integration, but creating **custom MCPs** is challenging due to:

- ❌ Sparse documentation on MCP creation
- ❌ Cryptic error messages
- ❌ No troubleshooting guides
- ❌ Complex authentication setup
- ❌ No diagnostic tools

This skill solves these problems with **real-world examples** from actual troubleshooting sessions.

## ✨ What's Included

### 📚 Comprehensive Documentation

- **[SKILL.md](SKILL.md)**: Complete guide (10.8 KB) covering:
  - Common issues & solutions
  - Configuration patterns
  - Python & Node.js templates
  - Testing strategies
  - Best practices

### 🔧 Diagnostic Tools

- **[diagnostic.sh](examples/diagnostic.sh)**: Automated testing script that:
  - ✅ Validates JSON configuration
  - ✅ Checks if commands exist
  - ✅ Verifies npm packages
  - ✅ Tests Python scripts and venvs
  - ✅ Validates environment variables

### 💡 Real-World Examples

- **[examples/README.md](examples/README.md)**: Based on actual troubleshooting:
  - Google Drive MCP (OAuth authentication)
  - Apple Mail MCP (Python virtual environment)
  - GitHub MCP (Docker container)
  - Master registry pattern

## 🚀 Quick Start

### Use as Antigravity Skill

```bash
# Reference the skill when working with MCPs
@mcp-architect I need to create a new MCP for Slack
@mcp-architect My Google Drive MCP is not working
@mcp-architect How do I configure OAuth for an MCP?
```

### Use Diagnostic Tool

```bash
# Test your MCP configuration
./examples/diagnostic.sh /path/to/mcp_config.json
```

### Create a New MCP

1. Choose a template from [SKILL.md](SKILL.md) (Python or Node.js)
2. Implement your service integration
3. Test with the diagnostic script
4. Add to your configuration

## 📖 Documentation

- **[SKILL.md](SKILL.md)** - Main documentation with troubleshooting guides
- **[examples/README.md](examples/README.md)** - Real-world examples
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[ANTIGRAVITY_FEEDBACK.md](ANTIGRAVITY_FEEDBACK.md)** - Feedback for Antigravity team

## 🎓 Common Use Cases

### Troubleshooting a Broken MCP

```bash
# Run diagnostic
./examples/diagnostic.sh ~/.gemini/antigravity/mcp_config.json

# Check common issues in SKILL.md
# Apply the fix
# Verify with testing checklist
```

### Creating a Custom MCP

See templates in [SKILL.md](SKILL.md):

- Python MCP template (async implementation)
- Node.js MCP template (TypeScript-based)

### Managing Multiple MCPs

Use the master registry pattern from [examples/README.md](examples/README.md) to manage MCPs across multiple tools.

## 🔑 Key Learnings

Based on real troubleshooting experience:

1. ✅ **Always use absolute paths** - Relative paths cause issues
2. ✅ **Verify package names** - Check npm/PyPI before configuring
3. ✅ **Use dedicated venvs** - Isolate Python MCP dependencies
4. ✅ **Environment variables for credentials** - Never hardcode secrets
5. ✅ **Test manually first** - Verify MCPs work before adding to config
6. ✅ **Validate JSON** - Use `jq` to catch syntax errors
7. ✅ **Document authentication** - OAuth flows need clear instructions
8. ✅ **Master registry pattern** - Manage MCPs across multiple tools

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Ways to contribute**:

- 🐛 Report issues you've encountered
- 💡 Share your MCP examples
- 📝 Improve documentation
- 🔧 Enhance diagnostic tools

## 📜 License

MIT License - See [LICENSE.txt](LICENSE.txt) for details

## 🙏 Acknowledgments

Created from real-world experience troubleshooting MCPs for:

- Google Drive (OAuth authentication)
- Apple Mail (Python venv setup)
- Apple Photos (Python implementation)
- Brave Search (API key management)
- CloudRun (GCP integration)
- GitHub (Docker container)
- Google Docs (Python venv)
- File Systems (Node.js)

## 📞 Support

- 📖 Read the [SKILL.md](SKILL.md) documentation
- 🔍 Check [examples/README.md](examples/README.md) for real-world cases
- 🐛 Open an issue for bugs or questions
- 💬 Start a discussion for general questions

---

**Made with ❤️ to help the MCP community**
