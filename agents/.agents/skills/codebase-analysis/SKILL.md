---
name: codebase-analysis
description: Use when analyzing a codebase's overall architecture, module responsibilities, interfaces, call relationships, and design tradeoffs.
---

# Codebase Analysis

## Reading

Use **LSP** as the primary exploration tool whenever it is available.

Common language servers include:

- **C/C++** — `clangd`; use `compile_commands.json` for project compilation settings when available.
- **Rust** — `rust-analyzer`.
- **Python** — `Pyright` or `python-lsp-server`.

Use these capabilities to explore the repository:

- `workspaceSymbol` — discover symbols across the repo by keyword
- `documentSymbol` — list all symbols in a file before reading it
- `incomingCalls` / `outgoingCalls` — trace call chains between modules
- `findReferences` — find all usages of a symbol

## Understanding

First build a basic understanding of the complete framework: its purpose, major components, and how they interact.

Then distinguish upstream framework code from team-customized code. Then focus on the custom layer:

- Which framework extension points are implemented, and how
- What features were added beyond the framework baseline
- How custom modules interact with each other and with the framework

## Output

Start with an **architecture overview** that covers the following views before diving into individual components:

- **Component view**: major modules, their responsibilities, and dependencies
- **Runtime view**: execution sequences, initialization order, control flow across components
- **Interface view**: APIs, protocols, and contracts exposed to other layers
- **Trust / security boundary view**: privilege levels, isolation boundaries, what each layer can and cannot access
- **Physical / deployment view**: memory layout, hardware mapping, what runs where

For each functional component, suggest to describe:

1. **Capability** — what it provides to the rest of the system
2. **Mechanism** — key design decisions and how it works
3. **Interfaces** — connections to other components or external consumers
