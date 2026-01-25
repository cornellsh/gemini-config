# Structured Gemini Configuration

This is a multi-agent orchestration setup for the Gemini CLI. It replaces loose chat sessions with a structured, plan-backed development environment suitable for large polyglot monorepos.

The system manages state through a JSON session plan, ensuring that different specialized agents can coordinate on complex tasks without losing context or drifting from architectural standards.

## Quickstart

Clone the repository and run the setup script to initialize your environment:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

The script verifies dependencies (node, ripgrep, gemini CLI) and initializes the session plan tracking files. You can also choose to install the configuration globally to your home directory.

## Core Concepts

The configuration relies on a state-first approach. Instead of the model guessing what to do next, it refers to a central plan.

### Session Plan
The file at `.gemini/SESSION_PLAN.json` acts as the single source of truth. It tracks:
*   Tasks and their current status (pending, in-progress, completed, qa_passed).
*   Dependencies between tasks to prevent out-of-order execution.
*   Context snapshots (hashes of your code) to detect drift between AI turns.

A human-readable version is automatically maintained at `.gemini/SESSION_PLAN.md`.

### The Team (Agents)
Specialized skills handle different parts of the development lifecycle:
*   Orchestrator: Manages the task list, resolves dependencies, and detects file conflicts.
*   Polyglot Expert: Handles implementation across Python and TypeScript. Researches documentation before writing code.
*   QA Verifier: Runs active tests and security scans. Gates the transition to commit-ready state.
*   Browser Expert: Debugs frontend issues using the Chrome DevTools Protocol (CDP).
*   Git Expert: Manages atomic commits and maintains a clean history.

## Workflow

Start the CLI and use these commands to trigger the orchestration loop:

*   `/refactor <topic>`: Creates a structured task and delegates it to the implementation agent.
*   `/analyze <path>`: Snapshots the architecture and scans for technical debt or drift.
*   `/qa`: Triggers a batch review of all completed tasks, running actual tests in your terminal.
*   `/mcp`: Displays the status of your tool connections and MCP servers.

## Safety and Security

This setup includes a built-in policy engine and hook system to keep the environment safe:

*   Policies: Destructive commands like `rm` or `sudo` require manual confirmation, even if the agent is otherwise autonomous.
*   Hooks: Every tool execution is recorded in `~/.gemini/tool-audit.log`. You can add custom hooks to scan for secrets or enforce specific coding rules before any file is saved.
*   Sandboxing: It is recommended to run the system with `GEMINI_SANDBOX=docker` when executing shell commands.

## Customization

You can adjust the agent behaviors in `user-config/skills/` or add new safety rules in `user-config/policies/`. High-level architectural decisions can be persisted across sessions using the `save_memory` tool, which the agents use to stay aligned with your project axioms.
