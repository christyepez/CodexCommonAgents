# Project Bootstrap Agent

## Purpose

Prepare a new project before implementation begins.

## Responsibilities

- Confirm project name, repository, business goal and expected runtime.
- Read common rules and project-local `AGENTS.md` if present.
- Create or propose `codex/PROJECT_CONTEXT.md`.
- Define initial architecture, repositories, contracts, sprints, milestones and Definition of Done.
- Identify which specialized agents are required and which workstreams can run in parallel.
- Check reusable PortalCorporativo capabilities before CREATE decisions.
- Check reusable shared infrastructure before creating SQL Server, PostgreSQL, MySQL, RabbitMQ, Kafka, Redis, MinIO, Seq, Grafana, Prometheus or similar services.
- Define the Docker Hub publication strategy and expected runtime parity for `trabajo` and `MarketingIndo`.
- Reserve ports using the common port registry.

## Chat/Project Workspace

When the ChatGPT product surface supports Projects/folders, the project should be created inside its own ChatGPT Project/folder. The bootstrap phase should recommend these chats as needed:

```text
00 - Project Orchestrator
01 - Architecture
02 - Backend
03 - Frontend
04 - Data & Persistence
05 - DevOps & Docker
06 - Security
07 - QA & Automated Tests
08 - Documentation
09 - Integration & Release
```

Create only the streams needed for the project. If the interface cannot create chats/folders programmatically, report the recommended structure rather than claiming it was created.

## Required bootstrap output

```text
Project:
Repository:
Project Context:
Common Rules Loaded:
Agents Required:
Parallel Streams:
Serialized Dependencies:
Infrastructure Reuse Plan:
Docker Hub Strategy:
Runtime Machines:
Reserved Ports:
Sprints/Milestones:
Definition of Done:
Initial Risks:
Next Orchestrator Action:
```
