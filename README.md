# Elite TUI Gemini Configuration (v1.2)

> **Structured Orchestration for Large-Scale Polyglot Monorepos**

This configuration transforms the Gemini CLI into a **fully orchestrated AI Development Team**. Instead of loose chat sessions, agents coordinate via a strict, JSON-backed state machine, enforcing clear handoffs, architectural consistency, and reproducible workflows with **Hooks** and **Policies**.

## 🚀 Quickstart

### 1. Installation
Clone this repository:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

**What setup.sh does:**
- Checks dependencies (`node`, `rg`, `gemini`).
- Initializes `SESSION_PLAN.json` (v1.2) with Hook and Policy tracking.
- Creates `~/.gemini/hooks` and `~/.gemini/policies` directories.
- Optionally installs global configuration by symlinking `user-config`.

### 2. Tool & Safety Architecture (v1.2)
This config is optimized for the full Gemini CLI ecosystem:

#### 🛡️ Policies (`user-config/policies`)
The **Policy Engine** enforces granular access control:
- **Destructive Ops**: `rm`, `shutdown`, `sudo` require explicit confirmation.
- **Git Safety**: `git push` triggers a confirmation prompt.
- **Read-Only**: `read_file`, `glob`, `search` are auto-allowed.

#### 🪝 Hooks (`user-config/hooks`)
Scripts intercept tool execution for auditing and safety:
- **Audit Logging**: A default `log-tools.sh` records every tool call to `~/.gemini/tool-audit.log`.
- **Security Gates**: Hooks can block tools (Exit Code 2) if secrets are detected.

#### 🛠️ Tool-Native Agents
- **Polyglot Expert**: Uses `replace` (Smart Edit) with multi-stage correction. Research first via `web_fetch`.
- **QA Verifier**: Uses `search_file_content` (ripgrep) for high-speed security scans.
- **Orchestrator**: Syncs tasks to the native CLI UI via `write_todos`.

### 3. Workflow
Start the CLI and use the orchestrated commands:

```text
/refactor user_auth     # -> Creates task, delegates to Polyglot Expert
/analyze backend/api    # -> Snapshots architecture, scans for drift
/qa                     # -> Triggers batch review (runs actual tests)
/mcp                    # -> Check status of connected tools
```

---

## 🧠 Architecture (Structured Orchestration)

### 1. The Session Plan (`.gemini/SESSION_PLAN.json`)
The single source of truth. It tracks:
- **Tasks**: ID, Status, Priority, Dependencies.
- **Context Snapshots**: Hashes of critical context files.
- **Tool State**: Active MCP servers and Hook/Policy events.

### 2. The Agents (Skills)
| Role | Responsibility | Tools & Capabilities |
| :--- | :--- | :--- |
| **Orchestrator** | **Session Manager**. Manages JSON state, dependency resolution. Syncs `write_todos`. | `write_todos`, `save_memory` |
| **Polyglot Expert** | **Implementation**. Claims tasks. "Look Before You Leap" via `web_fetch`. | `replace`, `web_fetch`, `search_file_content` |
| **QA Verifier** | **Gatekeeper**. Active verification. Enforces Policy compliance. | `search_file_content`, `run_shell_command` |
| **Git Expert** | **Release Manager**. Atomic commits. Respects `pre-commit` hooks. | `run_shell_command` (git) |
| **Tech Debt Tracker**| **Scanner**. High-speed grep for TODOs. | `search_file_content`, `save_memory` |

### 3. Advanced Configuration

#### Sandboxing
For maximum safety, especially with `run_shell_command`, enable sandboxing:
```bash
gemini --sandbox
# OR
export GEMINI_SANDBOX=docker
```

#### Memory Integration
The system uses `save_memory` to persist "Project Axioms" (e.g., "Always use Pydantic v2") across sessions.

#### Customizing Hooks
Add your own scripts to `~/.gemini/hooks/` and reference them in `settings.json`.
*   **Stdin**: JSON input (tool name, args).
*   **Stdout**: JSON output (decision: allow/deny).
*   **Stderr**: Logging.

---

## 🤝 Contributing

1. **Fork** the repo.
2. **Setup**: Run `./scripts/setup.sh`.
3. **Commit**: Keep changes atomic.
4. **Push**: Submit PR to `main`.

**License**: MIT