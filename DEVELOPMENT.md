# Developer Guide: Structured Gemini Configuration

This document explains the internal architecture of this configuration to enable maintenance using AI agents.

## System Architecture

The configuration operates as a JSON-backed state machine. 

1.  **State**: .gemini/SESSION_PLAN.json is the single source of truth. It tracks tasks, dependencies, and context snapshots.
2.  **Projection**: .gemini/SESSION_PLAN.md is a read-only markdown view for humans.
3.  **Agents**: 10 specialized skills in user-config/skills/ perform atomic state transitions.
4.  **Handoffs**: Agents signal completion by updating the JSON state and triggering the next logical skill via the Signal-Driven Handoff Protocol.

## The Static Roster

The team is fixed at 10 senior roles. Do not attempt to add or modify agents at runtime, as the Gemini CLI only discovers skills during initial setup.

1.  **Orchestrator**: Architecture and State.
2.  **Product Strategist**: Intent and Specs.
3.  **Polyglot Expert**: Core Logic (PY/TS).
4.  **Database Architect**: Storage and Migrations.
5.  **Browser Expert**: UI and CDP Debugging.
6.  **Git Expert**: SRE, Infra, and Releases.
7.  **QA Verifier**: Active Testing.
8.  **DX Engineer**: Tooling and Setup.
9.  **Knowledge Architect**: Documentation.
10. **Debt Architect**: Performance and Refactoring.

## Maintenance Protocol

When upgrading this configuration:
1.  **Read the Plan**: Always check .gemini/SESSION_PLAN.json to understand the current work-in-progress.
2.  **Snapshot First**: Use the Orchestrator to update code hashes before making systemic changes.
3.  **Validate**: Run scripts/setup.sh after changes to ensure symlinks and permissions are intact.