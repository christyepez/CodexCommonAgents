# Playbook - Codex Low Token Mode

## Objetivo

Reducir reprocesamiento de contexto y consumo de tokens en Codex.

## Lectura minima

Para una tarea normal, Codex debe leer solo:

```text
AGENTS.md del proyecto actual
codex/PROJECT_CONTEXT.md del proyecto actual, si existe
CodexCommonAgents/AGENTS.md
CodexCommonAgents/registry/reusable-portal-apis.md
CodexCommonAgents/playbooks/portal-first-implementation.md
Documento coordinador del dominio, si existe
```

## Reglas

- No leer todo el repositorio al iniciar.
- No volver a explicar reglas globales si ya estan en `CodexCommonAgents`.
- No escanear carpetas generadas, binarios, build output, node_modules, obj, bin o dist.
- Antes de abrir archivos adicionales, justificar por que son necesarios.
- Preferir contratos, inventarios y playbooks sobre lectura completa de codigo.
- Mantener respuestas de estado compactas.

## Salida compacta

```text
Decision:
Classification:
Files touched:
Portal reuse:
Tests:
Risks:
Next:
```
