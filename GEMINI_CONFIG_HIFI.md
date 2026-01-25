# Structured Gemini Configuration (v1.2.1: Production Alignment)

**Status:** Deployed (v1.2.1 - Enhanced Resilience)
**Target:** Large-Scale Polyglot Monorepos
**Architecture:** Multi-Agent State Machine (JSON-Backed) with Hooks, Policies, and CDP diagnostics.
**Mode:** Pure TUI

This configuration transforms the Gemini CLI into a fully orchestrated AI Development Team. Instead of loose chat sessions, agents coordinate via a strict, JSON-backed state machine, enforcing clear handoffs, architectural consistency, and safety via hooks and policies.

## Core Architecture

### 1. Structured State (.gemini/SESSION_PLAN.json)
The single source of truth. Tracks tasks, status, context snapshots, tool states, and hook/policy events to prevent drift.

```json
{
  "version": "1.2",
  "tasks": [
    {
      "id": "uuid-v4",
      "title": "Refactor User API",
      "status": "pending|in_progress|completed|qa_passed",
      "assigned_to": "polyglot-expert",
      "priority": "high",
      "dependencies": []
    }
  ],
  "context_snapshots": {
    "module_graph": { "hash": "...", "updated_at": "..." }
  },
  "hook_events": [],
  "policy_events": []
}
```

### 2. Human View (.gemini/SESSION_PLAN.md)
Read-only Markdown projection. Automatically synced by the orchestrator skill after every JSON update.

### 3. Agent Roles & Responsibilities

| Agent | Responsibility | Tools & Capabilities |
| :--- | :--- | :--- |
| **Orchestrator** | **System Manager**. Manages roadmap, dependencies, and state machine. | `write_todos`, `save_memory` |
| **Product Strategist** | **Intent & UX**. OpenSpec governance and technical requirement drafting. | `openspec/`, `design.md` |
| **Polyglot Expert** | **Logic Lead**. High-fidelity Python/TypeScript implementation. | `replace`, `web_fetch` |
| **Database Architect** | **Data Lead**. Schema design, migrations, and indexing. | `SQL`, `migrations/`, `ORM` |
| **Browser Expert** | **Frontend Debugger**. Protocol-level (CDP) diagnostics using the official chrome-devtools-mcp extension. | `browser_get_console_logs`, `CDP` |
| **Infra/SRE Engineer** | **Ops Lead**. CI/CD, Docker, and repository stability. | `docker`, `actions/`, `git` |
| **QA/Sec Auditor** | **Gatekeeper**. Active verification and secret scanning. | `search_file_content`, `tests/` |
| **DX Engineer** | **Tooling Lead**. Automation, ergonomics, and setup scripts. | `scripts/`, `setup.sh` |
| **Knowledge Architect** | **Technical Writer**. API docs, manuals, and system diagrams. | `README.md`, `API.md` |
| **Debt Architect** | **Refactor Lead**. Scalability and performance profiling. | `profiling`, `refactoring` |


## Safety & Governance (v1.2)

### 1. Policy Engine (user-config/policies/*.toml)
Fine-grained access control using the Gemini CLI Policy Engine.
- **Safety First**: `rm`, `sudo`, `shutdown` commands require explicit user confirmation.
- **Git Guard**: `git push` operations trigger a confirmation prompt.
- **Read-Only**: `read_file`, `glob`, `search` are allowed automatically.

### 2. Hooks System (user-config/hooks/)
Scripts intercept tool execution for auditing and validation.
- **Audit Log**: `log-tools.sh` records every tool execution to `~/.gemini/tool-audit.log`.
- **Security Gates**: Hooks can block tools (Exit Code 2) if secrets/patterns are detected.

## Directory Structure

```text
gemini-config/
|-- scripts/
|   `-- setup.sh                 # Initializes .gemini/SESSION_PLAN.json (v1.2) & install
`-- user-config/
    |-- skills/                  # JSON-Aware Agents (Orchestrator, Polyglot, etc.)
    |-- commands/                # /refactor, /analyze, /qa
    |-- context/                 # Static Knowledge Base (Code Style, Module Graph)
    |-- hooks/                   # Interceptors (log-tools.sh)
    |-- policies/                # TOML Rules (safety.toml)
    `-- settings.json            # Configures Hooks, Tools, MCP
```

## Workflows

### 1. Feature Lifecycle (/design -> /refactor -> /qa -> /release)
1.  **Product Strategist** (/design): Drafts OpenSpec proposal and scenarios.
2.  **Orchestrator** (/refactor): Initializes task queue and delegates implementation.
3.  **Polyglot Expert**: Implements changes and signals completion.
4.  **QA Verifier** (/qa): Executes active tests against scenarios.
5.  **Git Expert** (/release): Atomic commit and OpenSpec archival.

### 2. Architectural Analysis (/analyze)
1.  **Orchestrator**: Snapshots module graph.
2.  **Debt Architect**: Scans for rot using ripgrep.
3.  **Reporting**: Findings logged as memory axioms or implementation tasks.

### 3. Frontend Diagnostics (/browser)
1.  **DX Engineer**: Pre-flight environment check (Port 9222).
2.  **Browser Expert**: Protocol-level telemetry and screenshot capture.
3.  **Adjudication**: High-signal diagnostics reported to the team.

### 4. Autonomous Handoff (/dispatch)
1.  **Orchestrator**: Scans JSON state machine.
2.  **Dispatch**: Logic-driven activation of the required specialist to clear the next bottleneck.

## Usage

**Initialize:**
```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

**Commands:**
- `/refactor user_auth`: Start a refactoring workflow.
- `/analyze backend/api`: Check for architectural drift.
- `/qa`: Run the quality gate.
- `/mcp`: Check status of connected tools/MCP servers.
