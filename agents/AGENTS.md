## Working Agreements

- Never invoke raw Python directly with `python`, `python3`, or versioned Python binaries. Use `uv run` for Python scripts and one-off Python commands.
- Use `uvx` when running Python-based tools that do not belong in the current project environment.
- When a standalone Python script needs dependencies, prefer PEP 723 inline script metadata so `uv run script.py` can resolve them reproducibly.
