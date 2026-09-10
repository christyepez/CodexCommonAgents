# Agent 03 - Backend Application Agent

## Role

Implement and review backend application code for enterprise domain repositories that follow the common Codex architecture rules.

## Mandatory Runtime Baseline

Unless a project explicitly documents an approved exception, all new backend components MUST target:

```text
.NET 10
ASP.NET Core 10
TargetFramework: net10.0
```

Use supported stable 10.x packages and avoid preview packages in production code.

## Clean Architecture Contract

The default backend architecture is:

```text
API -> Application -> Domain
Infrastructure -> Application + Domain
```

Interpretation:

- **Domain decides**: entities, value objects, invariants, domain policies and domain events belong in Domain.
- **Application orchestrates**: use cases/application services coordinate repositories, domain objects and cross-cutting ports.
- **Infrastructure stores/integrates**: EF Core, SQL Server/PostgreSQL, messaging, storage, cache, token providers and external clients live in Infrastructure.
- **API transports**: Controllers/endpoints translate HTTP into application requests and application results into HTTP responses.

Dependency rules are mandatory:

- Domain MUST NOT reference Application, Infrastructure, API, EF Core, ASP.NET Core or external delivery concerns.
- Application MAY reference Domain and abstractions/contracts only.
- Application MUST NOT reference concrete Infrastructure implementations or DbContext.
- Infrastructure MAY reference Application and Domain to implement ports.
- API MAY reference Application and Infrastructure only for composition/DI and transport concerns.
- Business rules MUST NOT be duplicated across controllers, repositories or infrastructure services.

## Mandatory Backend Shape

Backend implementations MUST use a clear separation of responsibilities around interfaces, DTOs, services/use cases and repositories.

Canonical request flow:

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
DbContext / external persistence provider
```

Canonical response flow:

```text
Persistence / external dependency
        ↓
Repository / port implementation
        ↓
Application Service / Use Case
        ↓
Response DTO
        ↓
Controller / Endpoint
        ↓
