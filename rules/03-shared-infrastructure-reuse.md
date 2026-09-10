# Shared Infrastructure Reuse Policy

## Scope

This rule applies whenever a project needs infrastructure services such as SQL Server, PostgreSQL, MySQL, Redis, RabbitMQ, Kafka, MinIO, Seq, Grafana, Prometheus or equivalent shared runtime dependencies.

## Reuse-first principle

Before creating a new infrastructure image, container, network endpoint or local runtime dependency, Codex must inspect the current machine and the approved shared runtime definitions to determine whether a compatible service already exists.

The default decision order is:

1. Reuse an existing approved image when the required engine/version is compatible.
2. Reuse an existing running container only when it is intentionally suitable for shared use, healthy, reachable and compatible with the new project.
3. Reuse an existing server/runtime while creating isolated logical resources for the new project.
4. Create a new container only when reuse is unsafe, incompatible, operationally coupled or explicitly prohibited by the target project.

## Database reuse

If a compatible database engine/container already exists, prefer reusing the existing database server instance instead of starting another engine instance solely for a new project.

Reuse must preserve logical isolation. Each project should normally receive its own database, schema, credentials and permissions as appropriate. Projects must not share business tables or couple domains through the same schema unless this is an explicitly approved architecture decision.

Never reuse or overwrite another project's database, volume or credentials implicitly.

## RabbitMQ reuse

If a healthy compatible RabbitMQ service already exists, prefer reusing it rather than creating another RabbitMQ container.

Projects should be isolated through dedicated virtual hosts, users, permissions, exchanges, queues and routing keys as appropriate.

Do not reuse queues or credentials from another project unless the integration contract explicitly requires it.

## Kafka reuse

If a healthy compatible Kafka cluster/runtime already exists, prefer reusing it rather than starting another local Kafka stack.

Projects should use isolated topic namespaces, ACLs, consumer groups and configuration boundaries. Existing topics must not be repurposed for a different domain without an explicit integration contract.

## Stateful-service safety

Reuse does not mean destructive consolidation. Existing data, volumes, topics, queues and credentials are protected resources.

Codex must not stop, recreate, upgrade, delete or reconfigure an existing shared infrastructure service merely to make it fit a new project without first evaluating impact on every dependent project.

## Multi-machine rule

For `trabajo` and `MarketingIndo`, Codex should aim to reproduce the same logical infrastructure topology while reusing compatible local shared services where practical.

Project-owned application images remain governed by Docker Hub publication and digest pinning. Shared infrastructure images should use approved upstream registry images or approved internal mirrors and should avoid unnecessary duplicate pulls/builds.

## Required discovery before creation

Before adding a new database, RabbitMQ, Kafka or similar infrastructure service, Codex must inspect at minimum:

```text
docker ps -a
docker images
docker network ls
docker volume ls
```

When applicable, it must also inspect Compose project labels, exposed ports, image versions, health status and existing logical resources before deciding between REUSE and CREATE.

## Decision output

For every new infrastructure dependency, Codex must report:

```text
Infrastructure Requested:
Existing Compatible Runtime Found:
Reuse Decision: REUSE | CREATE | BLOCKED
Existing Container/Image Reused:
Isolation Strategy:
Data/Volume Impact:
Dependent Projects Checked:
Reason If New Container Is Required:
```
