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
rules/12-github-actions-delivery-and-docker-desktop-environments.md
rules/13-dev-test-environment-separation.md
registry/runtime-machines.md
registry/shared-infrastructure.md
registry/docker-port-registry.md
registry/docker-image-registry.md
playbooks/docker-multi-machine-runtime.md
playbooks/github-actions-to-docker-desktop.md
```

Para nuevos proyectos o implementaciones con trabajo paralelo, la lectura obligatoria tambien incluye:

```text
rules/04-project-chat-and-parallel-agent-execution.md
playbooks/parallel-project-execution.md
templates/PROJECT_CONTEXT.md
templates/PARALLEL_EXECUTION_BOARD.md
```

Para tareas de seguridad, calidad, APIs, resiliencia, datos, release o coordinacion entre agentes, deben leerse tambien las reglas especializadas correspondientes:

```text
rules/05-security-baseline.md
rules/06-ci-quality-gates.md
rules/07-api-and-contract-governance.md
rules/08-observability-and-resilience.md
rules/09-data-and-migration-governance.md
rules/10-release-and-versioning.md
rules/11-agent-ownership-and-change-control.md
```

## Flujo obligatorio para nuevos proyectos

Todo proyecto nuevo debe iniciar con el siguiente orden logico:

```text
1. agents/00-project-bootstrap-agent.md
2. agents/01-project-orchestrator-agent.md
3. agentes especializados requeridos por el proyecto
4. agents/09-integration-release-agent.md si existe o el stream equivalente de integracion/release
```

El Project Bootstrap Agent debe preparar el contexto, arquitectura inicial, repositorio, estrategia Docker, reutilizacion de infraestructura, puertos, plan de agentes, waves y Definition of Done.

El Project Orchestrator Agent debe mantener el tablero de ejecucion paralelo, coordinar dependencias, ramas/PRs, ownership de archivos, integracion, bloqueos, paridad Docker Hub y estado global.

Todo proyecto nuevo debe crear o adaptar en su repositorio:

```text
codex/PROJECT_CONTEXT.md
codex/PARALLEL_EXECUTION_BOARD.md
```

usando como base las plantillas comunes. Si el proyecto ya posee documentos equivalentes, deben integrarse sin duplicar fuentes de verdad.

## Baseline backend

Para nuevos componentes backend, salvo excepcion expresamente aprobada y documentada por el repositorio del proyecto, el baseline comun es:

```text
.NET 10
ASP.NET Core 10
TargetFramework: net10.0
```

Deben utilizarse paquetes estables compatibles con la linea 10.x. No se deben introducir paquetes preview en codigo productivo sin autorizacion explicita.

Toda implementacion backend gobernada debe cumplir `rules/01-backend-clean-architecture.md` y `agents/03-backend-agent.md`.

## Baseline Docker y multi-equipo

Todo proyecto contenedorizado debe poder ejecutarse de forma reproducible en distintos equipos sin depender de builds locales divergentes.

Para servicios propios del proyecto, Codex debe preferir imagenes publicadas en el registro con tags inmutables por revision y, cuando se requiera igualdad exacta entre equipos, referencias por digest `repository@sha256:...`.

Un proyecto que use Docker Compose debe mantener una separacion entre topologia/base de desarrollo y runtime desde registro, normalmente mediante `docker-compose.yml` + `docker-compose.hub.yml` o equivalente.

Todo Docker propio creado como parte de una implementacion compartida debe publicarse en Docker Hub o el registro aprobado antes de considerarse artefacto reusable. `trabajo` y `MarketingIndo` son actualmente los equipos de referencia y deben poder levantar el mismo runtime desde registro.

Los repositorios Docker Hub propios deben ser PRIVADOS por defecto. Solo pueden ser PUBLICOS cuando exista una aprobacion explicita a nivel de proyecto y una justificacion documentada. Si no hay aprobacion explicita, la visibilidad requerida es PRIVATE.

Docker Desktop es entorno local de ejecucion/cache y se usa cuando sea necesario; no es la fuente autoritativa de imagenes compartidas.

GitHub es la fuente autoritativa para codigo, PRs, quality gates, workflows y metadata de release. GitHub Actions debe ser el mecanismo preferido para construir y publicar imagenes compartidas a Docker Hub. Docker Desktop en `trabajo` y `MarketingIndo` se usa como entorno de desarrollo, integracion y pruebas, consumiendo imagenes publicadas y reproducibles.

DEV y TEST deben estar logicamente separados aun cuando compartan workstation e infraestructura fisica compatible. Deben diferenciar configuracion, datos, puertos y namespaces, y consumir el mismo digest candidato cuando se valida una release.

No se deben eliminar imagenes propias sin comprobar recuperabilidad remota exacta. Si no existe, debe publicarse primero un tag inmutable de respaldo.

Las bases de datos y volumenes persistentes no forman parte de una limpieza rutinaria y deben preservarse salvo autorizacion expresa.

Antes de crear una nueva dependencia de infraestructura como base de datos, RabbitMQ, Kafka, Redis, MinIO, Seq, Grafana o Prometheus, Codex debe revisar si existe un runtime compatible que pueda reutilizarse de forma segura. La regla por defecto es REUSE antes que CREATE, manteniendo aislamiento logico por proyecto y sin reutilizar destructivamente datos, credenciales, colas, topics o volumenes de otro dominio.

## Baseline de proyecto y trabajo paralelo

Cuando se inicia un nuevo proyecto, debe organizarse en un ChatGPT Project/carpeta de proyecto cuando la interfaz lo permita. Dentro de ese espacio, cada agente o stream especializado debe trabajar en su propio chat/hilo cuando el paralelismo sea seguro.

El hilo `00 - Project Orchestrator` coordina roadmap, dependencias, contratos, ramas/PRs, integracion y estado global. Los hilos especializados no sustituyen al repositorio: Git, PRs, ADRs, pruebas y artefactos publicados son la fuente de verdad de implementacion.

Los agentes pueden avanzar en paralelo solamente cuando existe ownership claro y contratos estables. Cambios de alto conflicto sobre los mismos archivos, schemas, migraciones, contratos o manifiestos deben serializarse o coordinarse primero.

Si la interfaz no permite crear chats/carpetas programaticamente, Codex debe entregar la estructura exacta recomendada sin afirmar que la creo.

## Regla principal

Antes de crear cualquier componente, Codex debe revisar si existe una capacidad reutilizable en `PortalCorporativo`.

Clasificacion obligatoria:

```text
REUSE   = usar directamente componente del portal.
EXTEND  = extender configuracion, catalogos, menus, permisos o metadata.
ADAPT   = crear adaptador hacia API o servicio reutilizable.
CREATE  = crear componente nuevo del dominio.
BLOCKED = no continuar hasta revisar el portal o resolver dependencia.
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
- Dar por terminada una tarea multi-equipo cuando su imagen Docker propia solo existe localmente.
- Dar por integrada una tarea solo porque un chat/agente la reporta terminada sin evidencia en repositorio y validaciones.
- Considerar Docker Desktop como repositorio autoritativo de imagenes compartidas.
- Publicar como runtime compartido una imagen generada desde GitHub cuando los quality gates requeridos esten fallando.
- Crear o mantener un repositorio Docker Hub propio como PUBLICO sin aprobacion explicita y justificacion documentada.
- Incluir credenciales Docker Hub en codigo, Dockerfile, Compose, scripts versionados o `.env` trackeados.
- Validar una release en TEST usando un digest distinto del candidato que se pretende promover.

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
Docker Hub Visibility: PRIVATE | PUBLIC-APPROVED | NOT-VERIFIED
Digests Pinned:
Infrastructure Reuse Checked:
Existing Infrastructure Reused:
Isolation Strategy:
Persistent Volumes Preserved:
Health Validation:
```

Para entrega GitHub -> Docker debe agregar ademas:

```text
GitHub Revision:
Workflow:
Quality Gates:
Images Published:
Docker Hub Visibility:
Docker Hub Digests:
Target Environment:
Target Workstation(s):
Runtime Digest Match:
```

Para trabajo paralelo debe agregar ademas:

```text
Project Workspace:
Agent Thread:
Base Revision:
Branch/PR:
Parallel Dependencies:
Contracts Changed:
Ready for Integration:
```

## Modo bajo consumo de tokens

Codex debe leer solo los archivos necesarios para la tarea. Si necesita mas contexto, debe justificar que archivo adicional va a leer y por que.
