# Shared Infrastructure Registry

## Purpose

Inventory reusable infrastructure so projects do not create duplicate databases, message brokers, caches or observability services unnecessarily.

## Reuse principle

Before creating SQL Server, PostgreSQL, MySQL, Redis, RabbitMQ, Kafka, MinIO, Seq, Grafana, Prometheus or equivalent infrastructure, inspect this registry and the active Docker runtimes on the target workstation.

Reuse is allowed only when compatibility, isolation, capacity and operational ownership are acceptable.

## Isolation requirements

- Databases: separate database/schema and project-specific credentials.
- RabbitMQ: separate virtual host, user/permissions and queues/exchanges where practical.
- Kafka: separate topic namespace, consumer groups and ACLs where applicable.
- Redis: separate logical database/prefix only when operationally safe; otherwise provision a dedicated instance.
- Object storage: separate bucket/prefix and credentials.
- Observability: separate service/source labels, dashboards and retention expectations.

## Current known infrastructure

| Runtime | Project/role | Reuse guidance |
| --- | --- | --- |
| AppCondominio SQL Server | Existing persistent SQL Server runtime | Candidate for additional DBs only after compatibility and isolation review |
| Portal SQL Server | Portal persistent SQL Server runtime | Prefer portal-domain workloads; cross-project reuse requires explicit compatibility review |
| AppColoreando PostgreSQL | AppColoreando persistence | Preserve; reuse only if isolation and ownership are appropriate |
| AppColoreando RabbitMQ | Messaging runtime | Candidate for vhost-isolated reuse |
| AppCondominio RabbitMQ | Messaging runtime | Candidate for vhost-isolated reuse |
| AppColoreando Redis | Cache/runtime state | Reuse only with clear key isolation and failure-domain acceptance |
| AppCondominio Redis | Cache/runtime state | Reuse only with clear key isolation and failure-domain acceptance |
| AppColoreando MinIO | Object storage | Candidate for bucket-isolated reuse |
| AppColoreando Grafana/Prometheus | Observability | Candidate for multi-project metrics/dashboards if configuration remains isolated |
| AppCondominio Seq | Logging | Candidate for multi-project logging using application/source labels |

## Runtime discovery always wins

This file may become stale. Before reuse or creation, inspect actual containers, images, ports, health, versions and volumes on `trabajo`, `MarketingIndo` and any other active implementation machine.

Update this registry when a shared infrastructure decision becomes stable.
