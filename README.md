# gemini-config

Configuration and tools for the Gemini CLI, optimized for the [BMad Method](https://github.com/bmad-code-org/BMAD-METHOD).

This gives Gemini a standardized way to manage development environments, version control, and browser testing.

## Quickstart

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

## Included Tools

Five utilities for common development tasks:

1. **Docker Tooling** (`/docker:*`): Manage containers, view logs, and reset runtime environments
2. **Network Utilities** (`/net:*`): Debug port conflicts and check service connectivity
3. **Code Navigation** (`/code:*`): Map project structure and track function/variable references
4. **Browser Control** (`/browser:*`): Control headless Chrome for UI verification
5. **Git Management**: Maintain repository history and follow commit standards

## Usage

### Direct Commands

Use namespaced commands for repetitive tasks:

- Start browser: `gemini /browser:start`
- Port audit: `gemini /net:ports`
- Project tree: `gemini /code:map`
- Service status: `gemini /docker:status`

### Getting help

Reference specific toolsets when you need help with complex tasks:

- "Use the Docker tools to fix the port conflict on 3000"
- "Use the Browser tools to verify the user registration flow"

## Configuration Structure

- `user-config/skills/` - Technical guides and troubleshooting protocols
- `user-config/commands/` - Command shortcuts for the CLI
- `user-config/GEMINI.md` - Main project context and role definition
- `scripts/` - Shell scripts for environment setup and browser management

## BMad Integration

This supports BMad agents by handling technical execution:

- **Project Truth**: Uses `_bmad-output/` as the primary reference for requirements
- **Execution**: Performs engineering steps defined in `_bmad/workflows/`
