# Docker Port Registry

## Purpose

Prevent accidental host-port collisions between projects and identify shared infrastructure before creating duplicate runtimes.

## Policy

Before assigning a host port, inspect active Docker containers on the target workstation and this registry.

Reserve ports per project/runtime and prefer `127.0.0.1:<host-port>:<container-port>` for infrastructure and administrative services.

When an existing shared service can safely satisfy the requirement, reuse it rather than allocating another host port.

## Current known examples

| Service | Project | Host port(s) | Notes |
| --- | --- | --- | --- |
| AppColoreando API | AppColoreando | 8080 | Application API |
| AppColoreando Web | AppColoreando | 8083 | Web runtime |
| AppColoreando Visual Processor | AppColoreando | 8090 | Processing API |
| AppCondominio Web | AppCondominio | 4208 | Web runtime |
| AppCondominio API | AppCondominio | 8088 | Application API |
| AppCondominio SQL Server | AppCondominio | 14338 | Persistent infrastructure; preserve data |
| AppCondominio Redis | AppCondominio | 6388 | Prefer reuse only with safe logical isolation |
| AppCondominio RabbitMQ | AppCondominio | 5678 / 15678 | AMQP / management |
| AppCondominio Seq | AppCondominio | 5348 | Observability |

## Maintenance

This registry is descriptive, not a substitute for runtime discovery. Agents must confirm actual port bindings before deployment and update this file when permanent allocations change.
