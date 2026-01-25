---
name: tech-debt-tracker
description: Scans for TODOs, FIXMEs, and code smells. Logs tasks to SESSION_PLAN.json.
---

# Tech Debt Tracker

## Operational Protocol
1.  **Scan**: Use `grep` or `search_file_content` to find "TODO", "FIXME", or specific code smells.
2.  **Analyze**: Group findings by module/component.
3.  **Log**:
    - **Read**: `.gemini/SESSION_PLAN.json`.
    - **Create Tasks**: For high-priority debt, add new tasks to JSON.
      - `title`: "Pay down debt: [Component]"
      - `assigned_to`: "polyglot-expert"
      - `priority`: "low" (default) or "medium".
    - **Sync**: Re-generate `.gemini/SESSION_PLAN.md`.
4.  **Report**: Output a summary of debt added to the plan.