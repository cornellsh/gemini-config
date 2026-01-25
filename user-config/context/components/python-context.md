# Python Standards (Backend)

- **Type System**: Strong typing required (`mypy --strict`). All args/returns must be typed.
- **Async/Await**: Use `asyncio` for I/O. Avoid blocking calls in async paths.
- **Error Handling**: Custom exceptions defined in `core/exceptions.py`.
- **Testing**: `pytest` with `pytest-asyncio`.
