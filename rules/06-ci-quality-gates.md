# CI Quality Gates

All projects must define automated gates appropriate to their stack.

## Minimum gates

- Restore/install dependencies successfully.
- Build in Release/production mode with warnings treated as errors where practical.
- Run unit tests.
- Enforce configured coverage thresholds.
- Run lint/static analysis.
- Run architecture tests for layered backends.
- Run integration/contract tests when external boundaries are affected.
- Validate container build and health for containerized services.

## Default backend coverage

If the project has no stricter threshold, require at least 80% line coverage and 70% branch coverage overall, and target >=90% for new/modified Domain and Application code where reasonable.

## Pull request rule

A PR must not be considered ready for integration while mandatory gates are red. Required checks may only be bypassed through a documented exception with owner, reason, risk and expiration date.

## Technical debt hygiene

Critical TODO/FIXME markers, dead commented code, temporary endpoints, production mocks and test credentials must not enter integration branches unless explicitly tracked and approved.
