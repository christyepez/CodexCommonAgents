# Master Agent Orchestration Strategy

## Proposito

Definir la estrategia general para que Codex ejecute agentes de forma coordinada entre repositorios, evitando cruces de responsabilidad, reprocesamiento de contexto y consumo innecesario de tokens.

Este documento es el MD principal de orquestacion para:

```text
PortalCorporativo
Financiero
CRM
futuros repositorios de dominio
```

## Repositorios

| Repositorio | Rol | Responsabilidad |
|---|---|---|
| CodexCommonAgents | Orquestacion comun | Agentes, reglas, playbooks, templates, prompts y criterios comunes. |
| PortalCorporativo | Plataforma transversal | APIs reutilizables, seguridad, auditoria, notificaciones, menus, configuracion, catalogos, archivos, reporting, gateway y shell Angular. |
| Financiero | Dominio financiero/SRI | Contabilidad, facturacion, retenciones, documentos electronicos, XML SRI, RIDE, ATS, integracion SRI. |
| CRM | Dominio CRM | Clientes, contactos, leads, oportunidades, actividades, casos, campanias e Integration Hub CRM. |

## Regla principal

Antes de crear cualquier componente, Codex debe clasificarlo como:

```text
REUSE   = usar componente existente de PortalCorporativo.
EXTEND  = extender configuracion, menus, permisos, catalogos o metadata del portal.
ADAPT   = crear adaptador hacia una API o servicio del portal.
CREATE  = crear componente propio del dominio.
BLOCKED = detener hasta revisar dependencia, contrato o capacidad faltante.
```

Si no existe clasificacion, la tarea queda bloqueada.

## Objetivo de optimizacion de tokens

Codex debe operar en modo contexto minimo.

Lectura obligatoria inicial:

```text
1. AGENTS.md del repositorio actual.
2. README.md del repositorio actual.
3. codex/PROJECT_CONTEXT.md si existe.
4. CodexCommonAgents/AGENTS.md.
5. CodexCommonAgents/playbooks/master-agent-orchestration.md.
6. CodexCommonAgents/registry/reusable-portal-apis.md.
7. PortalCorporativo/codex/REUSABLE_CAPABILITIES.md si la tarea requiere evaluar reutilizacion.
8. Documento coordinador del dominio si existe.
```

Codex no debe leer todo el repositorio salvo que el Coordinador lo justifique.

## Orquestador principal

El agente coordinador gobierna toda tarea.

### Responsabilidades

```text
1. Identificar repositorio objetivo.
2. Identificar dominio o capacidad solicitada.
3. Revisar capacidad reutilizable del portal.
4. Clasificar REUSE/EXTEND/ADAPT/CREATE/BLOCKED.
5. Seleccionar agente responsable.
6. Definir archivos permitidos para lectura.
7. Definir archivos permitidos para modificacion.
8. Definir dependencias entre agentes.
9. Definir criterios de aceptacion.
10. Consolidar salida final.
```

## Fases generales de ejecucion

| Fase | Momento | Agente lider | Repositorio principal | Entregable |
|---|---|---|---|---|
| Fase 0 | Antes de crear codigo | Coordinator Agent | Repo actual + CodexCommonAgents | Decision de alcance y clasificacion. |
| Fase 1 | Discovery reutilizacion | Portal Reuse Agent | PortalCorporativo | Matriz REUSE/EXTEND/ADAPT/CREATE/BLOCKED. |
| Fase 2 | Diseno solucion | Solution Architect Agent | Repo actual | Bounded contexts, contratos, dependencias y ADR si aplica. |
| Fase 3 | Seguridad y permisos | Security Agent | PortalCorporativo + repo actual | Recursos, permisos, roles y validacion backend. |
| Fase 4 | Backend dominio | Backend Agent | Repo de dominio | Casos de uso, APIs, contratos, pruebas. |
| Fase 5 | Datos dominio | Data Agent | Repo de dominio | Modelo, scripts, migraciones y seeds. |
| Fase 6 | Integracion | Integration Agent | Repo de dominio + PortalCorporativo | Adaptadores, outbox/inbox, contratos externos. |
| Fase 7 | Frontend | Frontend Agent | Repo de dominio + Portal Angular Shell | Modulo UI integrado por metadata. |
| Fase 8 | DevOps | DevOps Agent | Repo actual | Docker, variables, ejecucion local, pipelines. |
| Fase 9 | QA | QA Agent | Repo actual | Pruebas unitarias, integracion, contratos y build. |
| Fase 10 | Documentacion | Documentation Agent | Repo actual | README, TASKS, dependencias, decisiones y pendientes. |

## Interaccion entre agentes

```text
Coordinator Agent
  -> Portal Reuse Agent
      -> Security Agent
      -> Integration Agent
      -> Frontend Agent
  -> Solution Architect Agent
      -> Backend Agent
      -> Data Agent
      -> Integration Agent
      -> DevOps Agent
      -> QA Agent
  -> Documentation Agent
```

Ningun agente de implementacion puede iniciar si el Coordinator Agent no definio:

```text
Task
Repository
Classification
Responsible Agent
Files allowed to read
Files allowed to modify
Acceptance Criteria
```

## Reglas por repositorio

### CodexCommonAgents

Debe contener:

```text
Agentes comunes
Reglas globales
Playbooks
Templates
Prompts
Registro de capacidades reutilizables
Lista de no duplicacion
Estrategia maestra de orquestacion
```

No debe contener codigo de negocio.

### PortalCorporativo

Debe contener capacidades transversales:

