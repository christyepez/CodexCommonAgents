# Project Chat and Parallel Agent Execution Governance

## Scope

This rule applies when a new project or substantial implementation stream is created and multiple specialized agents can work independently.

## Project workspace convention

Create one ChatGPT Project or equivalent project folder/workspace for each software project when the product surface supports it.

The project workspace should use the same canonical project name as the source repository whenever practical.

Examples:

```text
AppColoreando
AppCondominio
CRM
PortalCorporativo
```

## Chat-per-agent model

Inside the project workspace, create a separate chat/thread for each active specialist agent or execution stream instead of mixing all work into one long execution chat.

Recommended baseline threads:

```text
00 - Project Orchestrator
01 - Architecture
02 - Backend
03 - Frontend
04 - Data and Persistence
05 - DevOps and Docker
06 - Security
07 - QA and Automated Tests
08 - Documentation
09 - Integration and Release
```

Only create threads that are useful for the project. Avoid empty or artificial parallelism.

## Orchestrator responsibilities

The `00 - Project Orchestrator` thread is the coordination authority. It maintains the implementation roadmap, dependencies, sprint/task state, shared decisions, integration order and blocking issues.

Specialist threads must not silently change cross-cutting contracts. Architecture, APIs, schemas, events, infrastructure contracts and release baselines that affect other streams must be surfaced to the orchestrator.

## Parallel execution policy

Agents should work in parallel when their tasks have independent file ownership or stable contracts.

Parallel work is encouraged for backend, frontend, tests, documentation, infrastructure and security analysis when dependencies are explicit.

Do not parallelize changes that would cause uncontrolled edits to the same files, migrations, shared schemas, central contracts or release manifests.

## Source-of-truth hierarchy

The source repository remains the authoritative implementation artifact. Chat threads coordinate work but are not a replacement for committed source, pull requests, ADRs, sprint documents or release metadata.

Each agent must continuously synchronize against the latest approved repository revision before starting a new task and before integration.

## Handoff contract

Each specialist thread must finish a task with a concise handoff containing:

```text
Agent:
Task/Story:
Base Revision:
Branch/PR:
Files Modified:
Contracts Changed:
Tests Executed:
Docker Images Published:
Dependencies/Blockers:
Ready for Integration: Yes/No
Next Recommended Task:
```

## Conflict prevention

The orchestrator should assign logical ownership before parallel execution. If two agents need the same high-conflict file or contract, serialize that portion of the work or establish the contract first.

## Completion rule

A task is not considered integrated only because an agent chat reports completion. Integration requires repository evidence: committed changes, successful validation, and when applicable merged PR, common Docker Hub image/digest and runtime verification.

## Product limitation

If the current ChatGPT surface does not allow programmatic creation of Projects, folders or chats, the agent must still maintain this organization as the recommended operating convention and provide the exact thread structure for the user to create or use. It must never claim a chat/folder was created when the available tools cannot create it.
