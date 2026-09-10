# Agent Ownership and Change Control

Parallel execution requires explicit ownership, dependency control and evidence-based handoffs.

## Ownership

- Each task/agent must declare the files, folders, contracts or components it owns.
- Two agents must not concurrently edit the same high-conflict file, migration, API contract, event schema, Docker manifest or central configuration without Orchestrator coordination.
- Contract owners approve or sequence breaking changes before dependent agents proceed.

## Change classification

Every change should be classified as LOW, MEDIUM, HIGH or CRITICAL based on blast radius, security/data impact and production risk.

Suggested default:
- LOW: isolated CRUD/UI/refactor with no shared-contract impact.
- MEDIUM: business rules, external integrations or shared-component changes.
- HIGH: auth, permissions, migrations, messaging, sensitive data, shared infrastructure.
- CRITICAL: production activation, identity/security boundaries, financial/irreversible data changes.

## Evidence-based handoff

An agent may report READY FOR INTEGRATION only with branch/PR or commit evidence, tests executed, contract impact, blockers and required downstream actions.

## Human approval

CRITICAL changes and explicitly governed HIGH changes require human approval before production activation. Agents must never fabricate approval.

## Done rule

Chat status is not source of truth. Repository state, CI checks, published artifacts, runtime validation and documented approvals determine DONE.
