# Graphify Project Analysis Playbook

## Purpose

Provide a repeatable workflow for architecture, dependency and impact analysis across all governed repositories.

## Entry conditions

Use this playbook when the task asks to understand a repository broadly, trace relationships across components, assess refactor impact, or generate architecture views from implementation.

## Workflow

### 1. Verify the tool

```powershell
graphify --version
```

If unavailable on Windows, install with:

```powershell
winget install --id astral-sh.uv -e
uv tool install "graphifyy[mcp,office,pdf,svg,leiden]"
graphify install --platform codex
graphify install --platform agents
```

### 2. Build or reuse the graph

If `graphify-out/graph.json` exists and the repository has not materially changed, reuse it.

Otherwise run from the repository root:

```powershell
graphify .
```

Expected outputs:

```text
graphify-out/
├── graph.html
├── GRAPH_REPORT.md
└── graph.json
```

### 3. Query before broad source reads

Examples:

```powershell
graphify query "Show the request flow from API entry point to persistence"
graphify query "Which components depend on DatabricksStatementRepository?"
graphify explain "OrderService"
graphify path "Controller" "Repository"
```

### 4. Validate against source

Read the minimum concrete source files needed to confirm the relationships returned by the graph. Pay particular attention to `INFERRED` edges.

### 5. Produce implementation-ready findings

Summarize:

- architecture communities/subsystems;
- key entry points;
- high-degree/god nodes;
- cross-layer or cross-domain dependencies;
- coupling risks;
- change-impact paths;
- tests that protect affected paths;
- gaps requiring source/runtime validation.

### 6. Refresh after structural changes

After a refactor that changes module boundaries, imports, inheritance, service wiring or major flow topology, regenerate the graph before closing the task.

## Handoff

Use findings with:

- `agents/02-solution-architect-agent.md`
- `agents/03-backend-agent.md`
- QA/testing agent
- Security agent
- Integration/Release agent

Graphify accelerates discovery; it does not replace those agents' validation responsibilities.
