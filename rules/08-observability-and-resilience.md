# Observability and Resilience

Distributed and production-facing services must be diagnosable and resilient by design.

## Observability baseline

- Structured logging with correlation/trace identifiers.
- Health endpoints separated into liveness and readiness where practical.
- Metrics for availability, latency, errors and key dependencies.
- OpenTelemetry-compatible tracing when the project supports distributed tracing.
- Logs must avoid secrets and sensitive payloads.

## Resilience baseline

- Explicit timeouts for external calls.
- Retries only for transient operations and with bounded backoff/jitter.
- Circuit breaker where repeated dependency failures could cascade.
- Idempotency for retryable commands, APIs and consumers where applicable.
- Outbox/Inbox patterns for reliable integration events when consistency requires it.
- Dead-letter handling and poison-message strategy for queues/topics.

## Validation

Critical integrations must include failure-path tests, not only happy-path tests. Agents must document retry, timeout and failure semantics when introducing a new external dependency.