```text
Security API
Menu API
Configuration API
Catalog API
Audit API
Notification API
Content/File API
Reporting API
Integration API
API Gateway
SQL Outbox
Workers
Portal Angular Shell
Docker Compose base
```

No debe contener reglas especificas de Financiero o CRM salvo configuraciones extensibles.

### Financiero

Debe crear solo dominio financiero/SRI:

```text
Plan de cuentas
Periodos fiscales
Asientos contables
Facturacion electronica
Notas de credito
Notas de debito
Retenciones
Liquidaciones de compra
Guias de remision
XML SRI
Firma electronica
Autorizacion SRI
RIDE
ATS
Reportes fiscales
```

Debe reutilizar seguridad, auditoria, notificaciones, menus, configuracion, catalogos generales, contenido, reporting y gateway del portal.

### CRM

Debe crear solo dominio CRM:

```text
Customers
Contacts
Leads
Opportunities
Activities
Cases
Campaigns
Interactions
CRM Documents metadata
CRM Integration Hub
Salesforce connector
Dynamics connector
Generic REST connector
Entity mappings
Field mappings
Integration transactions
```

CRM Core no debe acoplarse directamente a Salesforce, Dynamics u otro CRM externo. Toda integracion externa pasa por CRM Integration Hub.

## Matriz de responsabilidad RACI

| Capacidad | CodexCommonAgents | PortalCorporativo | Financiero | CRM |
|---|---|---|---|---|
| Reglas de agentes | A/R | C | C | C |
| Seguridad global | C | A/R | C/E | C/E |
| Menus y shell | C | A/R | E | E |
| Configuracion visual | C | A/R | E | E |
| Auditoria | C | A/R | A/D | A/D |
| Notificaciones | C | A/R | A/D | A/D |
| Catalogos globales | C | A/R | E | E |
| Dominio financiero | C | C | A/R | I |
| Dominio CRM | C | C | I | A/R |
| Integraciones externas comunes | C | A/R | A/D | A/D |
| SRI | C | C | A/R | I |
| Salesforce/Dynamics | C | C | I | A/R |

Leyenda:

```text
A = Accountable
R = Responsible
C = Consulted
I = Informed
E = Extends
D = Adapter
```

## Politica de lectura de archivos

### Lectura permitida por defecto

```text
AGENTS.md
README.md
codex/PROJECT_CONTEXT.md
codex/INSTRUCTIONS.md
codex/ARCHITECTURE_RULES.md
codex/TASKS.md
docs/*coordinator*.md
docs/*reuse*.md
CodexCommonAgents/registry/*.md
CodexCommonAgents/playbooks/*.md
PortalCorporativo/codex/REUSABLE_CAPABILITIES.md
```

### Lectura restringida

Solo leer codigo fuente cuando:

```text
1. La tarea requiere modificar implementacion.
2. El Coordinador ya definio archivos candidatos.
3. Existe una brecha de contrato o dependencia.
4. Se necesita validar build, interfaz o contrato real.
```

### Evitar leer

```text
node_modules
bin
obj
dist
coverage
logs
archivos generados
binarios
imagenes sin necesidad
```

## Politica de escritura

Codex debe modificar solo archivos dentro del alcance definido.

Si detecta que debe tocar otro repositorio:

```text
1. No modificar directamente sin registrar decision.
2. Reportar dependencia cruzada.
3. Clasificar impacto.
4. Crear tarea separada o PR separado por repositorio.
```

## Reglas de bloqueo

La tarea debe quedar BLOCKED si:

```text
No existe clasificacion de reutilizacion.
Se intenta duplicar capacidad transversal del portal.
Se requiere cambiar PortalCorporativo sin contrato.
Se intenta guardar secretos en codigo.
Se intenta acoplar dominios por base de datos.
Se intenta quemar configuracion visual en frontend.
Se intenta implementar seguridad solo en frontend.
Se intenta llamar integraciones externas directamente desde controladores.
```

## Salida estandar obligatoria

Toda ejecucion debe cerrar con:

```text
Agent:
Repository:
Task:
Phase:
Files Read:
Files Created:
Files Modified:
Portal Capability Checked:
Reuse Classification:
Portal Components Reused:
Portal Components Extended:
Adapters Created:
New Domain Components Created:
Security Impact:
Audit Impact:
Notification Impact:
Menu Impact:
Configuration Impact:
Integration Impact:
Tests Added:
Commands Executed:
Risks:
Blocked Items:
Next Step:
```

## Prompt maestro recomendado

```text
Actua como Coordinator Agent usando CodexCommonAgents.

Modo: bajo consumo de tokens.

Lee solo:
1. AGENTS.md del repositorio actual.
2. README.md del repositorio actual.
3. codex/PROJECT_CONTEXT.md si existe.
4. CodexCommonAgents/AGENTS.md.
5. CodexCommonAgents/playbooks/master-agent-orchestration.md.
6. CodexCommonAgents/registry/reusable-portal-apis.md.
7. PortalCorporativo/codex/REUSABLE_CAPABILITIES.md si aplica.
8. Documento coordinador del dominio si existe.

No leas todo el repositorio.
No implementes codigo hasta clasificar cada componente como REUSE, EXTEND, ADAPT, CREATE o BLOCKED.

Primero entrega:
- repositorio objetivo,
- fase,
- agente responsable,
- archivos a leer,
- archivos a modificar,
- dependencias,
- criterios de aceptacion.

Luego ejecuta solo el alcance aprobado por la clasificacion.

PortalCorporativo es la plataforma transversal.
CodexCommonAgents es la fuente comun de reglas, agentes y playbooks.
El repositorio actual solo debe implementar componentes propios de su dominio.

Cierra con la salida estandar obligatoria.
```
