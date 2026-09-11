# Playbook - GitHub Actions to Docker Desktop Development/Test

## Objective

Provide a standard delivery path in which GitHub controls source/review/automation, GHCR stores immutable private shared images, and Docker Desktop on approved workstations executes development and test environments.

## Standard flow

```text
Developer / Agent
   -> branch / PR
   -> GitHub quality gates
   -> merge or approved revision
   -> GitHub Actions build
   -> GHCR PRIVATE immutable tag + digest
   -> docker compose pull
   -> Docker Desktop DEV/TEST runtime
   -> smoke/health/integration validation
```

## Required preparation

Before creating or changing a workflow:

1. Read `rules/02-docker-runtime-and-image-governance.md`.
2. Read `rules/03-shared-infrastructure-reuse.md`.
3. Read `rules/06-ci-quality-gates.md`.
4. Read `rules/12-github-actions-delivery-and-docker-desktop-environments.md`.
5. Read `rules/14-ghcr-private-registry.md`.
6. Inspect existing workflows to avoid duplication.
7. Inspect the shared infrastructure registry before creating DB/RabbitMQ/Kafka/Redis instances.

## Workflow responsibilities

The project CI workflow should validate code first. Container publication must depend on successful validation.

Recommended jobs:

```text
validate
  -> build/test/lint/security/coverage/contracts

container
  -> login to ghcr.io with GITHUB_TOKEN
  -> setup buildx
  -> build
  -> push immutable SHA tag
  -> capture digest
  -> generate SBOM/provenance

release-metadata
  -> expose image refs/digests/visibility status
```

## Image naming

Default:

```text
ghcr.io/christyepez/<project>-<service>:sha-<gitsha>
```

Examples:

```text
ghcr.io/christyepez/appcoloreando-api:sha-a1b2c3d
ghcr.io/christyepez/appcoloreando-worker:sha-a1b2c3d
```

Runtime should prefer the immutable digest resolved from the pushed tag.

## Package visibility

The expected visibility is `PRIVATE`.

If visibility cannot be programmatically verified, report `NOT-VERIFIED` and complete the package-level verification before release closure.

Public visibility is allowed only by explicit documented exception.

## Docker Desktop consumption

On `trabajo` and `MarketingIndo`, authenticate to `ghcr.io` using a least-privilege token stored in Docker's credential store, then prefer:

```powershell
docker compose -f docker-compose.yml -f docker-compose.ghcr.yml pull
docker compose -f docker-compose.yml -f docker-compose.ghcr.yml config
```

Legacy projects may temporarily keep `docker-compose.hub.yml` while migrating.

Recreate only required stateless application services. Do not recreate shared databases or persistent infrastructure merely to refresh application images.

For an application-only update, use service-scoped commands and `--no-deps` when safe and compatible with the project topology.

## Environment classification

```text
DEV  = active implementation/debugging
TEST = integration/smoke/acceptance validation
```

A single workstation may host both roles, but names, Compose projects and configuration must make the intended environment clear.

## Validation

After refresh:

```text
expected image digest == running container image digest
package visibility == PRIVATE or approved exception
health == healthy/expected
required ports reachable
application smoke tests PASS
API smoke tests PASS
no unexpected database recreation
no unexpected volume deletion
```

When both workstations are in the same logical test baseline, compare their custom application image digests.

## Docker Hub migration

For existing Docker Hub images:

1. Identify the approved source revision and current exact image digest.
2. Build/publish that approved revision to private GHCR.
3. Record the GHCR digest.
4. Update registry-backed Compose references.
5. Validate DEV and TEST without touching persistent data unnecessarily.
6. Keep Docker Hub as rollback/recovery until GHCR runtime is proven.
7. Only then retire obsolete Docker Hub copies when authorized and recoverability is proven.

## Rollback

Rollback must use the previously approved immutable GHCR tag/digest. Do not rebuild an old revision locally as the primary rollback mechanism.

Stateful schema/data rollback follows the data/migration governance rule and must not be inferred from container rollback.

## Completion output

```text
Source Revision:
PR/Merge:
CI Validation:
Container Workflow:
Registry:
Registry Visibility:
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
