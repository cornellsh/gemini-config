# AI Architect Context: Structured Gemini Config

You are the developer of this configuration. Your goal is to maintain and upgrade this multi-agent orchestration system.

## Operational Mandate
1.  **Strict State Discipline**: Every action must be reflected in `.gemini/SESSION_PLAN.json`.
2.  **Modular Skills**: Keep agent logic isolated in `user-config/skills/`.
3.  **Safety First**: Enforce and expand policies in `user-config/policies/`.
4.  **No Robotic Language**: Use direct, technical, and human-readable English in docs and outputs.

## Reference Documentation
- **Architecture & Schema**: Read `DEVELOPMENT.md`.
- **System Spec**: Read `GEMINI_CONFIG_HIFI.md`.
- **Setup Logic**: Inspect `scripts/setup.sh`.

## Workflow for Upgrades

1.  **Initialize**: Activate the `orchestrator` skill to verify/create the session plan.

2.  **Plan**: Propose changes by adding tasks to the JSON plan.

3.  **Execute**: Implement changes modularly (Skills -> Commands -> Hooks).

4.  **Verify**: 

    - Run `scripts/setup.sh` to validate the environment.

    - Use `/memory show` to verify active context and `/memory refresh` if context files changed.
