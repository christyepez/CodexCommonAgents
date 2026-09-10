# API and Contract Governance

APIs and asynchronous contracts are shared interfaces and must be treated as versioned products.

## API rules

- Use explicit request/response DTOs; never expose persistence entities directly.
- Prefer RESTful resource semantics where appropriate.
- Use centralized RFC 7807 Problem Details for errors.
- Define pagination, filtering, sorting and size limits explicitly.
- Apply API versioning when breaking evolution requires it.
- Validate OpenAPI/Swagger documents in CI.
- Preserve backward compatibility by default; breaking changes require versioning or an approved migration plan.
- Apply server-side authorization and rate limiting where risk/traffic warrants it.

## Messaging contracts

RabbitMQ/Kafka messages must define stable event/command schemas, versioning strategy, producer/consumer ownership, idempotency expectations and retry/dead-letter behavior.

## Parallel-agent rule

Frontend, backend, integration and messaging agents must agree on contracts before parallel implementation proceeds. Contract files are high-conflict assets and require explicit ownership.

## Contract testing

Changes to public APIs or events should include automated contract/schema tests and, where applicable, consumer/provider compatibility validation.
