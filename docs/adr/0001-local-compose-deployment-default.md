# ADR 0001: Local Docker Compose as the deployment default

Date: 2026-09-17
Status: Proposed for integration, implementing explicit user direction

## Context

The user requires all deployments to be local with Docker Compose. Existing delivery governance couples shared-image delivery to GitHub Actions; hosted-runner billing failures can prevent execution even when code is valid.

## Decision

Make local Compose the general runtime destination and assign ownership to the Integration Release Agent. Hosted CI remains optional automation, not runtime hosting. Cloud/remote deployment and spending changes require explicit user direction. Preserve mandatory quality gates, private registry requirements for shared artifacts, immutable image identity, stateful data safety and critical activation approvals.

## Alternatives

Mandatory hosted delivery retains avoidable runner dependency. Automatically migrating to cloud contradicts the user's direction. Removing quality gates to unblock delivery is unsafe and rejected.

## Consequences

Local validation can progress with equivalent recorded gates, but does not override protected checks. A local candidate is not a synchronized shared release. Unavailable target workstations and private-data/Desktop acceptance remain pending. Existing cloud assets are preserved rather than silently removed.
