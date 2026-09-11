# GitHub Actions Delivery and Docker Desktop Environment Policy

## Scope

This rule applies to projects governed by `CodexCommonAgents` that use GitHub as their source repository and Docker for local development/testing runtimes.

## Delivery model

GitHub is the authoritative source for code, pull requests, workflow execution, release metadata and deployment automation.

GitHub Container Registry (`ghcr.io`) is the preferred shared registry for project-owned private container images. Docker Hub may remain as a compatibility, legacy or explicitly approved registry.

Project-owned packages/images MUST be PRIVATE by default. Public visibility requires explicit approval and documented justification.

Docker Desktop is the local runtime for development, integration and testing on workstations such as `trabajo` and `MarketingIndo`. It is not the authoritative source for shared container artifacts.

The preferred flow is:

```text
GitHub repository
      -> Pull Request / Quality Gates
      -> GitHub Actions
      -> Build once from approved revision
      -> Publish immutable image to PRIVATE GHCR package
      -> Resolve remote digest
      -> Development/Test Docker Compose runtime
      -> trabajo / MarketingIndo
```

## Environment intent

- `trabajo` is an approved development/test workstation.
- `MarketingIndo` is an approved development/test workstation.
- Both must be able to recreate the same application runtime from the approved registry using the same intended image tag/digest.
- Docker Desktop stacks are started, stopped or recreated only when development, integration, debugging or validation requires it.
- Databases and persistent volumes remain protected from routine recreation/cleanup.

## GitHub Actions requirements

A project-owned container must preferably be built and published by GitHub Actions rather than relying on an independently built workstation image as the canonical artifact.

The workflow should:

1. Checkout the exact Git revision.
2. Execute project quality gates before publication.
3. Build the container image.
4. Tag it with an immutable revision identifier, preferably the Git commit SHA.
5. Publish to `ghcr.io` as a private package by default.
6. Optionally publish a convenience branch/release tag.
7. Authenticate to GHCR with `GITHUB_TOKEN` and least-privilege workflow permissions where supported.
8. Push the immutable image.
9. Capture/report the registry digest.
10. Generate SBOM/provenance where supported.
11. Make the resulting image reference available for deployment/validation.

For multi-image projects, every project-owned runtime image must follow the same rule.

## Private registry requirements

Private GHCR access must use GitHub-provided workflow tokens or another approved token-based mechanism. Private Docker Hub fallback must also use token-based authentication.

Credentials must never be embedded in source code, workflow YAML plaintext, Dockerfiles, Compose files, committed scripts, tracked `.env` files, image tags or image URLs.

Visibility must be reported as:

```text
PRIVATE
PUBLIC-APPROVED
NOT-VERIFIED
```

`NOT-VERIFIED` is a pending compliance check, never confirmation of privacy.

## Quality gate before image publication

Publishing a shared image is blocked when required quality gates fail. At minimum, use the gates appropriate to the project: restore/build, unit tests, configured coverage threshold, architecture tests, lint/static analysis, security/dependency/secret checks and API/contract validation when applicable.

Do not publish an image as the approved shared runtime merely because `docker build` succeeds.

## Runtime deployment to Docker Desktop

The deployment target for local development/testing is the registry-backed Compose configuration. Existing projects may still use `docker-compose.hub.yml`; new or migrated projects SHOULD use a registry-neutral name such as `docker-compose.registry.yml` or `docker-compose.ghcr.yml`.

Project-owned application services must resolve to approved private registry tags/digests. Shared infrastructure must follow the infrastructure reuse rules before new instances are created.

When updating a development/test workstation:

1. Read the intended GitHub revision/release.
2. Resolve the expected registry digest.
3. Authenticate Docker Desktop/CLI against GHCR or the approved registry using the local credential store.
4. Pull the expected image.
5. Recreate only the stateless/project-owned services that actually require updating.
6. Do not recreate databases/stateful dependencies implicitly.
7. Validate health, logs, ports and image digest.
8. Compare runtime parity between `trabajo` and `MarketingIndo` when both represent the same logical environment.

## Docker Hub migration safety

Existing Docker Hub images are not deleted simply because GHCR becomes preferred. Migrate first, verify exact recoverability and runtime parity, then retire legacy public copies only when they are no longer required.

## Workstation deployment automation

Direct remote deployment from GitHub Actions to a workstation is optional. Preferred baseline is pull-based/local execution: GitHub Actions publishes immutable images and the workstation consumes them when development/testing requires it.

## Secrets

For GHCR publication, prefer the repository-scoped `GITHUB_TOKEN` with `packages: write` and `contents: read`. For workstation pull access, use a least-privilege GitHub token stored by Docker's credential store or an approved secret manager.

Docker Hub credentials remain permitted only for legacy/fallback flows and must use GitHub Secrets or an approved secret manager.

## Definition of Done

For a shared containerized implementation, `DONE` requires, when applicable:

```text
PR / approved revision
+ quality gates PASS
+ GitHub Actions build PASS
+ PRIVATE GHCR package published (or approved registry exception)
+ remote digest known
+ visibility verified or explicitly reported NOT-VERIFIED
+ registry-backed Compose configuration valid
+ development/test runtime validated on required workstation(s)
+ stateful data preserved
```

## Required reporting

```text
GitHub Revision:
Workflow:
Quality Gates:
Registry: GHCR | DockerHub | Other
Images Published:
Registry Visibility: PRIVATE | PUBLIC-APPROVED | NOT-VERIFIED
Registry Digests:
Target Environment: Development | Test
Target Workstation(s):
Compose Runtime:
Stateful Services Preserved:
Health Validation:
Runtime Digest Match:
Risks:
Next Step:
```
