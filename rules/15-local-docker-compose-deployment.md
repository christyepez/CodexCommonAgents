# Local Docker Compose Deployment Policy

## Scope and precedence

All projects governed by CodexCommonAgents deploy locally with Docker Compose by default. This rule takes precedence over delivery rules/playbooks that imply hosted CI or cloud runtime deployment is mandatory. It does not bypass project-required quality gates or approval controls.

## Runtime destination

- Use Docker Compose v2 on the user-approved local workstation (Docker Desktop or compatible Docker Engine).
- Do not provision or deploy to cloud hosting, managed runtime, remote clusters or public services without an explicit user request for that destination.
- Existing cloud configuration is not authorization to deploy there. Do not delete or disable it merely because the default changed.
- Never change billing, spending limits or enable paid resources without explicit authorization.
- Expose infrastructure/admin ports on localhost by default; broader access requires a documented requirement.

## CI and artifact distribution are separate

GitHub Actions is optional automation for validation and private image publication, not a required runtime destination. Publishing an image to an approved private registry does not deploy an application in the cloud.

A hosted runner billing/quota failure means NOT RUN / BLOCKED, not a failed build and not PASS. Execute equivalent authorized local gates and record revision, commands and results. Do not disable required branch checks or claim a release approved; documented project exceptions still govern integration.

A single-workstation candidate may be built locally from a recorded revision, tagged immutably and identified by image ID. Report it as LOCAL CANDIDATE, not a canonical shared artifact. Multi-machine/reusable delivery still requires approved private registry publication, known remote digests and parity under rules/02 and rules/14. If publication is unavailable, report shared delivery pending without blocking unrelated local validation.

## Deployment owner

The Integration Release Agent owns the deployment handoff; the Project Orchestrator verifies the destination and evidence. Domain agents must follow this policy and must not independently choose cloud hosting.

## Local acceptance

1. Read project instructions, Compose manifests and infrastructure/port registries.
2. Confirm the authorized workstation, environment, revision and services in scope.
3. Inspect existing containers, ports and volumes; reuse compatible infrastructure with logical isolation.
4. Run applicable build, unit, integration, security and contract gates.
5. Validate the effective configuration with docker compose config without exposing interpolated secrets in reports.
6. Build a recorded local candidate or pull an approved immutable private image; record image IDs/digests.
7. Apply only the necessary Compose service changes. Preserve databases, queues and volumes; no down -v or broad pruning.
8. Validate health, logs, readiness and smoke tests; record rollback image/configuration.
9. Keep scheduled ingestion, external writes and production activation disabled until their specific acceptance/authorization requirements are satisfied.

If the target workstation or Docker daemon is unavailable, provide the project-specific commands and report runtime validation PENDING. Never claim a local deployment was executed remotely.

## Definition of Done

Local deployment requires configuration validation, applicable gates PASS, authorized Compose runtime healthy, smoke tests PASS, persistent data preserved and rollback recorded. Shared delivery additionally requires registry/privacy/digest evidence. Critical activation requires explicit approval. Local runtime success does not close unavailable Power BI Desktop, private-data reconciliation or other project-specific acceptance gates.
