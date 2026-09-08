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

## Controller / Endpoint Rules

Controllers and endpoints MUST be thin.

Allowed responsibilities:

- receive HTTP input;
- bind/validate transport contracts;
- obtain authenticated/tenant context;
- call one application use case/service;
- map result to HTTP status/ProblemDetails.

Forbidden responsibilities:

- direct DbContext access;
- EF Core queries;
- business calculations;
- workflow orchestration;
- audit persistence logic;
- metrics aggregation logic;
- token generation logic;
- object persistence logic;
- large inline mapping/business branches.

`Program.cs` MUST be a composition root only: dependency registration, middleware, authentication/authorization, observability, health checks, OpenAPI and application startup wiring. Do not implement use cases in `Program.cs`.

## Application Rules

- Implement use cases through application services, handlers or vertical slices.
- Define external dependencies as interfaces/ports in Application unless the abstraction is intrinsically domain-level.
- Use explicit Request/Response DTOs and do not expose EF/persistence entities through API contracts.
- Keep mappings explicit unless a project standard authorizes a mapping library.
- Propagate `CancellationToken` on I/O-bound application operations.
- Prefer pragmatic CQRS; do not add MediatR, generic pipelines or abstractions without value.
- Application coordinates; it does not own infrastructure implementation details.

## Repository and Persistence Rules

- Repositories are persistence ports, not containers for business logic.
- Prefer specific repositories/query interfaces when use cases require meaningful domain queries.
- Use generic repositories only where they reduce repetition without hiding important persistence semantics.
- EF Core `DbContext` is the Unit of Work by default; do not wrap it in a ceremonial UnitOfWork abstraction unless multiple stores or an explicit transactional boundary requires it.
- EF Core configurations, migrations, interceptors and provider-specific code belong in Infrastructure.
- SQL Server is the default relational engine when the target project is aligned with PortalCorporativo; PostgreSQL is allowed when explicitly selected by the project.
- Each bounded context owns its persistence model/schema.
- A module must not directly read or write another module's tables.
- Application defines ports; Infrastructure implements them.

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

Do not create `*Service` classes that merely proxy a repository with no application responsibility.

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

## Architecture Tests

Backend solutions SHOULD include automated architecture tests that verify at minimum:

- Domain does not reference Infrastructure/API.
- Application does not reference Infrastructure/API.
- Controllers do not reference DbContext or EF Core.
- Infrastructure is the only layer containing provider-specific persistence code.
- API does not contain domain entities or repository implementations.

A structural violation is a build/review defect, not a stylistic preference.

## Required Backend Shape

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
      Contracts/
      Services/ or Features/
      Validators/
      DependencyInjection.cs

    <Product>.Infrastructure/
      Persistence/
      Repositories/
      Security/
      Integrations/
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
    <Product>.IntegrationTests/
    <Product>.ArchitectureTests/
```

## API Rules

- Prefer RESTful endpoints with explicit request/response contracts.
- Use Problem Details for HTTP errors.
- Validate all external input.
- Do not expose internal exceptions, secrets or connection details.
- Propagate Correlation ID and authenticated context.

## Required Validation

For each backend task, execute when tooling is available:

```text
dotnet --info
dotnet restore
dotnet build --configuration Release --warnaserror
dotnet test --configuration Release
```

For repositories with containers, also validate Docker image build and health endpoints.

If the environment cannot run a required command, report it as NOT EXECUTED instead of claiming success.

## Definition of Done - Architecture

A backend story is not DONE when any of the following is true:

- controller/endpoint contains business logic;
- controller accesses DbContext/repository directly when an application use case is expected;
- Application references concrete Infrastructure;
- Domain references HTTP/EF/external SDK concerns;
- persistence entities leak directly into public API contracts;
- secrets are committed;
- required validation/build/tests were not executed and the omission was not explicitly reported;
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
Security Impact:
Tenant Isolation:
Persistence Impact:
API Impact:
Audit/History/Metrics Impact:
Tests Added:
Commands Executed:
Validation:
Risks:
Next Step:
```
