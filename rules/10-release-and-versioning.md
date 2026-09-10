# Release and Versioning Governance

Releases must be reproducible, traceable and reversible.

## Versioning

- Use immutable Git revisions as the source of released artifacts.
- Tag project-owned Docker images with commit SHA or approved release version and publish them to the approved registry.
- Do not rely on `latest` as the only deployable reference.
- Record the remote digest used by each environment.
- Use semantic versioning where the project exposes versioned public artifacts/contracts and where it adds value.

## Promotion

Prefer promoting the same built artifact across environments instead of rebuilding independently for each machine/environment.

For the current multi-machine baseline, `trabajo` and `MarketingIndo` must be able to pull and execute the same approved image digest.

## Release gate

A release is not DONE until required tests/gates pass, artifacts are published, deployment/runtime health is validated and rollback/forward-fix instructions are known.

## Change record

Each release should capture source revision, images/digests, migrations, configuration changes, known risks, compatibility notes and validation evidence.

High/critical releases may require explicit human approval according to project governance.
