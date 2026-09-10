# Playbook - GitHub Actions to Docker Desktop Development/Test

## Objective

Provide a standard delivery path in which GitHub controls source/review/automation, Docker Hub stores immutable shared images, and Docker Desktop on approved workstations executes development and test environments.

## Standard flow

```text
Developer / Agent
   -> branch / PR
   -> GitHub quality gates
   -> merge or approved revision
   -> GitHub Actions build
   -> Docker Hub immutable tag + digest
   -> docker compose pull
   -> Docker Desktop dev/test runtime
   -> smoke/health/integration validation
```

## Required preparation

Before creating a new workflow:

1. Read `rules/02-docker-runtime-and-image-governance.md`.
2. Read `rules/03-shared-infrastructure-reuse.md`.
3. Read `rules/06-ci-quality-gates.md`.
4. Read `rules/12-github-actions-delivery-and-docker-desktop-environments.md`.
5. Inspect existing workflows to avoid duplication.
6. Inspect the shared infrastructure registry before creating DB/RabbitMQ/Kafka/Redis instances.

## Workflow responsibilities

The project CI workflow should validate code first. Container publication must depend on successful validation.

Recommended jobs:

```text
validate
  -> build/test/lint/security/coverage/contracts

container
  -> login to Docker Hub
  -> setup buildx
  -> build
  -> push immutable SHA tag
  -> capture digest

release-metadata
  -> expose image refs/digests in job summary or release metadata
```

## Docker image naming

Default:

```text
christyepez/<project>-<service>:sha-<gitsha>
```

Examples:

```text
christyepez/appcoloreando-api:sha-a1b2c3d
christyepez/appcoloreando-worker:sha-a1b2c3d
```

Runtime should prefer the immutable digest resolved from the pushed tag.

## Docker Desktop consumption

On `trabajo` and `MarketingIndo`, prefer:

```powershell
docker compose -f docker-compose.yml -f docker-compose.hub.yml pull
docker compose -f docker-compose.yml -f docker-compose.hub.yml config
```

Recreate only required stateless application services. Do not recreate shared databases or persistent infrastructure merely to refresh application images.

For an application-only update, use service-scoped commands and `--no-deps` when safe and compatible with the project topology.

## Environment classification

Docker Desktop environments are currently classified as:

```text
DEV  = active implementation/debugging
TEST = integration/smoke/acceptance validation
```

A single workstation may host both roles, but names, Compose projects and configuration must make the intended environment clear.

## Validation

After refresh:

```text
expected image digest == running container image digest
health == healthy/expected
required ports reachable
application smoke tests PASS
API smoke tests PASS
no unexpected database recreation
no unexpected volume deletion
```

When both workstations are in the same logical test baseline, compare their custom application image digests.

## Rollback

Rollback must use the previously approved immutable Docker Hub tag/digest. Do not rebuild an old revision locally as the primary rollback mechanism.

Stateful schema/data rollback follows the data/migration governance rule and must not be inferred from container rollback.

## Completion output

```text
Source Revision:
PR/Merge:
CI Validation:
Docker Workflow:
Published Images:
Published Digests:
DEV Runtime:
TEST Runtime:
trabajo Status:
MarketingIndo Status:
Shared Infrastructure Reused:
Persistent Data Preserved:
Smoke Tests:
Rollback Reference:
Risks:
Next Step:
```
