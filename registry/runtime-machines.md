# Runtime Machines Registry

## Purpose

Track workstations used for project implementation and runtime validation.

## Current machines

| Machine | Role | Expected usage |
| --- | --- | --- |
| `trabajo` | Primary implementation workstation | Development, testing, Docker runtime validation |
| `MarketingIndo` | Secondary implementation workstation | Parallel development, testing, Docker runtime validation |

## Rule

For a shared logical environment, project-owned container images must resolve to the same intended immutable version/digest on all active machines.

Docker Desktop is a local execution/cache layer. Docker Hub or the approved registry is the shared image source of truth.

Additional workstations should be added here when they become part of active implementation.
