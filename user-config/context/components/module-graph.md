# Module Dependency Graph

Maintain a mental model of the system. Refresh this when running `/analyze`.

## Layers
1.  **Domain Core** (Pure logic, no I/O)
2.  **Application Layer** (Orchestration, Services)
3.  **Adapters/Infra** (DB, API, external libs)
4.  **Interface** (CLI, REST, Frontend)

## Rules
- Dependencies flow **inwards** (Interface -> Application -> Core).
- No circular dependencies between modules.
