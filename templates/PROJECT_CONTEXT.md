# PROJECT_CONTEXT.md

## Project Identity

- Project Name:
- Repository:
- Business Domain:
- Product Owner / Requester:
- Default Branch:
- Current Phase / Sprint:

## Objective

Describe the business objective, expected outcomes and current implementation scope.

## Architecture Baseline

- Backend stack:
- Frontend stack:
- Data stack:
- Integration pattern:
- Authentication / Authorization:
- Observability:
- Deployment target:

## Shared Capabilities / Reuse

Before creating new components, record PortalCorporativo and shared-infrastructure reuse decisions.

| Capability | Existing Option | Decision | Isolation / Adaptation |
|---|---|---|---|
| Identity | | REUSE / EXTEND / ADAPT / CREATE / BLOCKED | |
| Database runtime | | REUSE / CREATE | DB/schema/user per project |
| RabbitMQ | | REUSE / CREATE | vhost/user/permissions |
| Kafka | | REUSE / CREATE | topics/ACLs/consumer groups |
| Redis | | REUSE / CREATE | namespace/db/key prefix |

## Docker / Runtime

- Docker Hub namespace: `christyepez/*` unless overridden.
- Runtime machines: `trabajo`, `MarketingIndo`.
- Project-owned images must be published with immutable tags.
- Prefer digest-pinned runtime compose for cross-machine parity.
- Docker Desktop is local execution/cache only.

## Ports

Record requested ports and validate against `registry/docker-port-registry.md` before allocation.

## Agent / Thread Plan

- `00 - Project Orchestrator`
- `01 - Architecture`
- `02 - Backend`
- `03 - Frontend`
- `04 - Data & Persistence`
- `05 - DevOps & Docker`
- `06 - Security`
- `07 - QA & Automated Tests`
- `08 - Documentation`
- `09 - Integration & Release`

Create only the threads required by this project.

## Delivery Waves

- Wave A: architecture, contracts, security boundaries, infrastructure reuse.
- Wave B: parallel implementation streams.
- Wave C: integration and conflict resolution.
- Wave D: full validation, Docker Hub publication, runtime parity and release.

## Definition of Done

A task is DONE only when repository evidence, tests, contracts, required Docker publication, runtime validation and integration status all agree.

## Risks / Constraints

- 

## Current Decisions

- 

## Next Milestone

- 
