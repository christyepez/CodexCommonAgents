# Reusable Portal APIs Registry

## Fuente transversal

Repositorio base:

```text
https://github.com/christyepez/PortalCorporativo
```

## Capacidades reutilizables obligatorias

| Capacidad | Decision base | Uso esperado |
|---|---|---|
| Security API | REUSE/EXTEND | Login, usuarios, roles, permisos, claims, recursos protegidos. |
| Menu API | EXTEND | Registro de menus, submenus, acciones y navegacion por modulo. |
| Configuration API | EXTEND | Parametros visuales y funcionales. |
| Catalog API | EXTEND | Catalogos globales, versionados o compartidos. |
| Audit API | ADAPT | Registro de eventos, trazabilidad, acciones criticas y cambios. |
| Notification API | ADAPT | Correos, avisos, alertas, eventos y notificaciones de negocio. |
| Content/File API | ADAPT | Archivos, metadata, documentos, imagenes, XML, PDFs, adjuntos. |
| Reporting API | EXTEND/ADAPT | Reportes transversales, dashboards, parametros y exportaciones. |
| Integration API | EXTEND/ADAPT | Integraciones comunes, conectores, APIs externas y contratos. |
| API Gateway | REUSE | Publicacion y ruteo de APIs internas. |
| SQL Outbox | EXTEND | Eventos confiables, reintentos y procesamiento asincrono inicial. |
| Workers | EXTEND | Procesos asincronos y publicacion de eventos. |
| Portal Angular Shell | REUSE/EXTEND | Shell visual, layout, menu, rutas y configuracion dinamica. |

## Regla

Si una capacidad existe aqui, el proyecto de dominio no debe crearla desde cero. Debe usar `REUSE`, `EXTEND` o `ADAPT`.

## Excepciones

Solo se permite `CREATE` cuando:

1. La capacidad pertenece claramente al dominio.
2. No existe equivalente en el portal.
3. Existe una justificacion registrada.
4. El componente nuevo no rompe independencia entre bounded contexts.
