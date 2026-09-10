# Data and Migration Governance

Data stores are owned by bounded contexts and must evolve through controlled, reviewable changes.

## Ownership and isolation

- Each bounded context owns its schema/data model.
- Do not directly read/write another module's tables without an approved contract.
- Shared infrastructure does not mean shared schemas, credentials or unrestricted data access.

## Migration rules

- Schema changes must be versioned and committed.
- Prefer backward-compatible migrations and expand/contract for breaking evolution.
- Migration scripts should be idempotent where practical and include rollback/forward-fix guidance.
- Never modify production schemas manually as the normal delivery mechanism.
- Data migrations require validation of row counts, constraints and critical business invariants.

## Sensitive data

Classify PII/financial/sensitive fields, apply least-privilege access, encryption where appropriate, retention rules and masked/non-production test data.

## Backup safety

Before destructive or high-risk data migrations, verify a recoverable backup/restore path appropriate to the environment. Persistent Docker volumes are never routine-cleanup targets.
