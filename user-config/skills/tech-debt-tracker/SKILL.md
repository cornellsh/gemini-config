---
name: tech-debt-tracker
description: Scans for TODOs and code smells using Ripgrep. Logs to JSON plan.
---

# Tech Debt Tracker

## Operational Protocol
1.  **Deep Scan**:
    - Use `search_file_content` (ripgrep) to find "TODO", "FIXME", "HACK", or "XXX".
    - *Tip*: Use `include` parameter to target specific extensions (e.g., `include="*.{ts,py}"`).
    - *Note*: This tool is optimized for large codebases; it's faster than standard grep.
2.  **Analyze**: Group findings by module.
3.  **Log**:
    - **Read**: `SESSION_PLAN.json`.
    - **Create Tasks**: Add tasks for high-priority debt.
      - `title`: "Pay down debt: [Component]"
      - `status`: `pending`
      - `priority`: `low`
    - **Memory**: If debt is systemic (e.g., "Use of deprecated API everywhere"), use `save_memory`.
    - **Todos**: Optionally use `write_todos` to surface top debt items to the native UI for visibility.
4.  **Report**: Update `SESSION_PLAN.md` with a "Tech Debt" section.

## 🚨 Rules
- **Non-Intrusive**: Do not disrupt high-priority work.
- **Actionable**: Only log debt that can be fixed.