# Docker Multi-Machine Runtime Playbook

## Goal

Keep Docker-based projects reproducible across multiple workstations without relying on machine-specific local builds.

## Standard flow

1. Identify the approved source revision.
2. Build project-owned images once.
3. Push immutable tags to the registry.
4. Resolve and record image digests.
5. Use a registry override Compose file on each workstation.
6. Recreate only application services when possible; do not recreate databases just to align application images.
7. Validate health, ports and image IDs on every workstation.

## Recommended files

```text
docker-compose.yml
docker-compose.hub.yml
.env.example
scripts/docker-verify.ps1
```

## Runtime image variables

Prefer variables such as:

```text
APP_API_IMAGE=christyepez/project-api@sha256:...
APP_WORKER_IMAGE=christyepez/project-worker@sha256:...
APP_WEB_IMAGE=christyepez/project-web@sha256:...
```

The override should fail when required application-image variables are absent.

## Machine alignment check

For every project-owned service compare:

```text
container name
configured image reference
container image ID
repository digest
Git revision label when available
```

All machines representing the same environment should match on the effective immutable image.

## Safe rollout

If persistent services are already healthy, align application containers independently. Preserve database, queue and storage volumes. Do not run destructive Compose commands with `-v`.

## Cleanup after alignment

Only after remote recoverability is proven may obsolete local application images be removed. Third-party mutable tags can be re-pulled, but exact historical recovery should not be assumed unless a digest is known.

## Failure handling

If one machine cannot pull the pinned digest, stop the rollout and verify registry visibility/architecture before changing the other machine. Never replace a known-good database volume as a troubleshooting shortcut.
