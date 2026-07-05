# Codex Common Agents

Repositorio comun para centralizar agentes, reglas, playbooks, templates y contratos reutilizables por Codex en proyectos de arquitectura empresarial.

## Objetivo

Evitar que cada repositorio vuelva a definir la misma arquitectura, reglas de calidad, seguridad, DevOps, frontend, backend e integracion con `PortalCorporativo`.

Este repositorio debe ser usado por:

- `PortalCorporativo`
- `Financiero`
- `CRM`
- futuros dominios o modulos corporativos

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

## Estructura

```text
agents/       Roles reutilizables para Codex.
rules/        Reglas globales de arquitectura, seguridad, calidad y codigo.
registry/     Inventario de capacidades reutilizables y lista de no duplicacion.
playbooks/    Guias de ejecucion por tipo de proyecto.
templates/    Plantillas para nuevos repositorios.
```

## Regla de bajo consumo de tokens

Codex no debe leer todo un repositorio si la tarea puede resolverse con el contexto minimo. Debe leer primero contratos, inventarios, playbooks y archivos coordinadores.

## Repositorios relacionados

- Portal transversal: `christyepez/PortalCorporativo`
- Dominio financiero: `christyepez/Financiero`
- Dominio CRM: `christyepez/CRM`