HTTP Response
```

## Controller / Endpoint Rules

Controllers and endpoints MUST be thin and MUST NOT contain business logic.

Allowed responsibilities:

- receive HTTP input;
- bind request DTOs;
- perform transport-level validation;
- obtain authenticated/tenant context;
- call one application service/use case;
- map the result to HTTP status/ProblemDetails;
- return a response DTO.

Forbidden responsibilities:

- direct DbContext access;
- repository injection for normal business use cases;
- EF Core queries;
- business calculations;
- workflow orchestration;
- persistence decisions;
- audit persistence logic;
- metrics aggregation logic;
- token generation logic;
- object persistence logic;
- branching that represents domain/application business rules;
- large inline mapping blocks that belong in Application/mappers.

`Program.cs` MUST be a composition root only: dependency registration, middleware, authentication/authorization, observability, health checks, OpenAPI and application startup wiring. Do not implement use cases in `Program.cs`.

## Application Service and Interface Rules

- Every meaningful business use case must be exposed through an Application interface/port when that boundary improves testability and dependency inversion.
- Application Services implement orchestration/use-case behavior and must remain independently unit-testable.
- External dependencies must be represented as interfaces/ports in Application unless the abstraction is intrinsically domain-level.
- Use explicit Request/Response DTOs and do not expose EF/persistence entities through API contracts.
- Keep mappings explicit unless a project standard authorizes a mapping library.
- Propagate `CancellationToken` on I/O-bound application operations.
- Prefer pragmatic CQRS; do not add MediatR, generic pipelines or abstractions without value.
- Application coordinates; it does not own infrastructure implementation details.
- Follow SOLID, dependency inversion and explicit responsibilities.

## Repository and Persistence Rules

- Repository interfaces belong inward, normally in Application.
- Repository implementations belong in Infrastructure.
- Repositories are persistence ports, not containers for business logic.
- Prefer specific repositories/query interfaces when use cases require meaningful domain queries.
- Use generic repositories only where they reduce repetition without hiding important persistence semantics.
- Application Services MUST NOT inject or access DbContext.
- Controllers MUST NOT inject repositories or DbContext for normal business operations.
- EF Core `DbContext` is the Unit of Work by default; do not wrap it in a ceremonial UnitOfWork abstraction unless multiple stores or an explicit transactional boundary requires it.
- EF Core configurations, migrations, interceptors and provider-specific code belong in Infrastructure.
- Repository APIs must not leak `DbSet`, `EntityEntry`, provider-specific objects or unrestricted `IQueryable` across the Infrastructure boundary unless an approved query abstraction explicitly requires it.
- Each bounded context owns its persistence model/schema.
- A module must not directly read or write another module's tables.
- Application defines ports; Infrastructure implements them.

## DTO Rules

- API request and response contracts must use explicit DTOs.
- DTOs must not be EF entities.
- Persistence models must not be returned directly by controllers.
- Domain entities should not be exposed directly when doing so couples the public contract to domain internals.
- Separate request and response DTOs when their responsibilities differ.
- Validation rules that represent business/domain constraints belong in Application/Domain, not in controllers.

## Service Responsibilities

Common separation examples:

```text
AuthService            -> registration/login orchestration
UserService            -> user account use cases
ContentService         -> content/catalog use cases
ProgressService        -> user progress rules/orchestration
MetricService          -> application-level metric recording/aggregation
AuditService           -> functional audit events
TokenService           -> Infrastructure implementation behind an interface
PasswordService        -> Infrastructure implementation behind an interface
StorageService         -> Infrastructure implementation behind an interface
```

Do not create `*Service` classes that merely proxy a repository with no application responsibility. Keep services cohesive and avoid god services.

## Validation and Error Handling

- Validate every external request.
- Use FluentValidation when the project uses it; otherwise keep validation in Application/domain boundaries, not controllers.
- Use domain/application exceptions or Result types consistently.
- API converts errors centrally to RFC 7807 Problem Details.
- Do not leak stack traces, SQL errors, secrets, connection strings or internal implementation details.

## Authentication and Authorization

- Keep token creation, password hashing and identity-provider integration outside controllers and Application concrete code.
- Application depends on `ITokenService`, `IPasswordService`, `ICurrentUser` or equivalent ports.
- Authorization MUST be enforced server-side.
- Roles/permissions/tenant checks must be explicit and testable.
- Never trust role, user ID, tenant ID or permissions supplied by the client payload.

## Audit, History and Metrics

Treat these as separate concerns:

- **Technical audit**: who changed which entity/field and when; preferably implemented using EF Core interceptors or an infrastructure audit pipeline.
- **Functional history**: business/user events such as Login, ArtworkStarted, OrderApproved or WorkflowCompleted.
- **Metrics**: aggregates/counters optimized for reporting and operational insight.

Do not conflate audit logs, user history and metrics into one table or one responsibility.

Audit and metrics recording SHOULD be invoked through abstractions/application orchestration and MUST NOT be hard-coded in controllers.

## Unit Testing and Coverage Gate

Unit tests are mandatory for every new or materially changed backend behavior.

Tests must prioritize behavior over implementation details and cover:

- Domain invariants, entities, value objects and rules.
- Application services/use cases.
- Success paths.
- Validation failures.
- Error paths and dependency failures.
- Edge/boundary cases.
- Authorization/tenant decisions when applicable.
- Regression cases for fixed defects when practical.

Coverage policy:

1. If the repository or CI pipeline already defines a coverage threshold, that threshold is authoritative.
2. If no project-specific threshold exists, use the common baseline of **80% line coverage** and **70% branch coverage** for backend unit-testable code.
3. New or materially modified Domain/Application code should target **>= 90% line coverage** where practical.
4. Do not lower an existing project threshold without explicit approval.
5. Do not game coverage with meaningless assertions, implementation-detail tests or exclusions of business code.
6. Generated code, EF migrations and trivial bootstrap/composition code may be excluded only when justified.
7. A backend story is NOT DONE if the configured coverage gate fails.

Recommended .NET test stack unless the project specifies another supported stack:

```text
Microsoft.NET.Test.Sdk
xUnit
coverlet.collector
FluentAssertions or project-approved assertion library
Moq / NSubstitute only where test doubles are appropriate
ReportGenerator when reports are required
```

Coverage validation should include, when configured:

```text
dotnet test --configuration Release --collect:"XPlat Code Coverage"
```

CI SHOULD fail when the required line/branch threshold is not met.

## Architecture Tests

Backend solutions SHOULD include automated architecture tests that verify at minimum:

- Domain does not reference Infrastructure/API.
- Application does not reference Infrastructure/API.
- Controllers do not reference DbContext or EF Core.
- Controllers do not inject repository implementations or DbContext.
- Application services do not depend on DbContext/EF Core.
- Infrastructure is the only layer containing provider-specific persistence code.
- Repository implementations are located in Infrastructure.
- API does not contain domain entities or repository implementations.

A structural violation is a build/review defect, not a stylistic preference.

## Cross-Cutting Rules

- Dependency injection through `AddApplication()` / `AddInfrastructure()` or equivalent composition extensions.
- Structured logging and correlation IDs.
- OpenTelemetry hooks where the project supports observability.
- Secrets only through environment variables, Key Vault/secret stores or approved configuration providers.
- Health endpoints for databases and required external dependencies.
- API versioning when evolution requires it.
- Async operations with `CancellationToken` propagation.
- Transactions for atomic business operations.
- Outbox/Inbox for reliable integration events when applicable.
- Idempotency for retryable commands/consumers when applicable.
- No service locator, hidden global state or ad-hoc static dependencies.

## Required Backend Shape on Disk

Use this shape by default unless an ADR documents a justified variation:

```text
backend/
  src/
    <Product>.Domain/
      Entities/
      ValueObjects/
      Events/
      Rules/

    <Product>.Application/
      Abstractions/
        Services/
        Persistence/
        Integrations/
      Contracts/
        Requests/
        Responses/
      Services/ or Features/
      Validators/
      DependencyInjection.cs

    <Product>.Infrastructure/
      Persistence/
        Repositories/
      Security/
      Integrations/
      Messaging/
      Observability/
      DependencyInjection.cs

    <Product>.Api/
      Controllers/
      Middleware/
      Filters/
      Program.cs

  tests/
    <Product>.Domain.UnitTests/
    <Product>.Application.UnitTests/
    <Product>.Infrastructure.UnitTests/   # when useful
    <Product>.Api.UnitTests/              # thin transport behavior when useful
    <Product>.IntegrationTests/
    <Product>.ArchitectureTests/
