# Structured Gemini Configuration

This repository provides a multi-agent orchestration framework for the Gemini CLI. It enables a team of 10 specialized senior agents to coordinate complex tasks through a central state machine.

## Quickstart

Run the setup script to initialize the environment:

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

## Architecture

The system uses a state-first approach governed by a central plan and the OpenSpec protocol.

### Session Plan
- Location: `.gemini/SESSION_PLAN.json`
- Function: Machine-readable truth for task status, dependencies, and code snapshots.
- Human View: A read-only markdown projection is maintained at `.gemini/SESSION_PLAN.md`.

### The Team (Senior Agents)
- Orchestrator: Roadmap, state governance, and dispatch.
- Product Strategist: Technical intent and OpenSpec drafting.
- Polyglot Expert: Python/TypeScript implementation.
- Database Architect: Schema migrations and integrity.
- Browser Specialist: UI diagnostics and CDP telemetry.
- SRE/Infra Engineer: Atomic releases and stability.
- QA Auditor: Active verification and security scanning.
- DX Engineer: Tooling and environment readiness.
- Knowledge Architect: Technical documentation and manuals.
- Debt Architect: Performance and scalability refactoring.

## Phase-Driven Workflows

The CLI is organized into professional project phases:

- `/propose <intent>`: Draft a technical spec and scenarios.
- `/build <target>`: Execute implementation across logic and data layers.
- `/audit <target>`: Perform health, security, and complexity scans.
- `/debug <context>`: Investigate and resolve UI or logic failures.
- `/ship`: Commit verified work, archive changes, and update docs.
- `/sync`: Pre-flight tools, environment, and memory.
- `/status`: View roadmap bottlenecks and next steps.

## Safety and Governance

- Policies: Access controls in `user-config/policies/` prevent unauthorized destructive actions.
- Hooks: Automated interceptors in `user-config/hooks/` record tool usage for auditing.
- Memory: High-level architectural axioms are persisted using the `save_memory` tool.
