# Parallel Project Execution Playbook

## Goal

Coordinate multiple specialist agents in parallel while keeping repository integration deterministic and auditable.

## Startup

1. Create or select the canonical ChatGPT Project/workspace for the software project. If it does not exist and creation is unavailable programmatically, set state `WORKSPACE-PENDING` and provide the exact manual creation action before dispatching new specialist threads.
2. Open or create `00 - Project Orchestrator` inside that workspace as the coordination thread.
3. Read the project `AGENTS.md`, current sprint/roadmap, architecture decisions and common-agent rules.
4. Split the backlog into independent work packets with explicit dependencies and file/contract ownership.
5. Create only the specialist threads needed for the current phase, always inside the same project workspace and using stable numeric prefixes.
6. For an existing unsorted project, inventory legacy chats and normalize them into the canonical workspace before creating duplicate streams.

## Recommended execution waves

### Wave A - contracts and foundations

Architecture, domain model, API/event contracts, persistence strategy, security boundaries and infrastructure reuse decisions.

### Wave B - parallel implementation

Backend, frontend, data, DevOps/Docker, automated tests and documentation may proceed concurrently when contracts are stable.

### Wave C - integration

Merge or reconcile branches in dependency order. Resolve cross-stream contract changes before runtime deployment.

### Wave D - release validation

Run full tests, security checks, Docker Hub publication, digest verification on active workstations, health checks and smoke tests.

## Branch convention

Prefer one branch per task/story or tightly related work packet. Avoid multiple agents committing unrelated work directly to the same shared branch.

Example:

```text
feature/S14-backend-lead-scoring
feature/S14-ui-lead-scoring
feature/S14-security-hardening
feature/S14-docker-runtime
```

## Dependency states

```text
READY     = contracts stable; agent can start.
BLOCKED   = dependency or decision unresolved.
PARALLEL  = safe to execute concurrently.
SERIAL    = must wait because of shared high-conflict artifact.
INTEGRATE = implementation complete and ready for merge validation.
DONE      = merged and validated in shared runtime.
```

## Orchestrator board

The orchestrator should maintain a compact table containing task/story, assigned agent/thread, dependency, branch/PR, state and integration order.

## Docker handoff

When a thread creates a project-owned image, it must publish the immutable image to Docker Hub, report the remote digest and make it available to the active implementation machines. Local-only Docker images are not a completed handoff.

## Infrastructure handoff

Before adding SQL Server, PostgreSQL, MySQL, Redis, RabbitMQ, Kafka, MinIO or similar infrastructure, the responsible agent must check the common infrastructure registry and active Docker runtimes for a compatible reusable service.

## Integration gate

The orchestrator may mark a story `DONE` only after repository integration and applicable tests pass. For containerized services, also confirm expected Docker Hub digest and healthy execution on the selected workstation(s).
