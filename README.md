# Codex Common Agents

Repositorio comun para centralizar agentes, reglas, playbooks, templates y contratos reutilizables por Codex en proyectos de arquitectura empresarial.

## Objetivo

Evitar que cada repositorio vuelva a definir la misma arquitectura, reglas de calidad, seguridad, DevOps, frontend, backend e integracion con `PortalCorporativo`.

Este repositorio debe ser usado por:

- `PortalCorporativo`
- `Financiero`
- `CRM`
- `AppCondominio`
- `AppColoreando`
- futuros dominios, productos o modulos corporativos

## Principio central

`PortalCorporativo` es la plataforma transversal.

Los repositorios de dominio solo deben implementar capacidades propias del negocio. Antes de crear cualquier componente, Codex debe clasificar la decision como:

```text
REUSE   = usar componente existente del portal.
EXTEND  = extender configuracion, permisos, menus, catalogos o metadata.
ADAPT   = crear adaptador hacia una API/servicio reutilizable.
CREATE  = crear componente nuevo del dominio.
BLOCKED = no continuar hasta revisar el portal o resolver dependencia.
```

## Como usarlo en un proyecto

Cada repositorio debe tener un `AGENTS.md` local que lea este repositorio comun como contrato base.

Lectura minima recomendada para Codex:

```text
1. AGENTS.md del proyecto actual.
2. codex/PROJECT_CONTEXT.md del proyecto actual, si existe.
3. CodexCommonAgents/AGENTS.md.
4. CodexCommonAgents/registry/reusable-portal-apis.md.
5. CodexCommonAgents/playbooks/portal-first-implementation.md.
6. Playbook especifico del dominio, si existe.
```

Para tareas Docker/Compose o entornos multi-equipo se deben leer ademas:

```text
CodexCommonAgents/rules/02-docker-runtime-and-image-governance.md
CodexCommonAgents/playbooks/docker-multi-machine-runtime.md
```

Para analisis amplio de codigo, arquitectura, dependencias, impacto o refactor se deben leer ademas:

```text
CodexCommonAgents/rules/15-graphify-code-intelligence.md
CodexCommonAgents/agents/02-code-graph-agent.md
CodexCommonAgents/playbooks/graphify-project-analysis.md
CodexCommonAgents/registry/code-intelligence-tools.md
```

Graphify (`Graphify-Labs/graphify`) es el estandar comun de code intelligence. Debe usarse como primera pasada para mapear el repositorio y consultar relaciones antes de lecturas masivas de archivos. El source code sigue siendo la evidencia final.

La politica comun exige imagenes propias versionadas de forma inmutable, preferencia por digest para igualdad exacta entre equipos, separacion entre Compose de build y Compose de runtime desde registro, validacion de recuperabilidad remota antes de limpiar imagenes, preservacion de volumenes persistentes y exposicion local por defecto de servicios de infraestructura.

## Estructura

```text
agents/       Roles reutilizables para Codex.
rules/        Reglas globales de arquitectura, seguridad, calidad, codigo y runtime.
registry/     Inventario de capacidades reutilizables y lista de no duplicacion.
playbooks/    Guias de ejecucion por tipo de proyecto.
templates/    Plantillas para nuevos repositorios.
```

## Code intelligence con Graphify

Baseline Windows/Codex:

```powershell
winget install --id astral-sh.uv -e
uv tool install "graphifyy[mcp,office,pdf,svg,leiden]"
graphify install --platform codex
graphify install --platform agents
```

Codex debe tener `multi_agent = true` bajo `[features]` para extraccion paralela. Por defecto los proyectos deben ignorar `graphify-out/` salvo que se decida versionar esos artefactos de forma explicita.

## Regla de bajo consumo de tokens

Codex no debe leer todo un repositorio si la tarea puede resolverse con el contexto minimo. Debe leer primero contratos, inventarios, playbooks y archivos coordinadores.

## Repositorios relacionados

- Portal transversal: `christyepez/PortalCorporativo`
- Dominio financiero: `christyepez/Financiero`
- Dominio CRM: `christyepez/CRM`
- Condominios: `christyepez/AppCondominio`
- Coloreado: `christyepez/AppColoreando`
