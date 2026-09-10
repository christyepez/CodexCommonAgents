# GitHub Actions Delivery and Docker Desktop Environment Policy

## Scope

This rule applies to projects governed by `CodexCommonAgents` that use GitHub as their source repository and Docker for local development/testing runtimes.

## Delivery model

GitHub is the authoritative source for code, pull requests, workflow execution, release metadata and deployment automation.

Docker Hub is the authoritative shared registry for project-owned container images unless a project explicitly documents another approved registry.

Project-owned Docker Hub repositories MUST be PRIVATE by default. Public visibility requires explicit approval and documented justification.

Docker Desktop is the local runtime for development, integration and testing on workstations such as `trabajo` and `MarketingIndo`. It is not the authoritative source for shared container artifacts.

The required flow is:

```text
GitHub repository
      -> Pull Request / Quality Gates
      -> GitHub Actions
      -> Build once from approved revision
      -> Publish immutable image to PRIVATE Docker Hub repository
      -> Resolve remote digest
      -> Development/Test Docker Compose runtime
      -> trabajo / MarketingIndo
```

## Environment intent

For the current local baseline:

- `trabajo` is an approved development/test workstation.
- `MarketingIndo` is an approved development/test workstation.
- Both must be able to recreate the same application runtime from Docker Hub using the same intended image tag/digest.
- Docker Desktop stacks are started, stopped or recreated only when development, integration, debugging or validation requires it.
- Databases and persistent volumes remain protected from routine recreation/cleanup.

## GitHub Actions requirements

A project-owned container must preferably be built and published by GitHub Actions rather than relying on an independently built workstation image as the canonical artifact.

The workflow should:

1. Checkout the exact Git revision.
2. Execute project quality gates before publication.
3. Build the container image.
4. Tag it with an immutable revision identifier, preferably the Git commit SHA.
5. Ensure the destination Docker Hub repository is private unless a public exception is explicitly approved.
6. Optionally publish a convenience branch/release tag.
7. Authenticate to Docker Hub using GitHub Secrets.
8. Push the immutable image.
9. Capture/report the registry digest.
10. Make the resulting image reference available for deployment/validation.

For multi-image projects, every project-owned runtime image must follow the same rule.

## Private registry requirements

Private Docker Hub access must use token-based authentication or another approved secret-based mechanism.

Credentials must never be embedded in:

- source code;
- workflow YAML plaintext;
- Dockerfiles;
- Compose files;
- committed scripts;
- tracked `.env` files;
- image tags or image URLs.

When possible, workflows or provisioning automation should verify repository visibility before publication and report one of:

```text
PRIVATE
PUBLIC-APPROVED
NOT-VERIFIED
```

`NOT-VERIFIED` must be treated as a pending compliance check, not as confirmation that the repository is private.

## Quality gate before image publication

Publishing a shared image is blocked when required quality gates fail.

At minimum, use the gates appropriate to the project:

- restore/build;
- unit tests;
- configured coverage threshold;
- architecture tests for governed backends;
- lint/static analysis;
- security/dependency/secret checks where configured;
- API/contract validation when applicable.

Do not publish an image as the approved shared runtime merely because `docker build` succeeds.

## Runtime deployment to Docker Desktop

GitHub Actions does not make a workstation's Docker Desktop runtime authoritative.

The deployment target for local development/testing is the registry-backed Compose configuration, normally:

```text
docker-compose.yml
+
docker-compose.hub.yml
```

Project-owned application services must resolve to Docker Hub image tags/digests. Shared infrastructure must follow the infrastructure reuse rules before new instances are created.

When updating a development/test workstation:

1. Read the intended GitHub revision/release.
2. Resolve the expected Docker Hub digest.
3. Authenticate Docker Desktop/CLI against Docker Hub using the approved local credential store when the repository is private.
4. Pull the expected image.
5. Recreate only the stateless/project-owned services that actually require updating.
6. Do not recreate databases/stateful dependencies implicitly.
7. Validate health, logs, ports and image digest.
8. Compare runtime parity between `trabajo` and `MarketingIndo` when both represent the same logical environment.

## Workstation deployment automation

Direct remote deployment from GitHub Actions to a workstation is optional, not mandatory.

Preferred baseline is pull-based/local execution: GitHub Actions publishes immutable images and the workstation consumes them when development/testing requires it.

If future automation connects GitHub Actions directly to `trabajo` or `MarketingIndo`, it must use an approved secure runner/agent model, must not expose workstation credentials, and must preserve the same database/persistence safety rules.

## Secrets

Docker Hub credentials and deployment credentials must never be committed.

Use GitHub Actions Secrets or an approved secret manager. Prefer token-based Docker Hub authentication rather than account passwords.

Expected secret names may be standardized as:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

Projects may use different names only when documented.

## Definition of Done

For a shared containerized implementation, `DONE` requires, when applicable:

```text
PR / approved revision
+ quality gates PASS
+ GitHub Actions build PASS
+ PRIVATE Docker Hub image published (or explicitly approved public exception)
+ remote digest known
+ registry visibility verified when tooling allows
+ registry-backed Compose configuration valid
+ development/test runtime validated on required workstation(s)
+ stateful data preserved
```

## Required reporting

For GitHub-to-Docker delivery tasks, report:

```text
GitHub Revision:
Workflow:
Quality Gates:
Images Published:
Docker Hub Visibility: PRIVATE | PUBLIC-APPROVED | NOT-VERIFIED
Docker Hub Digests:
Target Environment: Development | Test
Target Workstation(s):
Compose Runtime:
Stateful Services Preserved:
Health Validation:
Runtime Digest Match:
Risks:
Next Step:
```
