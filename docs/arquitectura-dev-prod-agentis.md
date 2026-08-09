# Arquitectura DEV → aprobación → PROD

## Premisa
Mati actúa como Product Owner / reviewer. MatiOS y sus agentes pueden construir, versionar, desplegar y probar en DEV. Ningún cambio relevante llega a PROD sin un approval gate definido.

## Flujo universal
idea/cambio -> branch/version -> DEV -> tests -> review de Mati -> aprobación -> PROD -> observabilidad -> aprendizaje

El canal de review puede ser Telegram: resumen del cambio, estado de tests, enlaces a diff/PR y preview DEV, y acciones de aprobar/rechazar. Los cambios sensibles requieren controles adicionales.

## Por tipo de artefacto
### Git / conocimiento / código
branch -> PR -> tests -> review -> merge main -> deploy PROD

### Web / API
branch -> deploy preview/DEV -> URL accesible -> Mati prueba -> approval -> deploy PROD

### n8n
workflow parametrizado -> export JSON -> Git -> instancia/entorno DEV -> pruebas -> approval -> promoción/import controlado a PROD

Los JSON de n8n se versionan en Git para disponer de historial, diff, rollback y despliegue reproducible.

### Base de datos
migración versionada -> DB DEV -> tests/compatibilidad -> backup/plan rollback -> approval -> DB PROD.

Nunca ejecutar migraciones destructivas en PROD directamente desde una conversación.

## Infraestructura
Railway puede actuar inicialmente como proveedor de cómputo/servicios administrados. La arquitectura de Agentis debe evitar acoplar la lógica de producto al proveedor para poder migrar o desplegar en otra infraestructura.

DEV y PROD deben tener, como mínimo, secretos/credenciales y bases separados. Para clientes, el grado de aislamiento debe decidirse según seguridad, volumen, costo y requisitos; no asumir automáticamente una infraestructura completa por cliente.

# Productización Agentis

## Principio
No construir automatizaciones únicas desde cero para cada negocio. Construir productos/patrones reutilizables, parametrizados y versionados.

Un vertical (ej. escuela de baile) se compone de capacidades genéricas + configuración del cliente.

## Capacidades reutilizables iniciales
- responder consultas entrantes
- capturar y calificar leads
- recuperar contexto/conocimiento del negocio
- turnos/reservas/clases
- alta/gestión de socios o clientes
- seguimiento de leads que consultaron y no compraron/se asociaron
- recordatorios
- reactivación de clientes inactivos
- escalamiento a humano
- métricas y auditoría

Muchas capacidades son agnósticas al vertical. Por ejemplo `lead-follow-up` puede reutilizarse en escuela de baile, cancha, gimnasio, estética u otros negocios cambiando parámetros y reglas.

## Template + configuración
Separar:
1. **Template versionado:** lógica común del workflow/producto.
2. **Configuración:** horarios, mensajes, canales, reglas, catálogo, precios, delays, credenciales/referencias de secretos, límites y branding.
3. **Conocimiento del cliente:** FAQs, servicios, políticas y documentos recuperables por RAG cuando corresponda.
4. **Estado vivo:** leads, conversaciones, reservas, socios, eventos y métricas en DB/CRM.

## Estructura conceptual futura
```text
products/
  lead-follow-up/
    README.md
    workflow.json
    schema.json
    tests/
  inbound-assistant/
  booking/
  reminders/

verticals/
  dance-school/
    manifest.yaml
  football-field/
    manifest.yaml

clients/
  <client>/
    config.example.yaml   # nunca secretos reales
```

## Deploy de un cliente
seleccionar producto/vertical -> completar configuración -> generar entorno DEV -> importar workflows/versiones -> cargar conocimiento -> tests automáticos -> prueba de Mati/cliente -> approval -> PROD

## Seguridad
- secretos fuera de Git
- mínimo privilegio por integración
- separación DEV/PROD
- backups y rollback
- auditoría de deployments
- datos de clientes aislados según modelo de tenancy
- actualizaciones de templates probadas primero en DEV

## Rol de MatiOS en Agentis
MatiOS sirve como laboratorio y primer cliente interno. Los patrones que funcionen se destilan en templates/skills reutilizables de Agentis. El objetivo es que crear el cliente N+1 sea considerablemente más rápido y seguro que crear el primero.

## Principio de escala
Agentis no escala creando más workflows manualmente; escala convirtiendo soluciones repetidas en productos parametrizados con un pipeline de despliegue reproducible.