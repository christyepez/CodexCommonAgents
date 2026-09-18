# Code Intelligence Tools Registry

| Tool | Status | Scope | Installation | Notes |
|---|---|---|---|---|
| Graphify | STANDARD | Repository knowledge graph, architecture/dependency/impact analysis | `uv tool install "graphifyy[mcp,office,pdf,svg,leiden]"` | Official repo: `Graphify-Labs/graphify`; CLI package is `graphifyy`; command is `graphify` |
| Graphify Codex Skill | STANDARD | Codex project analysis | `graphify install --platform codex` | Codex invocation can use `$graphify` |
| Graphify Agent Skill | STANDARD | Cross-framework agent skill | `graphify install --platform agents` | Installs under the user-level `.agents/skills/graphify` location |
| Graphify MCP | AVAILABLE | MCP stdio integration | Included via `graphifyy[mcp]` | Use when a host requires direct MCP tool access |

## Governance

- Prefer Graphify for broad repository understanding before high-volume manual source scanning.
- Keep code parsing local-first.
- Validate inferred relationships against source.
- Do not commit generated `graphify-out/` artifacts unless explicitly governed by the project.
