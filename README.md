# Structured Gemini Configuration

This repository provides a multi-agent orchestration framework for the Gemini CLI. It enables specialized agents to coordinate complex tasks in large monorepos through a central state machine.

## Quickstart

Run the setup script to initialize the environment:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

The script verifies system requirements, creates tracking files in `.gemini/`, and optionally installs the configuration and global scripts (`gemini-browser-launch`) to your home directory.

## Architecture

The system uses a state-first approach where all agent actions are governed by a central plan.

### Session Plan
- Location: `.gemini/SESSION_PLAN.json`
- Function: Single source of truth for task status, dependencies, and code snapshots.
- Visibility: A read-only markdown projection is maintained at `.gemini/SESSION_PLAN.md`.

### Specialized Agents
- Orchestrator: Manages the task queue, dependencies, and file locks.
- Product Strategist: Defines requirements and technical intent.
- Polyglot Expert: Implements code across Python and TypeScript.
- Database Architect: Manages storage schemas and migrations.
- Browser Expert: Performs frontend debugging via the Chrome DevTools Protocol.
- Git Expert: Handles commits and repository history.
- QA Verifier: Executes automated tests and security validations.
- DX Engineer: Optimizes internal tooling and environments.
- Knowledge Architect: Maintains technical documentation and manuals.
- Debt Architect: Manages scalability and refactoring.

## Common Workflows

The following commands initiate coordinated agent loops:

- `/design <topic>`: Translate requirements into technical intent and OpenSpec proposals.
- `/refactor <topic>`: Define and implement a code change or new feature.
- `/analyze <path>`: Evaluate architecture and identify technical debt.
- `/qa`: Run project tests and verify completed work.
- `/browser <url>`: Execute protocol-level diagnostics and visual verification.
- `/release`: Commit verified tasks and archive proposals.
- `/dispatch`: Scan the plan and activate the next logical specialist.
- `/mcp`: View connection status for external tools.

## Browser Debugging

To use the Browser Expert, you must have Chrome running with remote debugging enabled. You can use the global command installed by `setup.sh`:

```bash
gemini-browser-launch
```

Additionally, install the official extension:

```bash
gemini extensions install https://github.com/ChromeDevTools/chrome-devtools-mcp
```

## Safety and Extensions

- Policies: Access controls defined in `user-config/policies/` prevent unauthorized destructive actions.
- Hooks: Lifecycle scripts in `user-config/hooks/` provide automated auditing and validation.
- Memory: High-level architectural axioms are persisted using the `save_memory` tool.