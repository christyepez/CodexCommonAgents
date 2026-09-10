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
4. Controllers should be limited to HTTP concerns: binding, transport validation, authorization context, calling one application service/use case, and mapping the result to HTTP/ProblemDetails.
5. Application Services MUST NOT access `DbContext` directly.
6. Application Services contain orchestration/use-case logic and depend on interfaces, never concrete Infrastructure implementations.
7. Domain contains business invariants, domain rules, entities, value objects and domain events; it must remain framework-agnostic.
8. `Program.cs` MUST NOT implement use cases; it is a composition root only.
9. Infrastructure implements repository, messaging, storage, security and external-integration interfaces defined inward.
10. DTO/API contracts MUST be separated from persistence entities and domain entities when exposure would couple the transport contract to the domain model.
11. Repositories MUST NOT become business-service containers; they encapsulate persistence/query behavior only.
12. `DbContext` is the default Unit of Work; avoid ceremonial wrappers unless a real transactional abstraction is required.
13. Validation belongs at Application/domain boundaries, with API responsible only for transport validation/mapping.
14. API errors must use centralized ProblemDetails/error mapping.
15. Token generation, password hashing, storage, email, messaging and other external concerns must be behind interfaces.
16. Audit, functional history and metrics are separate responsibilities and should use separate models/storage semantics.
17. Secrets and environment-specific credentials MUST NOT be committed.
18. Async I/O MUST propagate `CancellationToken` where practical.
19. Public methods and interfaces should follow SOLID, explicit responsibilities, dependency inversion and testability.
20. Avoid static/global state, service locators, hidden dependencies and oversized god services/controllers.

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

The API consumes `IUserService`, `IContentService`, etc. It does not consume repository implementations or `AppDbContext`.

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
  Product.Infrastructure.UnitTests/        # when useful
  Product.Api.UnitTests/                   # thin controller/mapper behavior when useful
  Product.IntegrationTests/
  Product.ArchitectureTests/
```

## Unit Testing and Coverage Policy

Unit tests are mandatory for new or modified backend behavior.

Required focus:

- Domain rules, entities and value objects.
- Application services/use cases, including success, validation, error and edge paths.
- Authorization/tenant decisions that contain application logic.
- Repository-independent behavior using mocks/fakes only where appropriate.
- Mapping and controller behavior only when it adds meaningful coverage; do not write low-value tests solely to inflate percentages.
- Regression tests for every defect fixed when practical.

Coverage rules:

1. The repository/pipeline coverage gate is authoritative when one already exists.
2. If no project-specific gate exists, the common default minimum is **80% line coverage** and **70% branch coverage** for backend unit-testable code.
3. New or materially changed application/domain code should target **>= 90% line coverage** where practical.
4. Coverage exclusions must be intentional and documented; generated code, migrations and trivial framework bootstrap code may be excluded when justified.
5. A backend task is not DONE if the configured coverage gate fails.
6. Do not satisfy coverage by testing implementation details, adding meaningless assertions or excluding business code from measurement.
7. Prefer tests that validate observable behavior and business outcomes.

Recommended tooling for .NET projects:

```text
coverlet.collector
Microsoft.NET.Test.Sdk
xUnit or the project-approved test framework
ReportGenerator when HTML/summary reports are needed
```

Example validation command when Coverlet collector is configured:

```text
dotnet test --configuration Release --collect:"XPlat Code Coverage"
```

Projects SHOULD enforce coverage in CI using repository-specific thresholds. When tooling supports MSBuild threshold properties, fail the build/test stage when the configured line/branch thresholds are not met.

## Required Architecture Checks

Architecture tests SHOULD verify:

- Domain cannot depend on Application, Infrastructure or API.
- Application cannot depend on Infrastructure or API.
- API controllers cannot depend on EF Core, DbContext or repository implementations.
- Application services cannot depend on EF Core or DbContext.
- provider-specific persistence code exists only in Infrastructure.
- API does not contain domain entities/repository implementations.
- Repository implementations are located in Infrastructure.
- Controllers remain thin and do not contain persistence/business dependencies.

## Code Quality Expectations

Backend code must follow good engineering practices:

- SOLID and dependency inversion.
- Small cohesive classes and methods with one clear responsibility.
- Explicit interfaces at architectural boundaries.
- Dependency injection instead of object construction inside use cases/controllers.
- Consistent naming and nullability.
- Structured logging without secrets or sensitive payloads.
- Centralized exception/error handling.
- Async all the way for I/O paths.
- Avoid duplicate logic, dead code and premature abstractions.
- Refactor code smells before declaring a story DONE when they materially affect maintainability or testability.

## Review Classification

Every backend architecture decision should be classified as:

`REUSE | EXTEND | ADAPT | CREATE | BLOCKED`

Prefer REUSE/EXTEND before CREATE when a shared implementation already exists.

## Definition of Done

The implementation is not complete if any mandatory boundary above is violated, even when functional tests pass.

A backend story is DONE only when:

- Clean Architecture boundaries are respected.
- Controller/endpoint logic is thin and transport-only.
- Repository interfaces and implementations are separated correctly.
- Services/use cases are testable through interfaces.
- DTOs are explicit and do not leak persistence concerns.
- Unit tests cover new/changed behavior and edge/error paths.
- Architecture tests pass where configured.
- Build passes with warnings treated according to project policy.
- The repository coverage gate passes; if none exists, the default 80% line / 70% branch baseline is met for unit-testable backend code.
