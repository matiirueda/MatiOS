# Mati Engineering Standard — Development & Deployment

## Alcance
Esta es una premisa global del ecosistema MatiOS/Agentis. Todo proyecto nuevo la hereda por defecto, salvo que exista una razón explícita y documentada para desviarse.

## Regla principal
**CHANGE → DEV → TEST → HUMAN APPROVAL → PROD → OBSERVE → LEARN**

MatiOS/agentes pueden construir, versionar y desplegar en DEV. Mati actúa como approval gate antes de promover cambios relevantes a PROD.

## Git y código
- Nunca usar `main` como espacio de trabajo normal.
- Crear branch específica por cambio.
- Abrir PR contra `main`.
- Ejecutar tests/checks disponibles.
- Presentar resumen + diff + riesgos + preview cuando exista.
- Promover a PROD después de aprobación.

## Interfaces de review
El review debe poder hacerse cómodamente desde móvil. Objetivo futuro: Telegram muestra PR, resumen, tests y links a diff/preview DEV y permite aprobar o pedir cambios.

## Web / API
branch -> preview/DEV -> tests -> Mati prueba URL DEV -> approval -> PROD.

## n8n
- Workflows exportados como JSON y versionados en Git.
- Templates parametrizados en vez de duplicación manual.
- Ejecutar/probar primero en n8n DEV.
- Promoción controlada a PROD tras approval.
- Mantener rollback/version anterior.

## Base de datos
- Migraciones versionadas.
- Ejecutar primero en DB DEV.
- Validar compatibilidad y tests.
- Para cambios riesgosos: backup + rollback plan.
- Approval antes de PROD.
- Nunca ejecutar una migración destructiva directamente en PROD desde una conversación.

## Infraestructura
- DEV y PROD separados al menos en secretos, credenciales y datos.
- Infraestructura reproducible y portable.
- Railway puede ser proveedor inicial de recursos, pero la lógica del producto no debe quedar acoplada a Railway.
- El aislamiento por cliente se decide por seguridad, volumen, costo y requisitos; no se crea infraestructura dedicada sin necesidad.

## Seguridad
- Secretos nunca en Git.
- Mínimo privilegio.
- Auditoría de deployments.
- Backups y rollback según criticidad.
- Datos de clientes aislados según modelo de tenancy.

## Aplicación a Agentis
Agentis reutiliza este estándar para cada producto y cliente. Las soluciones repetidas deben convertirse en templates versionados y parametrizados.

Ejemplos de capacidades agnósticas al vertical:
- inbound assistant / responder consultas
- lead capture y qualification
- booking / turnos / clases
- lead follow-up para quien consultó y no compró
- reminders
- reactivación
- human handoff
- métricas/auditoría

Un vertical, como una escuela de baile, compone capacidades genéricas y agrega configuración + conocimiento específico del negocio.

## Separación de producto
1. **Template:** lógica común versionada.
2. **Config:** horarios, mensajes, delays, reglas, catálogo, branding y referencias a secretos.
3. **Knowledge:** FAQs, servicios, políticas y documentos/RAG del cliente.
4. **State:** leads, conversaciones, reservas, clientes, eventos y métricas en DB/CRM.

## Principio de escala
El cliente N+1 debe ser más rápido y seguro de desplegar que el primero. Agentis escala convirtiendo soluciones repetidas en productos parametrizados con deployments reproducibles, no acumulando workflows artesanales.