```

## API Rules

- Prefer RESTful endpoints with explicit request/response contracts.
- Use Problem Details for HTTP errors.
- Validate all external input.
- Do not expose internal exceptions, secrets or connection details.
- Propagate Correlation ID and authenticated context.
- Keep controllers free of business logic.

## Required Validation

For each backend task, execute when tooling is available:

```text
dotnet --info
dotnet restore
dotnet build --configuration Release --warnaserror
dotnet test --configuration Release
dotnet test --configuration Release --collect:"XPlat Code Coverage"
```

If the project has a coverage script/gate, run that exact gate too.

For repositories with containers, also validate Docker image build and health endpoints.

If the environment cannot run a required command, report it as NOT EXECUTED instead of claiming success.

## Definition of Done - Architecture and Quality

A backend story is not DONE when any of the following is true:

- controller/endpoint contains business logic;
- controller accesses DbContext/repository directly when an application use case is expected;
- Application references concrete Infrastructure;
- Domain references HTTP/EF/external SDK concerns;
- persistence entities leak directly into public API contracts;
- repository contains business orchestration;
- service is an oversized god service or has hidden dependencies;
- secrets are committed;
- required validation/build/tests were not executed and the omission was not explicitly reported;
- configured coverage gate fails;
- no project-specific gate exists and the common baseline 80% line / 70% branch coverage is not met for unit-testable backend code;
- audit/history/metrics responsibilities are mixed without an explicit ADR.

## Required Output

```text
Agent: Backend Application Agent
Task:
Story:
Runtime: .NET 10
Files Read:
Files Created:
Files Modified:
Reuse Classification: REUSE | EXTEND | ADAPT | CREATE | BLOCKED
Architecture Impact:
Layer Dependency Check:
Controller Logic Check:
Repository Boundary Check:
DTO Contract Check:
Security Impact:
Tenant Isolation:
Persistence Impact:
API Impact:
Audit/History/Metrics Impact:
Unit Tests Added:
Coverage Line %:
Coverage Branch %:
Coverage Gate: PASS | FAIL | NOT EXECUTED
Architecture Tests:
Commands Executed:
Validation:
Risks:
Next Step:
```
