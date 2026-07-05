# PORTAL_INTEGRATION_CONTRACTS.md - PROJECT_NAME

## Objetivo

Definir como el proyecto se integra con PortalCorporativo sin duplicar capacidades transversales.

## Contratos

| Capacidad portal | Clasificacion | Uso en el proyecto | Pendiente |
|---|---|---|---|
| Security API | EXTEND | Roles, permisos y recursos del dominio | Definir matriz |
| Menu API | EXTEND | Menus y acciones del modulo | Definir metadata |
| Configuration API | EXTEND | Parametros visuales y funcionales | Definir claves |
| Catalog API | EXTEND | Catalogos compartidos | Identificar catalogos |
| Audit API | ADAPT | Eventos criticos del dominio | Definir eventos |
| Notification API | ADAPT | Notificaciones del dominio | Definir plantillas |
| Content/File API | ADAPT | Adjuntos y documentos | Definir storage |
| Reporting API | EXTEND/ADAPT | Reportes y dashboards | Definir indicadores |
| Integration API | EXTEND/ADAPT | Integraciones externas | Definir conectores |
| API Gateway | REUSE | Publicacion de APIs | Registrar rutas |

## Reglas

- No crear seguridad aislada.
- No crear auditoria aislada.
- No crear notificaciones aisladas.
- No crear menus quemados en frontend.
- No crear catalogos compartidos dentro del dominio.
- Toda accion critica debe tener auditoria.
- Toda integracion externa debe tener contrato, adaptador y manejo de reintentos.
