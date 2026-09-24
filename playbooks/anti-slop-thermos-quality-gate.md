# Anti-Slop + Thermos Quality Gate

## Goal

Provide a reusable post-implementation hardening flow for all projects governed by CodexCommonAgents.

## Flow

```text
1. Establish changed scope and base/head revisions.
2. Run project-native tests, linters, analyzers and build.
3. Run Anti-Slop on relevant changed surfaces.
4. Apply only evidenced Anti-Slop fixes.
5. Run Thermos correctness/security and code-quality lanes.
6. Deduplicate findings.
7. Fix Critical/High findings before integration.
8. Re-run affected tests and static analysis.
9. Record residual Medium/Low findings with ownership.
10. Mark the gate PASS only when evidence supports it.
```

## Mandatory triggers

Use Thermos for:
- auth/authz/security changes
- financial or personally sensitive data flows
- migrations/schema changes
- production infrastructure
- cross-cutting refactors
- release candidates with material code changes

Use Anti-Slop for:
- UI/UX/copy work
- generated code with substantial boilerplate
- large AI-assisted implementations
- code with low-value narrative comments or generic abstractions

## Gate policy

A Critical or High Thermos finding blocks integration until fixed or explicitly accepted by the project owner with rationale.

Anti-Slop findings block only when they violate project design rules, accessibility, correctness, maintainability, or the upstream hard-gate rules being intentionally used for the task.

Neither agent replaces:
- build
- unit tests
- integration/E2E tests
- security scanning
- architecture rules
- runtime validation

## Evidence

Record:
- base/head revision
- changed files
- tools/versions used
- findings and severity
- fixes applied
- commands/tests rerun
- final result
