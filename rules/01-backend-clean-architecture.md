# Backend Clean Architecture Rules

These rules apply by default to all .NET backend implementations governed by `CodexCommonAgents`, unless a repository-specific ADR explicitly documents an approved exception.

## Architecture Contract

```text
API -> DTOs / Application Interfaces -> Application Services -> Repository Interfaces -> Infrastructure Repositories -> DbContext -> Database
```

Logical layer dependency remains:

```text
API -> Application -> Domain
Infrastructure -> Application + Domain
```

- Domain decides.
- Application orchestrates.
- Infrastructure persists/integrates.
- API transports.

## Mandatory Access Flow

All persistence access MUST follow this path unless an ADR explicitly approves another architecture:

```text
Controller / Endpoint
        ↓
Request DTO
        ↓
Application Service Interface
        ↓
Application Service / Use Case
        ↓
Repository Interface
        ↓
Repository Implementation
        ↓
EF Core DbContext
        ↓
SQL Server / PostgreSQL / approved database
```

Return flow:

```text
Database
   ↓
Repository
   ↓
Application Service
   ↓
Response DTO
   ↓
Controller
   ↓
HTTP Response
```

Rules:

- Controllers communicate with the Application layer through DTOs and application service/use-case interfaces.
- Controllers MUST NOT inject repositories directly for normal business use cases.
- Controllers MUST NOT inject or access `DbContext`.
- Application Services MUST NOT inject `DbContext`.
- Application Services access persistence only through repository/query interfaces.
- Repository interfaces are defined inward, normally in Application.
- Repository implementations belong in Infrastructure.
- Only Infrastructure persistence components may directly access EF Core `DbContext`.
- Repositories return domain entities, projections or application-facing persistence results as appropriate; they must not return EF-specific types such as `DbSet`, `EntityEntry`, `IQueryable` across the Infrastructure boundary unless an explicit query abstraction has been approved.
- API request/response DTOs must not be persistence entities.

## Mandatory Boundaries

1. Controllers/endpoints MUST NOT contain business logic.
2. Controllers/endpoints MUST NOT access EF Core `DbContext` directly.
3. Controllers/endpoints MUST NOT bypass Application Services by calling repositories directly for business operations.
4. Application Services MUST NOT access `DbContext` directly.
5. `Program.cs` MUST NOT implement use cases; it is a composition root only.
6. Domain MUST remain framework-agnostic and persistence-agnostic.
7. Application MUST NOT reference concrete Infrastructure implementations.
8. Infrastructure implements interfaces/ports defined inward, primarily by Application.
9. DTO/API contracts MUST be separated from persistence entities.
10. Repositories MUST NOT become business-service containers.
11. `DbContext` is the default Unit of Work; avoid ceremonial wrappers.
12. Validation belongs at Application/domain boundaries, with API responsible only for transport validation/mapping.
13. API errors must use centralized ProblemDetails/error mapping.
14. Token generation, password hashing, storage, email, messaging and other external concerns must be behind interfaces.
15. Audit, functional history and metrics are separate responsibilities and should use separate models/storage semantics.
16. Secrets and environment-specific credentials MUST NOT be committed.
17. Async I/O MUST propagate `CancellationToken` where practical.

## Default Interface Placement

Recommended shape:

```text
Product.Application/
  Abstractions/
    Services/
      IUserService.cs
      IContentService.cs
    Persistence/
      IUserRepository.cs
      IContentRepository.cs
  Contracts/
    Requests/
    Responses/
  Services/
    UserService.cs
    ContentService.cs

Product.Infrastructure/
  Persistence/
    AppDbContext.cs
    Repositories/
      UserRepository.cs
      ContentRepository.cs
```

The API consumes `IUserService`, `IContentService`, etc. It does not consume `UserRepository` or `AppDbContext`.

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
- API controllers cannot depend on EF Core, DbContext or repository implementations.
- Application services cannot depend on EF Core or DbContext.
- provider-specific persistence code exists only in Infrastructure.
- API does not contain domain entities/repository implementations.
- Repository implementations are located in Infrastructure.

## Review Classification

Every backend architecture decision should be classified as:

`REUSE | EXTEND | ADAPT | CREATE | BLOCKED`

Prefer REUSE/EXTEND before CREATE when a shared implementation already exists.

## Definition of Done

The implementation is not complete if any mandatory boundary above is violated, even when functional tests pass.
