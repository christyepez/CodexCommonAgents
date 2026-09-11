# GHCR Private Registry Governance

## Purpose

GitHub Container Registry (`ghcr.io`) is the preferred registry for project-owned images governed by `CodexCommonAgents` when private distribution is required.

## Default policy

Project-owned application images MUST be published as PRIVATE packages by default.

The preferred naming convention is:

```text
ghcr.io/christyepez/<project>-<service>:sha-<gitsha>
```

Public package visibility requires explicit project approval and documented justification.

## Why GHCR is preferred

GHCR integrates directly with GitHub Actions, supports private container packages, uses `GITHUB_TOKEN` for workflow publication, and keeps source, CI metadata and container artifacts in the same governance boundary.

New GHCR packages are expected to remain private unless explicitly changed. Once a package is made public, agents MUST NOT assume it can be reverted to private without verifying GitHub's current platform behavior.

## Publication requirements

A compliant workflow MUST:

1. Run quality gates before publication.
2. Use `permissions: packages: write` and `contents: read`.
3. Authenticate to `ghcr.io` with `${{ github.actor }}` and `${{ secrets.GITHUB_TOKEN }}` when repository permissions allow it.
4. Publish an immutable SHA-based tag.
5. Capture the remote digest.
6. Publish SBOM/provenance where supported.
7. Link the package to the source repository using OCI labels when practical.
8. Verify/report package visibility as `PRIVATE`, `PUBLIC-APPROVED`, or `NOT-VERIFIED`.

## Pull access

Docker Desktop on approved DEV/TEST workstations must authenticate to GHCR before pulling private images.

Use a GitHub token with the minimum permissions needed for package read access. Credentials must be stored in the Docker credential store or another approved secret store and MUST NOT be committed to source control.

## Docker Hub coexistence

Existing Docker Hub images are not deleted merely because GHCR becomes preferred.

Migration is phased:

```text
Docker Hub public/private image
  -> publish exact approved revision to GHCR private
  -> verify digest/runtime
  -> update Compose/runtime references
  -> validate DEV/TEST
  -> only then consider Docker Hub retirement or public artifact cleanup
```

No Docker Hub image that is the only recoverable copy may be deleted.

## Definition of Done

For a private shared runtime image:

```text
quality gates PASS
+ GHCR package published
+ immutable tag/digest known
+ visibility PRIVATE or approved exception
+ Docker Desktop pull authenticated
+ DEV/TEST runtime validated
+ rollback reference retained
```

## Required report

```text
Registry: GHCR | DockerHub | Other
Package:
Visibility: PRIVATE | PUBLIC-APPROVED | NOT-VERIFIED
Source Revision:
Immutable Tag:
Digest:
SBOM/Provenance:
Runtime Machine(s):
DEV Validation:
TEST Validation:
Rollback Reference:
```
