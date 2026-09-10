# Docker Runtime and Image Governance

## Scope

This rule applies to every project that uses Docker, Docker Compose or a container registry.

## Multi-machine baseline

Local environments such as `trabajo`, `MarketingIndo` or any additional workstation must run the same application image version when they represent the same logical environment.

Application services must not depend on independently-built mutable local images as the shared baseline.

For the current implementation baseline, `trabajo` and `MarketingIndo` are the primary execution workstations and must be able to recreate project runtimes from the shared registry without depending on a build that only exists on one machine.

## Mandatory Docker Hub publication

Every project-owned Docker image created for implementation, testing, integration or reusable runtime execution must be published to Docker Hub before it is considered a shared or reusable implementation artifact.

The default target is the approved `christyepez/*` Docker Hub namespace unless a project explicitly defines another approved registry.

A Docker image that exists only in Docker Desktop or only in the local image cache of `trabajo`, `MarketingIndo` or another workstation is temporary and must not be treated as the canonical project runtime.

When an agent creates or rebuilds a project-owned image it must, as part of the same implementation flow when credentials and registry access are available:

1. Build from the approved source revision.
2. Tag the image with an immutable revision-oriented tag, preferably the Git commit SHA or an approved release identifier.
3. Push that immutable tag to Docker Hub.
4. Resolve and record the resulting remote digest.
5. Use that tag or digest from each implementation workstation that needs the runtime.
6. Optionally maintain `latest` or another convenience tag, but never rely on it as the only reproducible reference.

If registry credentials or connectivity prevent the push, the image may remain local only as a temporary exception. The task must report this as a blocking/pending item and must not claim multi-machine synchronization is complete.

## Required image strategy

For project-owned services:

1. Build once from the approved source revision.
2. Publish the image to the approved registry, normally Docker Hub under `christyepez/*` unless the project defines another registry.
3. Tag each release with an immutable revision-oriented tag such as the Git commit SHA.
4. Prefer pinning runtime Compose files by digest (`repository@sha256:...`) when reproducibility between machines is required.
5. `latest` may exist as a convenience alias, but it must not be the only reference used for reproducible environments.
6. Before deleting a local project-owned image, verify an exact recoverable remote copy exists. If exact recovery is not proven, push an immutable backup tag first.

## Docker Desktop operating model

Docker Desktop is an execution environment and local cache, not the authoritative artifact repository.

Use Docker Desktop only when it is necessary to run, inspect, debug, validate or temporarily build a project locally.

Do not keep local containers or images running merely because they exist. Start project stacks when implementation, testing or validation requires them, and stop recreable application services when they are no longer needed if doing so does not affect active work.

Persistent data is different from recreable runtime. Database containers, stateful services and named volumes must remain protected according to the persistence rules below.

Routine Docker Desktop maintenance should favor targeted operations over broad destructive pruning. Build cache, unused recreable helper containers, unused networks and remotely recoverable images can be cleaned when safe. Persistent volumes and databases are excluded from routine cleanup unless explicitly authorized.

## Compose contract

Projects using Docker Compose should separate source-build and registry-runtime concerns:

- `docker-compose.yml`: canonical service topology and local-development defaults.
- `docker-compose.hub.yml` or equivalent: override project-owned `build:` entries with registry `image:` references and set `build: null`.
- `.env` or generated local override files must not be committed when they contain secrets.
- Runtime image variables should be explicit and fail fast when missing.
- For multi-machine implementation, the preferred startup path is the registry-backed Compose configuration rather than rebuilding independently on every workstation.

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

For multi-machine projects, also compare the project-owned runtime image digests between `trabajo`, `MarketingIndo` and any other active implementation workstation. A shared runtime is compliant only when the expected components resolve to the intended common digest/version.

## Expected Codex behavior

For Docker-related work Codex must report:

```text
Runtime Machine(s):
Compose Files Read:
Images Built:
Images Published to Docker Hub:
Remote Digests:
Images Compared:
Registry Recoverability Checked:
Digests Pinned:
Ports Exposed:
Persistent Volumes Preserved:
Docker Desktop Changes:
Containers Recreated:
Health Validation:
Cleanup Performed:
Risks:
Next Step:
```
