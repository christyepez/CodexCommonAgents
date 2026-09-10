# DEV and TEST Environment Separation

## Scope

This rule applies to projects executed locally through Docker Desktop or equivalent container runtimes on implementation workstations such as `trabajo` and `MarketingIndo`.

## Principle

Development and test environments must be logically separated even when they execute on the same workstation and consume the same immutable application images from Docker Hub.

The same project-owned image revision SHOULD be promoted across DEV and TEST. Environment differences must come from configuration, secrets, ports, data stores and runtime settings, not from independently rebuilt application binaries.

## Required environment model

Each project that needs local development and integration testing SHOULD provide:

```text
docker-compose.yml
docker-compose.hub.yml
docker-compose.dev.yml
docker-compose.test.yml
.env.dev.example
.env.test.example
```

Equivalent naming is allowed when clearly documented.

## Isolation requirements

DEV and TEST must not unintentionally share mutable state.

Separate at minimum when applicable:

- Compose project names.
- Application container names/namespaces.
- Host ports.
- Database names or schemas.
- Database users where practical.
- RabbitMQ virtual hosts, users, exchanges and queues.
- Kafka topic prefixes, consumer groups and ACLs.
- Redis database/key prefixes or isolated instances when logical isolation is insufficient.
- Object storage buckets/prefixes.
- Test uploads and generated files.
- Application configuration and feature flags.

Infrastructure runtimes may be reused according to `rules/03-shared-infrastructure-reuse.md`, but DEV and TEST workloads must remain logically isolated.

## Database safety

TEST must never point to a production database.

DEV and TEST may reuse the same database server/container only when they use isolated databases/schemas and credentials or equivalent controls.

Automated integration tests must use disposable or dedicated test data and must not truncate, migrate destructively or reseed a DEV database unless the project explicitly documents that behavior.

## Docker Desktop behavior

Docker Desktop is the local execution environment only.

Stacks should be started when development, integration, QA or smoke validation requires them. They do not need to remain running permanently.

Stateful infrastructure already in use should be reused when compatible instead of creating duplicate SQL Server, PostgreSQL, RabbitMQ, Kafka, Redis or similar runtimes.

## Image parity

DEV and TEST should consume the same project-owned Docker Hub digest for a given candidate build.

A test result is not considered valid for release promotion if TEST executed a different application digest from the candidate being evaluated.

## Port governance

Ports must be registered in `registry/docker-port-registry.md` before assigning new shared workstation bindings.

Prefer localhost-only bindings for infrastructure/admin services unless cross-machine access is explicitly required.

## Required validation

Before declaring TEST ready:

```text
docker compose config
runtime image digest comparison
health/readiness checks
smoke tests
integration tests
no production endpoint/database references
```

## Expected Codex report

```text
Environment: DEV | TEST
Runtime Machine:
Compose Project Name:
Application Digest:
Shared Infrastructure Reused:
Data Isolation:
Port Isolation:
Secrets Isolation:
Health Validation:
Tests Executed:
Production References Detected: Yes/No
Risks:
Next Step:
```
