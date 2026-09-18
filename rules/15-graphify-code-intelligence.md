# 15 - Graphify Code Intelligence

## Objective

Use a repository knowledge graph as the default first-pass mechanism for broad codebase understanding while preserving source code as the final authority.

## Standard

The common code-intelligence tool is the official `Graphify-Labs/graphify` project.

Installation baseline on Windows:

```powershell
winget install --id astral-sh.uv -e
uv tool install "graphifyy[mcp,office,pdf,svg,leiden]"
graphify install --platform codex
graphify install --platform agents
```

Codex parallel extraction requires:

```toml
[features]
multi_agent = true
```

## Mandatory-use cases

Use Graphify before a large manual repository scan when the task involves one or more of the following:

- AS-IS architecture discovery.
- Dependency or impact analysis.
- Cross-layer flow tracing.
- Large refactors.
- Identifying coupling or hotspots.
- Understanding an unfamiliar repository.
- Locating likely test gaps around a component.
- Mapping integration boundaries.
- Preparing C4, HLD, LLD or architecture documentation from the actual codebase.

## Rules

1. Reuse a current graph when possible instead of rebuilding it for every question.
2. Refresh the graph after structural changes that materially alter dependencies.
3. Prefer `graphify query`, `graphify explain`, and `graphify path` before broad grep/read loops.
4. Treat `EXTRACTED` relationships as explicit source evidence and `INFERRED` relationships as hypotheses to validate.
5. Source code, configuration, tests and runtime behavior remain authoritative.
6. Do not commit `graphify-out/` by default. Commit generated graph artifacts only when a project explicitly requires them as governed documentation.
7. Do not expose secrets, local credentials, private tokens or sensitive generated artifacts through graph outputs.
8. For private repositories, keep local-first analysis as the default. Semantic processing of non-code assets must follow the project's data-handling policy.
9. Do not use Graphify as a substitute for build, tests, static analysis, security scans or quality gates.
10. Record the Graphify version used when graph-derived findings materially influence an architecture or refactor decision.

## Expected project convention

Projects governed by CodexCommonAgents should ignore ephemeral output by default:

```gitignore
graphify-out/
```

A repository may override this only when graph artifacts are intentionally versioned.
