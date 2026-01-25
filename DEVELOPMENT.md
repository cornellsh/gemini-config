# Developer Guide: Structured Gemini Configuration

This document explains the internal architecture of this configuration to enable continuous development and maintenance using AI agents.

## System Architecture

The configuration operates as a **JSON-backed state machine**. 

1.  **State**: `.gemini/SESSION_PLAN.json` is the single source of truth. It tracks tasks, dependencies, and context snapshots.
2.  **Projection**: `.gemini/SESSION_PLAN.md` is a read-only markdown view for humans.
3.  **Agents**: Specialized skills in `user-config/skills/` perform atomic state transitions (e.g., moving a task from `pending` to `in_progress`).
4.  **Handoffs**: Agents signal completion by updating the JSON state and triggering the next logical skill via natural language or command injection.

## State Schema (v1.2)

When modifying the state, adhere to this structure:

```json
{
  "version": "1.2",
  "tasks": [
    {
      "id": "uuid",
      "title": "Task description",
      "status": "pending | in_progress | completed | qa_passed | blocked | closed",
      "assigned_to": "skill-name",
      "priority": "low | medium | high",
      "dependencies": ["uuid-of-parent"],
      "target_files": ["path/to/file"]
    }
  ],
  "context_snapshots": {
    "module_graph": { "hash": "sha256", "updated_at": "ISO8601" }
  },
  "tool_state": { "mcp_servers": "connected | disconnected" },
  "hook_events": [],
  "policy_events": []
}
```

## Team Evolution (The Skill Forge)

The configuration is self-expanding. If the team lacks a specific capability (e.g., a "Mobile Specialist" or "Cloud Security Engineer"), the Lead Architect follows the Forge Protocol:

1.  **Analyze**: Determine the necessary Persona and Rules for the new domain.
2.  **Generate**: Create a new folder in `user-config/skills/` with a `SKILL.md` file.
3.  **Register**: The new agent must be BMAD-aligned (Persona, Knowledge, Rules, Workflow).
4.  **Provision**: Run `scripts/setup.sh` to symlink the new capability into the global environment.

Once forged, the new specialist is "unlocked" and can participate in the orchestration loop.

### Adding a Command
1.  Create a `.toml` file in `user-config/commands/`.
2.  Define the `prompt` to activate the **Orchestrator** skill first. 
3.  Instruct the Orchestrator to create a task in the JSON plan before proceeding.

### Adding a Policy
1.  Create a `.toml` file in `user-config/policies/`.
2.  Use `toolName`, `commandPrefix`, or `commandRegex` to match calls.
3.  Assign a `priority` (100+ for user rules).

### Adding a Hook
1.  Write a script (Bash or JS) in `user-config/hooks/`.
2.  Logs/messages MUST go to `stderr`.
3.  The final result MUST be a JSON object printed to `stdout` (e.g., `{"decision": "allow"}`).
4.  Register the hook in `user-config/settings.json` under the `hooks` object.

## Maintenance Protocol

When upgrading this configuration:
1.  **Read the Plan**: Always check `.gemini/SESSION_PLAN.json` to understand the current work-in-progress.
2.  **Snapshot First**: Use the Orchestrator to update code hashes before making systemic changes.
3.  **Self-Heal**: Ensure the Orchestrator skill maintains its "Autonomous Initialization" logic to bootstrap new environments.
4.  **Validate**: Run `scripts/setup.sh` after changes to ensure symlinks and permissions are intact.
