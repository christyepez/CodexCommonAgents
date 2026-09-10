# AGENTS.md - Codex Common Agents

## Proposito

Este archivo define las reglas comunes que Codex debe aplicar en todos los repositorios que usen este estandar.

## Lectura obligatoria

Codex debe leer primero:

```text
README.md
rules/00-global-rules.md
registry/reusable-portal-apis.md
registry/do-not-duplicate.md
playbooks/portal-first-implementation.md
```

Para cualquier tarea que use Docker, Docker Compose o imagenes de contenedores, la lectura obligatoria tambien incluye:

```text
rules/02-docker-runtime-and-image-governance.md
rules/03-shared-infrastructure-reuse.md
playbooks/docker-multi-machine-runtime.md
```

Despues debe leer el playbook del dominio correspondiente y el agente especializado que aplique a la tarea.

Para tareas backend, la lectura obligatoria incluye:

```text
agents/03-backend-agent.md
```

## Baseline backend

Para nuevos componentes backend, salvo excepcion expresamente aprobada y documentada por el repositorio del proyecto, el baseline comun es:

```text
.NET 10
ASP.NET Core 10
TargetFramework: net10.0
```

Deben utilizarse paquetes estables compatibles con la linea 10.x. No se deben introducir paquetes preview en codigo productivo sin autorizacion explicita.

## Baseline Docker y multi-equipo

Todo proyecto contenedorizado debe poder ejecutarse de forma reproducible en distintos equipos sin depender de builds locales divergentes.

Para servicios propios del proyecto, Codex debe preferir imagenes publicadas en el registro con tags inmutables por revision y, cuando se requiera igualdad exacta entre equipos, referencias por digest `repository@sha256:...`.

Un proyecto que use Docker Compose debe mantener una separacion entre topologia/base de desarrollo y runtime desde registro, normalmente mediante `docker-compose.yml` + `docker-compose.hub.yml` o equivalente.

No se deben eliminar imagenes propias sin comprobar recuperabilidad remota exacta. Si no existe, debe publicarse primero un tag inmutable de respaldo.

Las bases de datos y volumenes persistentes no forman parte de una limpieza rutinaria y deben preservarse salvo autorizacion expresa.

Antes de crear una nueva dependencia de infraestructura como base de datos, RabbitMQ, Kafka, Redis, MinIO, Seq, Grafana o Prometheus, Codex debe revisar si existe un runtime compatible que pueda reutilizarse de forma segura. La regla por defecto es REUSE antes que CREATE, manteniendo aislamiento logico por proyecto y sin reutilizar destructivamente datos, credenciales, colas, topics o volumenes de otro dominio.

## Regla principal

Antes de crear cualquier componente, Codex debe revisar si existe una capacidad reutilizable en `PortalCorporativo`.

Clasificacion obligatoria:

```text
REUSE   = usar directamente componente del portal.
EXTEND  = extender configuracion, catalogos, menus, permisos o metadata.
ADAPT   = crear adaptador hacia API o servicio del portal.
CREATE  = crear porque pertenece al dominio y no existe en portal.
BLOCKED = detener hasta revisar dependencia, contrato o capacidad del portal.
```

## Prohibido

- Duplicar login, usuarios, roles o permisos globales.
- Duplicar motor de menus, configuracion visual, auditoria o notificaciones.
- Implementar autorizacion solo en frontend.
- Quemar menus, colores, logos, formularios, grids, columnas, botones o catalogos en codigo.
- Acoplar dominios mediante bases de datos compartidas.
- Guardar secretos en codigo, repositorio o archivos `.env` versionados.
- Crear integraciones externas sin contratos, adaptadores y reintentos.
- Crear nuevos componentes backend en frameworks anteriores a .NET 10 sin una excepcion aprobada y documentada.
- Usar `latest` como unica referencia de imagen para runtimes que deban ser reproducibles entre equipos.
- Ejecutar `docker system prune -a --volumes` como mecanismo rutinario de limpieza.
- Crear una nueva instancia de SQL Server, PostgreSQL, MySQL, RabbitMQ, Kafka, Redis u otro servicio de infraestructura sin comprobar primero si existe una instancia compatible y reutilizable.
- Reutilizar una infraestructura existente destruyendo o mezclando datos, schemas, credenciales, colas, topics o volumenes de proyectos distintos.

## Salida esperada de Codex

Cada ejecucion debe terminar con:

```text
Agent:
Task:
Files Read:
Files Created:
Files Modified:
Portal Capability Checked:
Reuse Classification:
Portal Components Reused:
Portal Components Extended:
New Components Created:
Reason for New Components:
Security Impact:
Audit Impact:
Notification Impact:
Menu Impact:
Configuration Impact:
Tests Added:
Commands Executed:
Risks:
Next Step:
```

Para tareas Docker debe agregar ademas:

```text
Runtime Machine(s):
Registry Recoverability Checked:
Digests Pinned:
Infrastructure Reuse Checked:
Existing Infrastructure Reused:
Isolation Strategy:
Persistent Volumes Preserved:
Health Validation:
```

## Modo bajo consumo de tokens

Codex debe leer solo los archivos necesarios para la tarea. Si necesita mas contexto, debe justificar que archivo adicional va a leer y por que.
