# TypeScript Standards (Frontend/Edge)

- **Strictness**: `strict: true` in tsconfig. No `any`.
- **Paradigms**: Functional preference. Immutability by default (`readonly`, `const`).
- **Async**: `async/await` only. No `.then()` chains.
- **Validation**: `zod` for runtime boundary validation.
