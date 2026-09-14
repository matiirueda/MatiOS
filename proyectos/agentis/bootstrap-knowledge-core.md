# Agentis — Bootstrap, Knowledge Core y Change Control

Fecha: 2026-09-14

## Visión

Agentis debe **modelar digitalmente una empresa una sola vez** y permitir que Booking, Sales, Support, Voice, Operations y futuros agentes consuman la misma fuente de verdad según sus permisos.

Objetivo operacional: reducir al mínimo el tiempo desde que un cliente entrega información hasta que puede probar su primer agente (`Time-to-First-Agent`) y evitar mantenimiento artesanal recurrente.

Arquitectura conceptual:

`Información desordenada del cliente → Client Bootstrap → Knowledge Core → Deployment Engine → agentes/templates`

## 1. Client Bootstrap Agent

El Bootstrap es la plataforma de onboarding y comprensión del cliente. Debe aceptar fuentes como:

- PDF / DOCX / Markdown;
- web;
- Excel/CSV;
- formularios;
- FAQs;
- listas de precios;
- audios/voz;
- mensajes y exports conversacionales.

Pipeline:

`ingest → extract → classify → normalize → route → detectar faltantes/contradicciones → propuesta → revisión humana → MCP → persistencia → validación → publish`

No inventar información faltante. El Bootstrap debe preguntar sólo lo necesario para completar el modelo del negocio.

## 2. Standard Agentis Schema

Las bases de clientes deben mantener una arquitectura común. Evitar diseñar una base distinta por vertical.

Core aproximado:

- clients
- locations
- contacts
- services
- resources
- business_hours
- policies
- faq
- knowledge_documents
- integrations
- channel_config
- crm_mappings
- events
- audit_log

Módulos reutilizables:

### Booking
- appointments
- availability_rules
- cancellations

### Commercial
- service_prices
- promotions
- promotion_rules / targets

### Operations
- products
- suppliers
- stock_movements
- purchase_orders

Las extensiones verticales se agregan sólo cuando exista una diferencia real de dominio. Una cancha, estética y odontología deberían reutilizar el mismo Booking Core y reinterpretar/configurar `service` y `resource`.

## 3. Router de conocimiento

Regla central: **no meter todo en RAG**.

### Structured truth — PostgreSQL
Usar para datos determinísticos, cambiantes, históricos o con impacto comercial/operativo:

- precios;
- promociones/descuentos;
- servicios y duraciones;
- horarios;
- disponibilidad/reglas de reserva;
- stock;
- IDs;
- permisos;
- condiciones comerciales;
- vigencias.

### Knowledge semiestructurado
FAQs, políticas y procedimientos pueden tener representación estructurada y una representación Markdown derivada.

### RAG / pgvector
Documentos, manuales, explicaciones extensas y conocimiento documental.

### Object storage
Conservar archivos fuente originales: PDF, DOCX, imágenes, etc.

### Audit/Event store
Mantener eventos, cambios, aprobaciones e historial.

Principio: **Structured truth first. Generated knowledge second.** Una representación Markdown/RAG puede derivarse de datos estructurados, pero no debe convertirse accidentalmente en la fuente canónica de precios, promociones u otros datos críticos.

## 4. Agentis Client MCP

El Bootstrap y los agentes no deberían depender de escribir SQL específico por cliente. Crear un MCP con contratos estables para provisionar y mantener clientes.

Tools candidatas:

- create_client
- upsert_services
- upsert_business_hours
- upsert_booking_rules
- upsert_prices
- upsert_promotions
- add_faq
- ingest_document
- index_knowledge
- set_channel_config
- set_crm_mapping
- validate_client_config
- publish_client_version

El MCP encapsula Postgres/pgvector/storage/versionado y permite que n8n, Codex, Claude u otros componentes trabajen contra una interfaz común.

## 5. Bootstrap Learn — aprendizaje desde conversaciones

El Bootstrap no termina después del onboarding. Debe existir un modo continuo que analice conversaciones de prueba y producción para detectar:

- respuestas incorrectas;
- preguntas sin respuesta;
- datos desactualizados;
- contradicciones;
- FAQs recurrentes;
- reglas implícitas;
- gaps de configuración/knowledge.

Loop:

`conversation → evaluation → issue → proposed knowledge/config change → HITL → publish version → regression tests`

Al principio mantener revisión humana fuerte. La intervención puede reducirse gradualmente según confianza y riesgo.

No corregir errores creando parches permanentes en prompts cuando la causa real sea un dato/configuración/conocimiento incorrecto.

## 6. Knowledge Update Channel

El dueño debe poder mantener su empresa sin depender de Mati para cada modificación.

Inicialmente priorizar **WhatsApp como interfaz administrativa**, evitando construir un portal prematuramente. Slack/Telegram/GHL y un futuro portal deben ser adapters alternativos.

Ejemplos:

- “Pasame mi lista de precios.”
- “Desde mañana la cancha de 7 pasa a $120.000.”
- “Subí 10% todos los tratamientos excepto Botox.”
- “Los sábados ahora cerramos a las 18.”
- “Te mando la lista nueva: decime qué cambió.”
- “Agregá esta FAQ.”

Flujo de cambio:

`Owner/Admin Channel → autenticación/autorización → interpretar intención → consultar estado actual → preview old→new → aprobación → opcional aprobación Agentis/Mati → MCP → nueva versión → actualizar derivados/RAG → tests → publish → audit log`

Separar claramente:

- Customer Channel: cliente final hablando con Booking/Support/Sales.
- Owner/Admin Channel: dueño o empleado autorizado administrando Knowledge/Config.

