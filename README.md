# gemini-config

This repository provides a set of tools and configurations for the Gemini CLI, specifically optimized for the [BMad Method](https://github.com/bmad-code-org/BMAD-METHOD).

It provides standardized interfaces for managing development environments, version control, and browser-based testing.

## Quickstart

```bash
# 1. Clone the repository
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config

# 2. Run the setup script to link configurations globally
./scripts/setup.sh
```

## Included Tools

The configuration provides five core utilities for technical execution:

1.  **Docker Tooling** (`/docker:*`): Manage containers, view logs, and reset runtime environments.
2.  **Network Utilities** (`/net:*`): Debug port conflicts and verify service connectivity.
3.  **Code Navigation** (`/code:*`): Map project structure and track function/variable references.
4.  **Browser Control** (`/browser:*`): Control headless Chrome for UI verification.
5.  **Git Management**: Maintain clean repository history and follow commit standards.

## Usage

### Direct Commands
Use namespaced commands for repetitive tasks:

- **Start Browser**: `gemini /browser:start`
- **Port Audit**: `gemini /net:ports`
- **Project Tree**: `gemini /code:map`
- **Service Status**: `gemini /docker:status`

### Technical Support
You can request assistance with complex engineering tasks by referencing the specific toolset:

> "Use the **Docker** tools to fix the port conflict on 3000."
> "Use the **Browser** tools to verify the user registration flow."

## Configuration Structure

- **`user-config/skills/`**: Technical guides and troubleshooting protocols.
- **`user-config/commands/`**: Command shortcuts for the CLI.
- **`user-config/GEMINI.md`**: Main project context and role definition.
- **`scripts/`**: Shell scripts for environment setup and browser management.

## BMad Integration

This runtime is built to support BMad agents by handling technical execution:
- **Project Truth**: Uses `_bmad-output/` as the primary reference for requirements.
- **Execution**: Performs the engineering steps defined in `_bmad/workflows/`.
