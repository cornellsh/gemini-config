# Elite TUI Gemini Configuration (v1.2: Structured Orchestration)

**Status:** Deployed (v1.2)
**Target:** Large-Scale Polyglot Monorepos
**Architecture:** Multi-Agent State Machine (JSON-Backed) with Hooks & Policy Engine
**Mode:** Pure TUI

This configuration transforms the Gemini CLI into a **fully orchestrated AI Development Team**. Instead of loose chat sessions, agents coordinate via a strict, JSON-backed state machine, enforcing clear handoffs, architectural consistency, and safety via hooks and policies.

## 🧠 Core Architecture

### 1. Structured State (`.gemini/SESSION_PLAN.json`)
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

### 2. Human View (`.gemini/SESSION_PLAN.md`)
Read-only Markdown projection. Automatically synced by the `orchestrator` skill after every JSON update.

### 3. Agent Roles & Responsibilities

| Agent | Responsibility | Tools & Capabilities |
| :--- | :--- | :--- |
| **Orchestrator** | **Session Manager**. Manages JSON state, dependencies, conflict detection. Syncs native `write_todos` UI. | `write_todos`, `save_memory`, `read/write_file` |
| **Polyglot Expert** | **Implementation**. Claims verified tasks. Enforces contracts. Research before coding ("Look Before You Leap"). | `replace` (Smart Edit), `web_fetch`, `search_file_content` |
| **QA Verifier** | **Gatekeeper**. Reviews code, security scans, runs **active tests**. Enforces Policies. | `search_file_content` (ripgrep), `run_shell_command` |
| **Browser Expert** | **Frontend Automation**. Visual QA, DOM extraction, and console debugging via Chrome DevTools. | `browser_navigate`, `browser_screenshot`, `browser_get_console_logs` |
| **Git Expert** | **Release Manager**. Atomic commits. Validates history. Respects `pre-commit` hooks. | `run_shell_command` (git) |
| **Tech Debt Tracker** | **Scanner**. High-speed grep for TODOs/Fixmes. | `search_file_content`, `save_memory` |

## 🛡️ Safety & Governance (v1.2)

### 1. Policy Engine (`user-config/policies/*.toml`)
Fine-grained access control using the Gemini CLI Policy Engine.
- **Safety First**: `rm`, `sudo`, `shutdown` commands require explicit user confirmation.
- **Git Guard**: `git push` operations trigger a confirmation prompt.
- **Read-Only**: `read_file`, `glob`, `search` are allowed automatically.

### 2. Hooks System (`user-config/hooks/`)
Scripts intercept tool execution for auditing and validation.
- **Audit Log**: `log-tools.sh` records every tool execution to `~/.gemini/tool-audit.log`.
- **Security Gates**: Hooks can block tools (Exit Code 2) if secrets/patterns are detected.

## 📂 Directory Structure

```text
gemini-config/
├── scripts/
│   └── setup.sh                 # Initializes .gemini/SESSION_PLAN.json (v1.2) & install
├── user-config/
│   ├── skills/                  # JSON-Aware Agents (Orchestrator, Polyglot, etc.)
│   ├── commands/                # /refactor, /analyze, /qa
│   ├── context/                 # Static Knowledge Base (Code Style, Module Graph)
│   ├── hooks/                   # Interceptors (log-tools.sh)
│   ├── policies/                # TOML Rules (safety.toml)
│   └── settings.json            # Configures Hooks, Tools, MCP
```

## 🚀 Workflows

### 1. Plan-Driven Refactoring (`/refactor <target>`)
1.  **Orchestrator**: Creates task `Refactor <target>` in JSON. Snapshots context. Syncs `write_todos` to UI. Delegates to `polyglot-expert`.
2.  **Polyglot Expert**: Claims task. Uses `web_fetch` to check docs. Implements via `replace` (Smart Edit). Updates JSON to `completed`.
3.  **QA Verifier**: Claims `completed` task. Runs `search_file_content` (security) and `run_shell_command` (tests). Updates JSON to `qa_passed`.
4.  **Git Expert**: Claims `qa_passed` task. Stages & commits via `git`. Updates JSON to `closed`.

### 2. Architectural Analysis (`/analyze <target>`)
1.  **Orchestrator**: Snapshots `module-graph.md`. Creates "Analyze <target>" task.
2.  **Execution**: Scans codebase using `search_file_content` and `glob`.
3.  **Reporting**: Logs findings as new tasks in `SESSION_PLAN.json`.

### 3. Quality Assurance (`/qa`)
1.  **QA Verifier**: Scans JSON for *all* `completed` tasks.
2.  **Active Test**: Runs project-specific test commands (sandboxed if enabled).
3.  **Feedback**: Rejects (`in_progress`) or Approves (`qa_passed`) in bulk.

## 📦 Usage

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
