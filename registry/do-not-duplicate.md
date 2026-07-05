# Do Not Duplicate Registry

## Regla

Los proyectos de dominio no deben reconstruir capacidades transversales que pertenecen a `PortalCorporativo`.

## No duplicar

```text
Login
Usuarios
Roles
Permisos globales
Identity Provider integration
Authorization policies
Menu engine
Dashboard shell
Portal Angular shell
Configuracion visual
Configuracion funcional generica
Temas
Logos
Layouts
Grids configurables
Buscadores paginados genericos
Botones/acciones configurables
Catalogos generales
Auditoria transversal
Centro de notificaciones
Envio generico de correos
Gestion generica de archivos
Reporting transversal
API Gateway
Outbox generico
Workers genericos
Manejo comun de secretos
Health checks comunes
Logging estructurado comun
```

## Como proceder

- Si ya existe en portal: `REUSE`.
- Si requiere datos del dominio: `EXTEND`.
- Si requiere comunicacion tecnica: `ADAPT`.
- Si no existe y es dominio propio: `CREATE`.
- Si hay duda: `BLOCKED`.
