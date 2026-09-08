# Backend Clean Architecture Rules

These rules apply by default to all .NET backend implementations governed by `CodexCommonAgents`, unless a repository-specific ADR explicitly documents an approved exception.

## Architecture Contract

```text
API -> Application -> Domain
Infrastructure -> Application + Domain
```

- Domain decides.
- Application orchestrates.
- Infrastructure persists/integrates.
- API transports.

## Mandatory Boundaries

1. Controllers/endpoints MUST NOT contain business logic.
2. Controllers/endpoints MUST NOT access EF Core `DbContext` directly.
3. `Program.cs` MUST NOT implement use cases; it is a composition root only.
4. Domain MUST remain framework-agnostic and persistence-agnostic.
5. Application MUST NOT reference concrete Infrastructure implementations.
6. Infrastructure implements interfaces/ports defined inward, primarily by Application.
7. DTO/API contracts MUST be separated from persistence entities.
8. Repositories MUST NOT become business-service containers.
9. `DbContext` is the default Unit of Work; avoid ceremonial wrappers.
10. Validation belongs at Application/domain boundaries, with API responsible only for transport validation/mapping.
11. API errors must use centralized ProblemDetails/error mapping.
12. Token generation, password hashing, storage, email, messaging and other external concerns must be behind interfaces.
13. Audit, functional history and metrics are separate responsibilities and should use separate models/storage semantics.
14. Secrets and environment-specific credentials MUST NOT be committed.
15. Async I/O MUST propagate `CancellationToken` where practical.

## Default Project Layout

```text
src/
  Product.Domain/
  Product.Application/
  Product.Infrastructure/
  Product.Api/

tests/
  Product.Domain.UnitTests/
  Product.Application.UnitTests/
  Product.IntegrationTests/
  Product.ArchitectureTests/
```

## Required Architecture Checks

Architecture tests SHOULD verify:

- Domain cannot depend on Application, Infrastructure or API.
- Application cannot depend on Infrastructure or API.
- API controllers cannot depend on EF Core or DbContext.
- provider-specific persistence code exists only in Infrastructure.
- API does not contain domain entities/repository implementations.

## Review Classification

Every backend architecture decision should be classified as:

`REUSE | EXTEND | ADAPT | CREATE | BLOCKED`

Prefer REUSE/EXTEND before CREATE when a shared implementation already exists.

## Definition of Done

The implementation is not complete if any mandatory boundary above is violated, even when functional tests pass.
