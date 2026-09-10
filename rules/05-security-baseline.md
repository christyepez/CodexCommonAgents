# Security Engineering Baseline

Applies to all projects governed by CodexCommonAgents.

## Mandatory controls

- Authentication and authorization are enforced server-side.
- Secrets must never be committed; use environment variables or approved secret stores.
- Enable dependency scanning, secret scanning and SAST where tooling is available.
- Produce an SBOM for release images/artifacts when supported.
- Containerized services should run as non-root where practical and with least privilege.
- Restrict CORS, exposed ports and network access to the minimum required.
- Validate all external input and return sanitized errors.
- Use TLS for external traffic and protect internal credentials in transit when required.
- Do not log tokens, passwords, connection strings, API keys or sensitive payloads.
- Use explicit authorization policies for roles, permissions and tenant boundaries.

## Security review trigger

Changes touching identity, permissions, secrets, payments, PII, external integrations, deserialization, file upload, messaging, database migrations or production infrastructure require explicit security review.

## Definition of Done

A change is not DONE if known critical/high vulnerabilities, exposed secrets, broken authorization boundaries or unsafe container/runtime settings remain without an approved documented exception.
