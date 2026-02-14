# Feedback for Antigravity MCP Documentation

## Executive Summary

While Antigravity provides excellent MCP marketplace integration with a dedicated UI, the documentation and tooling for creating custom MCPs needs significant improvement. This document outlines specific gaps and actionable recommendations based on real-world experience.

---

## Current State

### What Works Well ✅

1. **MCP Marketplace**: Easy discovery and installation of existing MCPs
2. **UI Integration**: Dedicated button and interface for MCP management
3. **Configuration System**: `mcp_config.json` is straightforward once you understand it
4. **Multi-tool Support**: MCPs work across different AI tools (Antigravity, Claude Desktop, etc.)

### Critical Gaps ❌

1. **No Custom MCP Creation Guide**: Official docs focus on using MCPs, not creating them
2. **Troubleshooting Documentation**: Error messages are cryptic with no debugging guide
3. **Authentication Examples**: OAuth and API key setup is poorly documented
4. **Environment Setup**: Virtual environment configuration is not explained
5. **Testing Tools**: No diagnostic utilities provided

---

## Specific Issues Encountered

### 1. Package Name Confusion

**Problem**: MCP package names are inconsistent and hard to discover

**Example**:

- ❌ `@modelcontextprotocol/server-google-drive` (doesn't exist)
- ✅ `@modelcontextprotocol/server-gdrive` (correct)

**Impact**: Developers waste hours trying different package names

**Recommendation**:

- Maintain a searchable registry of official MCP packages
- Add package name validation in the UI
- Show "Did you mean...?" suggestions for typos

### 2. OAuth Configuration

**Problem**: OAuth setup requires undocumented environment variables

**Example**: Google Drive MCP needs `GDRIVE_OAUTH_PATH` but this isn't documented

**Impact**: MCPs fail silently or with cryptic errors

**Recommendation**:

- Document required environment variables for each MCP
- Provide OAuth setup wizard in the UI
- Include credential file templates

### 3. Python Virtual Environments

**Problem**: No guidance on setting up Python MCPs with dependencies

**Example**: Import errors because packages installed globally, not in venv

**Impact**: Python MCPs fail with `ModuleNotFoundError`

**Recommendation**:

- Document venv setup process
- Provide venv creation script
- Show best practices for dependency management

### 4. Error Messages

**Problem**: Error messages don't guide users to solutions

**Examples**:

- `npm error 404 Not Found` → doesn't suggest checking package name
- `Cannot find module` → doesn't show expected file location
- `Credentials not found` → doesn't explain auth flow

**Recommendation**:

- Add contextual error messages with next steps
- Link to troubleshooting docs from error output
- Include common solutions in error text

---

## Recommended Documentation Additions

### 1. "Creating Your First Custom MCP" Tutorial

**Content**:

- Step-by-step guide for Python and Node.js
- Complete working example (e.g., Weather API MCP)
- Testing and debugging section
- Deployment to marketplace

**Format**: Interactive tutorial with code snippets

### 2. MCP Troubleshooting Guide

**Content**:

- Common errors and solutions
- Diagnostic commands
- Configuration validation
- Authentication debugging

**Format**: Searchable FAQ with code examples

### 3. MCP Configuration Reference

**Content**:

- Complete `mcp_config.json` schema
- All supported fields and their purpose
- Environment variable patterns
- Security best practices

**Format**: API-style reference documentation

### 4. Authentication Patterns Guide

**Content**:

- OAuth 2.0 setup (Google, Microsoft, etc.)
- API key management
- Token refresh handling
- Credential storage best practices

**Format**: Pattern library with examples

### 5. MCP Development Best Practices

**Content**:

- Virtual environment setup
- Dependency management
- Error handling patterns
- Testing strategies
- Performance optimization

**Format**: Best practices guide with rationale

---

## Tooling Recommendations

### 1. MCP Diagnostic CLI Tool

**Purpose**: Validate MCP configurations and identify issues

**Features**:

- JSON configuration validation
- Package/dependency checking
- Credential verification
- Path validation
- Environment variable testing

**Example**: `antigravity mcp diagnose [mcp-name]`

### 2. MCP Scaffolding Tool

**Purpose**: Generate boilerplate for new MCPs

**Features**:

- Interactive prompts for MCP details
- Template selection (Python/Node.js)
- Automatic dependency setup
- Configuration file generation

**Example**: `antigravity mcp create my-custom-mcp --type=python`

### 3. MCP Testing Framework

**Purpose**: Test MCPs before deployment

**Features**:

- Mock request/response testing
- Authentication flow testing
- Integration testing
- Performance benchmarking

**Example**: `antigravity mcp test my-custom-mcp`

---

## Community Resources Needed

### 1. MCP Examples Repository

**Content**:

- Real-world MCP implementations
- Different authentication patterns
- Various API integrations
- Deployment configurations

**Location**: GitHub repo with searchable examples

### 2. MCP Development Forum

**Purpose**: Community support for MCP developers

**Features**:

- Q&A section
- Code review requests
- Best practices discussions
- Troubleshooting help

### 3. MCP Template Library

**Content**:

- Starter templates for common patterns
- Authentication templates
- API client templates
- Error handling templates

---

## Implementation Priority

### High Priority (Immediate Impact)

1. ✅ **Troubleshooting guide** - Solves immediate pain points
2. ✅ **Package name registry** - Prevents common errors
3. ✅ **OAuth setup guide** - Enables complex integrations

### Medium Priority (Quality of Life)

1. ⚠️ **Diagnostic CLI tool** - Speeds up debugging
2. ⚠️ **Configuration reference** - Reduces trial and error
3. ⚠️ **Examples repository** - Accelerates learning

### Low Priority (Nice to Have)

1. 📋 **Scaffolding tool** - Convenience feature
2. 📋 **Testing framework** - Advanced use case
3. 📋 **Development forum** - Long-term community building

---

## Success Metrics

How to measure improvement:

1. **Reduced Time to First MCP**: Track how long it takes new users to create their first working MCP
2. **Error Resolution Rate**: Percentage of errors users can resolve without external help
3. **Community Contributions**: Number of custom MCPs published to marketplace
4. **Support Ticket Volume**: Reduction in MCP-related support requests
5. **Documentation Engagement**: Views, time-on-page, and helpfulness ratings

---

## Conclusion

Antigravity has built excellent MCP infrastructure, but the developer experience for creating custom MCPs needs significant improvement. The recommendations above are based on real-world pain points and would dramatically improve the MCP ecosystem.

**Key Takeaway**: Make creating custom MCPs as easy as using marketplace MCPs.

---

## Appendix: Real-World Example

### Problem Solved Today

**Issue**: Google Drive MCP failing with 404 error

**Root Cause**: Package name was `server-google-drive` instead of `server-gdrive`

**Time to Resolution**: 2+ hours of trial and error

**What Would Have Helped**:

1. Package name validator in UI
2. Searchable package registry
3. Better error message: "Package not found. Did you mean @modelcontextprotocol/server-gdrive?"
4. Diagnostic tool showing: "❌ Package @modelcontextprotocol/server-google-drive does not exist"

**Impact**: This single issue consumed significant development time and could have been prevented with better tooling.

---

**Submitted by**: MCP Architect Skill Contributors  
**Date**: February 14, 2026  
**Contact**: [Your preferred contact method]
