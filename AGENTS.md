# AGENTS.md - Codex Common Agents

## Proposito

Este archivo define las reglas comunes que Codex debe aplicar en todos los repositorios que usen este estandar.

## Preparacion del entorno

El entorno Codex debe tener instaladas las skills compartidas de Anthropic. En una nueva maquina o perfil de usuario, ejecutar:

```powershell
.\scripts\setup-codex.ps1
```

Este bootstrap instala globalmente `anthropics/skills` para el agente `codex`. Codex no debe volver a ejecutar la instalacion en cada tarea; solo debe recomendarla cuando las skills no esten disponibles o cuando se prepare una nueva maquina.

## Lectura obligatoria

Codex debe leer primero:

```text
README.md
rules/00-global-rules.md
registry/reusable-portal-apis.md
registry/do-not-duplicate.md
playbooks/portal-first-implementation.md
```

Despues debe leer el playbook del dominio correspondiente.

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

## Modo bajo consumo de tokens

Codex debe leer solo los archivos necesarios para la tarea. Si necesita mas contexto, debe justificar que archivo adicional va a leer y por que.
