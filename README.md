# Structured Gemini Configuration

This repository provides a multi-agent orchestration framework for the Gemini CLI. It enables specialized agents to coordinate complex tasks in large monorepos through a central state machine.

## Quickstart

Run the setup script to initialize the environment:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

The script verifies system requirements and creates the necessary tracking files in `.gemini/`.

## Architecture

The system uses a state-first approach where all agent actions are governed by a central plan.

### Session Plan
- Location: `.gemini/SESSION_PLAN.json`
- Function: Single source of truth for task status, dependencies, and code snapshots.
- Visibility: A read-only markdown projection is maintained at `.gemini/SESSION_PLAN.md`.

### Specialized Agents
- Orchestrator: Manages the task queue, dependencies, and file locks.
- Polyglot Expert: Implements code across Python and TypeScript.
- QA Verifier: Executes automated tests and security validations.
- Browser Expert: Performs frontend debugging via the Chrome DevTools Protocol.
- Git Expert: Handles commits and repository history.

## Common Workflows

The following commands initiate coordinated agent loops:

- `/refactor <topic>`: Define and implement a code change.
- `/analyze <path>`: Evaluate architecture and identify technical debt.
- `/qa`: Run project tests and verify completed work.
- `/mcp`: View connection status for external tools.

## Safety and Extensions

- Policies: Access controls defined in `user-config/policies/` prevent unauthorized destructive actions.
- Hooks: Lifecycle scripts in `user-config/hooks/` provide automated auditing and validation.
- Memory: High-level architectural axioms are persisted using the `save_memory` tool.