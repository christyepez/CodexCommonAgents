# Playbook - Portal First Implementation

## Objetivo

Guiar a Codex para implementar nuevos modulos o dominios reutilizando primero `PortalCorporativo`.

## Flujo obligatorio

1. Leer `AGENTS.md` del proyecto actual.
2. Leer `CodexCommonAgents/AGENTS.md`.
3. Leer `registry/reusable-portal-apis.md`.
4. Leer `registry/do-not-duplicate.md`.
5. Identificar capacidad solicitada.
6. Clasificar como `REUSE`, `EXTEND`, `ADAPT`, `CREATE` o `BLOCKED`.
7. Implementar solo el alcance necesario.
8. Registrar impacto en seguridad, auditoria, notificaciones, menus y configuracion.

## Decision tree

```text
La capacidad existe en PortalCorporativo?
  Si -> REUSE o EXTEND.
  No -> Es transversal?
        Si -> BLOCKED y proponer incorporarla al portal.
        No -> Es dominio propio?
              Si -> CREATE.
              No -> BLOCKED.

Requiere comunicacion con portal?
  Si -> ADAPT.

Requiere configuracion visual o funcional?
  Si -> EXTEND via Configuration/Menu/Catalog API.
```

## Criterios de aceptacion

- No se duplican capacidades transversales.
- Todo recurso visible tiene permisos asociados.
- Toda accion critica genera evento de auditoria.
- Toda notificacion se canaliza por Notification API.
- Los menus, acciones, grids y formularios se configuran por metadata.
- La integracion externa usa adaptadores, contratos y reintentos.