Mismo canal tecnológico puede utilizarse, pero identidad, permisos y tools deben estar aislados.

## 7. Human approval y autonomía progresiva

Primeros clientes:

`dueño → Agentis propone → Mati valida → publish`

Con evidencia suficiente:

`dueño → Agentis propone → dueño confirma → publish`

Cambios de bajo riesgo podrían eventualmente ejecutarse automáticamente para usuarios autorizados, manteniendo auditoría.

La autonomía debe ser granular por riesgo, no todo-o-nada.

Ejemplo conceptual:

```yaml
knowledge_updates:
  faq:
    approval: owner
  service_description:
    approval: owner
  service_price:
    approval: owner_confirm
  booking_hours:
    approval: owner
  permissions:
    approval: agentis_admin
```

Cada propuesta puede tener `confidence_score`, `risk_level`, fuente, old/new value y `requires_approval`.

## 8. Auditabilidad, provenance y lineage

Pilar arquitectónico: poder explicar por qué un agente respondió o actuó de determinada manera.

Para cada cambio guardar al menos:

- requested_by;
- approved_by;
- source_channel;
- source_message/document;
- old_value;
- new_value;
- effective_from / effective_to cuando aplique;
- reason;
- affected_entities;
- affected_agents;
- version;
- timestamp.

Cada dato/conocimiento debería conocer su origen, fecha de extracción, aprobación, versión reemplazada y consumidores relevantes.

Objetivo de trazabilidad:

`respuesta/acción → dato/regla utilizada → versión → fuente original → cambio → solicitante → aprobación`

Los cambios deberían permitir identificar agentes afectados y disparar regression tests específicos antes de publicar.

## 9. Precios y promociones como entidades estructuradas

En Argentina, por frecuencia de cambios de precios, la actualización debe ser extremadamente simple.

### service_prices
Modelar como mínimo:

- client_id
- service_id
- amount
- currency
- valid_from
- valid_to
- status
- source
- requested_by
- approved_by
- version

Esto permite precio actual, futuro, histórico, sucursales, medios de pago y vigencias.

### promotions
Las promociones también son **datos estructurados**, nunca información perdida en prompts/RAG.

Modelar:

- promo_id
- client_id
- name
- discount_type/value
- applies_to / targets
- conditions
- channels
- valid_from
- valid_to
- status
- requested_by
- approved_by
- version

Así Booking, Sales, Support y otros agentes consultan la misma promoción activa y se puede reconstruir qué promoción estuvo vigente en cualquier fecha.

## 10. Promotions → Sales Analytics

Guardar promociones estructuradas habilita medir su efectividad contra ventas/conversiones.

Relacionar cuando sea posible:

`promotion → exposures/conversations → leads → bookings/orders → revenue → margin/cost`

Métricas futuras:

- conversion rate con/sin promo;
- ventas y revenue atribuible;
- ticket promedio;
- margen incremental cuando exista costo disponible;
- redención;
- performance por servicio/producto;
- performance por canal;
- performance por segmento;
- comparación histórica de promociones.

Esto convierte una funcionalidad administrativa (crear una promo) en una futura capa de inteligencia: Agentis puede mostrar qué promociones funcionaron y cuáles no, y eventualmente sugerir experimentos/promociones manteniendo HITL.

## 11. Booking & Info + Deployment Kit como primer caso

No construir “bot de canchas” como fork/producto aislado.

Construir simultáneamente:

`Bootstrap + Knowledge Core + Deployment Kit + Booking & Info Core`

La cancha es `Client Config #1`. Una estética/odontología puede ser `Client Config #2` para probar el porcentaje real de reuso.

Booking & Info Core:

`message → client/identity → intent → FAQ/knowledge → service → resource → availability → customer → booking → payment/deposit opcional → confirmation → reminders → reschedule/cancel → HITL → event/CRM logging`

Configurables:

- services/resources;
- prices;
- durations;
- business hours;
- booking/deposit rules;
- FAQs/policies;
- tone/messages;
- calendar/CRM/channel/payment adapters.

Criterio: si para desplegar un cliente normal hay que modificar nodos internos del workflow n8n, se está generando deuda. Lo normal debe ser Bootstrap + Client Config + adapters sobre cores estables.

## 12. Métricas de Factory

Medir desde el primer cliente:

- Time-to-First-Agent;
- tiempo total de onboarding;
- % de campos autocompletados por Bootstrap;
- % de reutilización del template;
- intervenciones manuales por deployment;
- errores/gaps encontrados en chats de prueba;
- tiempo hasta producción;
- cambios de conocimiento/config por cliente;
- % de cambios que requieren intervención Agentis.

Objetivo: demostrar que Agentis escala como Factory/plataforma y no como consultora artesanal.

## 13. Principios consolidados

1. Modelar la empresa una vez; todos los agentes consumen la misma fuente de verdad.
2. Datos críticos/cambiantes/temporales → estructura y versionado.
3. RAG explica; la base estructurada decide cuando existe una verdad determinística.
4. Adapters, no forks.
5. MCP como capa estable de escritura/lectura/provisioning.
6. WhatsApp primero como canal de cliente y administración cuando simplifique adopción.
7. HITL fuerte inicialmente; autonomía progresiva basada en riesgo/confianza.
8. Todo cambio relevante debe ser auditable y reversible.
9. Conversaciones reales alimentan el loop de mejora del conocimiento.
10. El dueño debe poder mantener precios, promociones, horarios y conocimiento sin depender operativamente de Mati.
11. Promos/precios históricos deben conectarse a ventas para medir impacto y generar inteligencia comercial.
12. Objetivo de reuso: 70–90%; idealmente ~90% en Booking & Info.
