# Docker Runtime and Image Governance

## Scope

This rule applies to every project that uses Docker, Docker Compose or a container registry.

## Multi-machine baseline

Local environments such as `trabajo`, `MarketingIndo` or any additional workstation must run the same application image version when they represent the same logical environment.

Application services must not depend on independently-built mutable local images as the shared baseline.

## Required image strategy

For project-owned services:

1. Build once from the approved source revision.
2. Publish the image to the approved registry, normally Docker Hub under `christyepez/*` unless the project defines another registry.
3. Tag each release with an immutable revision-oriented tag such as the Git commit SHA.
4. Prefer pinning runtime Compose files by digest (`repository@sha256:...`) when reproducibility between machines is required.
5. `latest` may exist as a convenience alias, but it must not be the only reference used for reproducible environments.
6. Before deleting a local project-owned image, verify an exact recoverable remote copy exists. If exact recovery is not proven, push an immutable backup tag first.

## Compose contract

Projects using Docker Compose should separate source-build and registry-runtime concerns:

- `docker-compose.yml`: canonical service topology and local-development defaults.
- `docker-compose.hub.yml` or equivalent: override project-owned `build:` entries with registry `image:` references and set `build: null`.
- `.env` or generated local override files must not be committed when they contain secrets.
- Runtime image variables should be explicit and fail fast when missing.

## Port exposure

Infrastructure and administrative services should bind to `127.0.0.1` by default unless LAN/external access is an explicit requirement.

Examples include SQL Server, PostgreSQL, Redis, RabbitMQ management, MinIO console, Grafana, Prometheus, Seq and similar tools.

Application web/API ports may bind more broadly only when the project actually requires access from another host.

## Persistence safety

Container cleanup must never imply data cleanup.

- Do not delete named database or persistent-data volumes during routine maintenance.
- Do not use `docker system prune -a --volumes` as a default cleanup mechanism.
- Classify volumes before deletion.
- Preserve database containers and volumes unless the user explicitly authorizes their removal.

## Restart and health policy

Long-running application/runtime services should normally define health checks where practical.

Use `restart: unless-stopped` for services intended to remain available across Docker/Desktop restarts. Keep one-shot migration/init jobs at `restart: "no"`.

## Cleanup policy

Before removing containers or images:

1. Detect whether they are referenced by running or stopped containers.
2. Preserve project-linked stopped containers unless explicitly classified as recreable/obsolete.
3. Remove only clearly recreable helper containers without separate approval.
4. Verify remote recoverability before deleting project-owned images.
5. Never remove databases or persistent volumes implicitly.

## Validation required

After any Docker/Compose change, run at minimum:

```text
docker compose config
docker ps -a
docker system df
```

When a stack is recreated, validate health, ports and expected image IDs/digests.

## Expected Codex behavior

For Docker-related work Codex must report:

```text
Runtime Machine(s):
Compose Files Read:
Images Compared:
Registry Recoverability Checked:
Digests Pinned:
Ports Exposed:
Persistent Volumes Preserved:
Containers Recreated:
Health Validation:
Cleanup Performed:
Risks:
Next Step:
```
