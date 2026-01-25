# Elite TUI Gemini Configuration (v1.1)

> **Structured Orchestration for Large-Scale Polyglot Monorepos**

This configuration transforms the Gemini CLI into a **fully orchestrated AI Development Team**. Instead of loose chat sessions, agents coordinate via a strict, JSON-backed state machine, enforcing clear handoffs, architectural consistency, and reproducible workflows.

## 🚀 Quickstart

### 1. Installation
Clone this repository to your preferred location:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

### 2. Configuration
Point your Gemini CLI to this configuration folder:

```bash
# Example (if supported by your CLI version)
gemini config set user_config_path $(pwd)/user-config
```

### 3. Workflow
Start the CLI and use the orchestrated commands:

```text
/refactor user_auth     # -> Creates task, delegates to Polyglot Expert
/analyze backend/api    # -> Snapshots architecture, scans for drift
/qa                     # -> Triggers batch review of completed tasks
```

---

## 🧠 Architecture (Structured Orchestration)

The system operates on a **State-First** principle. Agents do not guess; they read the Plan.

### 1. The Session Plan (`.gemini/SESSION_PLAN.json`)
The single source of truth. It tracks:
- **Tasks**: ID, Status, Priority, Dependencies.
- **Context Snapshots**: Hashes of critical context files to prevent hallucinations on stale code.
- **Agent Handoffs**: Who is holding the "conch".

### 2. The Agents (Skills)
| Role | Responsibility | Trigger |
| :--- | :--- | :--- |
| **Orchestrator** | **Session Manager**. Manages JSON state, dependency resolution, conflict detection, and Markdown syncing. | User Input / Plan Updates |
| **Polyglot Expert** | **Implementation**. Claims verified tasks. Enforces Python ↔ TypeScript contracts. **Blocks** if dependencies are open. | `assigned_to: polyglot-expert` |
| **QA Verifier** | **Gatekeeper**. Reviews code, security, and tests. Only passes valid work. Escalates priority if rejecting repeatedly. | `status: completed` |
| **Git Expert** | **release Manager**. Commits only `qa_passed` tasks. Enforces Conventional Commits. | `status: qa_passed` |
| **Tech Debt Tracker**| **Scanner**. Greps codebase for TODOs and logs them as low-priority tasks. | `status: pending` |

### 3. Task States
- `pending`: Ready to be claimed (if dependencies met).
- `blocked`: Waiting on dependencies.
- `blocked_conflict`: Targets overlapping files with another active task.
- `in_progress`: Currently being worked on.
- `completed`: Implementation done, awaiting QA.
- `qa_passed`: Verified, awaiting commit.
- `closed`: Committed and archived.

---

## 📂 Directory Structure

```text
gemini-config/
├── .gemini/                 # Local session state (Ignored by Git)
│   ├── SESSION_PLAN.json    # The Brain
│   └── SESSION_PLAN.md      # The Display (Read-Only)
├── scripts/
│   └── setup.sh             # Idempotent setup script
├── user-config/
│   ├── skills/              # Agent Logic (JSON-Aware)
│   │   ├── orchestrator/
│   │   ├── polyglot-expert/
│   │   ├── qa-verifier/
│   │   └── git-expert/
│   ├── commands/            # /refactor, /analyze, /qa
│   └── context/             # Static Knowledge Base
└── GEMINI_CONFIG_HIFI.md    # Detailed Architecture Spec
```

## 🛠️ Advanced Usage

### Conflict Handling
If two tasks target the same file, the **Orchestrator** will mark the lower-priority one as `blocked_conflict`.
- **Resolution**: Finish the active task first. The system will auto-resolve on the next cycle.

### Priority Escalation
Tasks left in `pending` for >2 cycles are automatically escalated (`low` -> `medium` -> `high`).
- **Override**: You can manually edit `SESSION_PLAN.json` to adjust priority if needed.

### Context Snapshots
Before any major operation (`/analyze` or `/refactor`), the Orchestrator snapshots `context/components/module-graph.md`.
- **Drift**: If the live code diverges from the snapshot, Agents will request a re-sync.

---

## 🤝 Contributing

1. **Fork** the repo.
2. **Setup**: Run `./scripts/setup.sh`.
3. **Commit**: Keep changes atomic.
4. **Push**: Submit PR to `main`.

**License**: MIT
