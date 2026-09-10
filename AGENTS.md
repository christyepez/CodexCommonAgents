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
registry/runtime-machines.md
registry/shared-infrastructure.md
registry/docker-port-registry.md
registry/docker-image-registry.md
playbooks/docker-multi-machine-runtime.md
```

Para nuevos proyectos o implementaciones con trabajo paralelo, la lectura obligatoria tambien incluye:

```text
rules/04-project-chat-and-parallel-agent-execution.md
playbooks/parallel-project-execution.md
templates/PROJECT_CONTEXT.md
templates/PARALLEL_EXECUTION_BOARD.md
```

Para tareas de ingenieria, la lectura obligatoria debe incluir las reglas transversales que correspondan al cambio:

```text
rules/05-security-baseline.md
rules/06-ci-quality-gates.md
rules/07-api-and-contract-governance.md
rules/08-observability-and-resilience.md
rules/09-data-and-migration-governance.md
rules/10-release-and-versioning.md
rules/11-agent-ownership-and-change-control.md
```

No es necesario leer todos los documentos completos en cada tarea: Codex debe seleccionar los aplicables segun el alcance y riesgo, manteniendo bajo consumo de tokens sin omitir controles obligatorios.

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

Despues debe leer el playbook del dominio correspondiente y el agente especializado que aplique a la tarea.

Para tareas backend, la lectura obligatoria incluye:

```text
agents/03-backend-agent.md
rules/01-backend-clean-architecture.md
rules/05-security-baseline.md
rules/06-ci-quality-gates.md
rules/07-api-and-contract-governance.md
rules/08-observability-and-resilience.md
rules/09-data-and-migration-governance.md
```

## Baseline backend

Para nuevos componentes backend, salvo excepcion expresamente aprobada y documentada por el repositorio del proyecto, el baseline comun es:

```text
.NET 10
ASP.NET Core 10
TargetFramework: net10.0
```

Deben utilizarse paquetes estables compatibles con la linea 10.x. No se deben introducir paquetes preview en codigo productivo sin autorizacion explicita.

Todo backend debe respetar Clean Architecture con Domain, Application, Infrastructure y API; usar interfaces para servicios/repositorios; DTOs separados de entidades de persistencia; controladores/endpoints sin logica de negocio; acceso a persistencia a traves de repositorios/abstracciones; y pruebas unitarias, arquitectura e integracion segun riesgo.

Si el proyecto no define un umbral mayor, el quality gate comun es 80% line coverage y 70% branch coverage, apuntando a >=90% sobre codigo nuevo/modificado de Domain/Application cuando sea razonable.

## Baseline de seguridad y calidad

Todo cambio debe aplicar security-by-default, quality gates automatizados y manejo explicito de riesgo.

Las tareas que afecten identidad, permisos, secretos, PII, datos financieros, migraciones, mensajeria, integraciones externas o infraestructura productiva requieren revision de seguridad acorde a su criticidad.

Los PRs no se consideran listos para integracion mientras fallen gates obligatorios de build, tests, coverage, analisis estatico, arquitectura, contratos o seguridad aplicables.

Los contratos HTTP, OpenAPI, eventos Kafka/RabbitMQ y esquemas compartidos son activos versionados. Los agentes que dependan de ellos deben acordarlos antes de avanzar en paralelo.

## Baseline Docker y multi-equipo

Todo proyecto contenedorizado debe poder ejecutarse de forma reproducible en distintos equipos sin depender de builds locales divergentes.

Para servicios propios del proyecto, Codex debe preferir imagenes publicadas en el registro con tags inmutables por revision y, cuando se requiera igualdad exacta entre equipos, referencias por digest `repository@sha256:...`.

Un proyecto que use Docker Compose debe mantener una separacion entre topologia/base de desarrollo y runtime desde registro, normalmente mediante `docker-compose.yml` + `docker-compose.hub.yml` o equivalente.

Todo Docker propio creado como parte de una implementacion compartida debe publicarse en Docker Hub o el registro aprobado antes de considerarse artefacto reusable. `trabajo` y `MarketingIndo` son actualmente los equipos de referencia y deben poder levantar el mismo runtime desde registro.

Docker Desktop es entorno local de ejecucion/cache y se usa cuando sea necesario; no es la fuente autoritativa de imagenes compartidas.

No se deben eliminar imagenes propias sin comprobar recuperabilidad remota exacta. Si no existe, debe publicarse primero un tag inmutable de respaldo.

Las bases de datos y volumenes persistentes no forman parte de una limpieza rutinaria y deben preservarse salvo autorizacion expresa.

Antes de crear una nueva dependencia de infraestructura como base de datos, RabbitMQ, Kafka, Redis, MinIO, Seq, Grafana o Prometheus, Codex debe revisar si existe un runtime compatible que pueda reutilizarse de forma segura. La regla por defecto es REUSE antes que CREATE, manteniendo aislamiento logico por proyecto y sin reutilizar destructivamente datos, credenciales, colas, topics o volumenes de otro dominio.

## Baseline de datos y resiliencia

Cada bounded context es propietario de su esquema/modelo. Compartir servidor o infraestructura no autoriza compartir tablas, credenciales o acceso irrestricto a datos.

Las migraciones deben versionarse, privilegiar compatibilidad hacia atras y documentar rollback o forward-fix cuando el riesgo lo requiera. Cambios destructivos deben validar respaldo/recuperabilidad antes de ejecutarse.

Integraciones deben definir timeouts, retries para fallas transitorias, idempotencia cuando aplique, circuit breaker cuando exista riesgo de cascada y outbox/inbox cuando la consistencia de eventos lo justifique.

Servicios relevantes deben disponer de logs estructurados, correlation/trace IDs, health checks, metricas y tracing cuando el stack lo permita.

## Baseline de release

Una release debe ser trazable a una revision Git inmutable, promover el mismo artefacto entre ambientes cuando sea posible y registrar version/digest, migraciones, configuracion, riesgos y evidencia de validacion.

Cambios HIGH o CRITICAL pueden requerir aprobacion humana explicita. Ningun agente puede inventar ni inferir una aprobacion que no exista.

## Baseline de proyecto y trabajo paralelo

Cuando se inicia un nuevo proyecto, debe organizarse en un ChatGPT Project/carpeta de proyecto cuando la interfaz lo permita. Dentro de ese espacio, cada agente o stream especializado debe trabajar en su propio chat/hilo cuando el paralelismo sea seguro.

El hilo `00 - Project Orchestrator` coordina roadmap, dependencias, contratos, ramas/PRs, integracion y estado global. Los hilos especializados no sustituyen al repositorio: Git, PRs, ADRs, pruebas y artefactos publicados son la fuente de verdad de implementacion.

Los agentes pueden avanzar en paralelo solamente cuando existe ownership claro y contratos estables. Cambios de alto conflicto sobre los mismos archivos, schemas, migraciones, contratos o manifiestos deben serializarse o coordinarse primero.

Cada agente debe declarar ownership de archivos/componentes y clasificar el cambio como LOW, MEDIUM, HIGH o CRITICAL. `Ready for Integration` requiere evidencia en Git/PR, pruebas ejecutadas, impacto contractual, riesgos y bloqueos.

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
- Crear integraciones externas sin contratos, adaptadores y politicas de resiliencia.
- Crear nuevos componentes backend en frameworks anteriores a .NET 10 sin una excepcion aprobada y documentada.
- Usar `latest` como unica referencia de imagen para runtimes que deban ser reproducibles entre equipos.
- Ejecutar `docker system prune -a --volumes` como mecanismo rutinario de limpieza.
- Crear una nueva instancia de SQL Server, PostgreSQL, MySQL, RabbitMQ, Kafka, Redis u otro servicio de infraestructura sin comprobar primero si existe una instancia compatible y reutilizable.
- Reutilizar una infraestructura existente destruyendo o mezclando datos, schemas, credenciales, colas, topics o volumenes de proyectos distintos.
- Dar por terminada una tarea multi-equipo cuando su imagen Docker propia solo existe localmente.
- Dar por integrada una tarea solo porque un chat/agente la reporta terminada sin evidencia en repositorio y validaciones.
- Integrar cambios con gates obligatorios fallidos sin una excepcion documentada y aprobada.
- Introducir TODO/FIXME criticos, codigo comentado muerto, endpoints temporales, mocks productivos o credenciales de prueba en ramas de integracion sin seguimiento/aprobacion explicita.
- Modificar en paralelo el mismo contrato, migracion, manifiesto o archivo de alto conflicto sin coordinacion del Project Orchestrator.
- Exponer entidades de persistencia directamente como contratos publicos de API.
- Ejecutar cambios destructivos de datos sin evaluar recuperabilidad/rollback apropiado al ambiente.

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
Risk Classification:
Audit Impact:
Notification Impact:
Menu Impact:
Configuration Impact:
Contracts Impact:
Data/Migration Impact:
Observability/Resilience Impact:
Tests Added:
Coverage:
Quality Gates:
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

Para trabajo paralelo debe agregar ademas:

```text
Project Workspace:
Agent Thread:
Base Revision:
Branch/PR:
Owned Files/Components:
Parallel Dependencies:
Contracts Changed:
Ready for Integration:
```

Para release debe agregar ademas:

```text
Release Revision:
Artifact/Image Version:
Remote Digest:
Migration Status:
Rollback/Forward-Fix Plan:
Human Approval Required:
Human Approval Evidence:
```

## Modo bajo consumo de tokens

Codex debe leer solo los archivos necesarios para la tarea. Si necesita mas contexto, debe justificar que archivo adicional va a leer y por que.
