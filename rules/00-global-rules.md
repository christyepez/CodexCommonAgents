# 00 - Global Rules

## Objetivo

Reglas obligatorias para todos los proyectos administrados por Codex.

## Reglas

1. Leer el contexto minimo antes de modificar codigo.
2. No leer todo el repositorio si la tarea no lo requiere.
3. No redisenar arquitectura sin justificar impacto, alternativas y migracion.
4. Usar Clean Architecture, DDD cuando aplique y SOLID.
5. Mantener bounded contexts independientes.
6. Comunicar dominios por APIs, eventos o adaptadores; no por acceso directo a bases de datos de otro dominio.
7. No quemar configuracion visual o funcional en codigo.
8. Validar autorizacion siempre en backend.
9. Versionar contratos JSON y eventos.
10. Agregar correlationId en flujos distribuidos.
11. Auditar acciones criticas.
12. Manejar secretos mediante variables seguras, Key Vault, Secret Manager o mecanismo equivalente.
13. Mantener cambios pequenos, revisables y probables.
14. Documentar decisiones de arquitectura en ADR cuando cambien una regla relevante.
15. Ejecutar build y pruebas cuando aplique.
16. Desplegar localmente con Docker Compose por defecto; nube o runtime remoto solo por solicitud explicita del usuario. Aplicar `rules/15-local-docker-compose-deployment.md`; CI y publicacion de imagenes no equivalen a despliegue.

## Criterio de salida

Toda tarea debe cerrar con resumen, archivos cambiados, pruebas, riesgos y siguiente paso.
