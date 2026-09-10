# Docker Image Registry

## Purpose

Track project-owned images that must be reproducible across implementation workstations.

## Policy

Every project-owned image used as a shared implementation/runtime artifact must be published to Docker Hub or the project-approved registry with an immutable revision tag and preferably consumed by digest.

Local-only images are temporary development artifacts and must not be treated as the canonical multi-machine runtime.

## Required metadata per image

Record when practical:

```text
Project
Service
Repository
Immutable tag
Remote digest
Source Git revision
Build date/release
Active machines
```

## Current known project image families

```text
christyepez/appcondominio-api
christyepez/appcondominio-worker
christyepez/appcondominio-web
christyepez/appcoloreando-api
christyepez/appcoloreando-worker
christyepez/appcoloreando-visual-processor
```

Other projects must add their image families when they adopt the standard.

## Validation

Before deleting a local project-owned image, verify exact remote recoverability. Before declaring two workstations synchronized, compare the expected project-owned digests on each machine.
