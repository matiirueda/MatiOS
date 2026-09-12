# Agentis — Operations Core, GHL/Chatwoot y arquitectura de agentes compartida

Fecha: 2026-09-12

## 1. GHL vs Chatwoot

No tratar GHL y Chatwoot como sustitutos absolutos.

- **GoHighLevel (GHL)**: SaaS pago, orientado a CRM, pipelines, conversaciones, calendarios, follow-up y automatizaciones comerciales. Prioridad actual por frecuencia observada en demanda freelance y velocidad de salida al mercado.
- **Chatwoot**: inbox/soporte omnicanal, open source y self-hostable, con opción cloud paga. Útil cuando el cliente necesita más control de infraestructura/datos, soporte omnicanal o un human handoff más propio.
- Decisión Agentis: mantener una arquitectura por **adapters**, no casarse con un único CRM/inbox.

Regla práctica:

`GHL para salir rápido y vender CRM/ventas/booking`

`Chatwoot para omnicanalidad/soporte/control de infraestructura cuando el caso lo justifique`

No migrar a Chatwoot por moda ni por costo solamente.

## 2. Canal comercial: agencias con overflow / white-label

Señal relevante: agencias que ya venden automatización y buscan freelancers/implementadores repetidamente.

Interpretación:

- El problema ya está vendido al cliente final.
- La agencia posee distribución/comercialización y le falta capacidad de delivery.
- Este canal puede ser más eficiente que adquirir cada pyme desde cero.

Crear categoría propia en el radar de demanda:

`Agencia subcontratante / overflow / white-label`

Registrar para cada caso:

- verticales atendidos;
- flujo repetido;
- stack requerido;
- presupuesto por implementación;
- volumen potencial de clientes;
- nivel de estandarización;
- posibilidad de usar templates Agentis;
- margen estimable si se reutiliza 70–90%.

Modelo comercial posible:

1. Venta directa Agentis a pymes.
2. Delivery técnico white-label para agencias.
3. Más adelante, licenciamiento/implementation partner sobre templates probados.

## 3. Operations Core — atacar carga manual repetitiva

Nueva hipótesis de producto:

> Buscar procesos donde alguien hoy carga manualmente información de forma repetitiva. Primero eliminar la carga; luego vender inteligencia y acciones encima de los datos estructurados.

La familia inicial debe cubrir documentos, voz y mensajes como entrada.

### Flujo base

`Factura / remito / foto / WhatsApp / voz`
→ extracción estructurada
→ validación
→ normalización de producto/proveedor
→ movimiento de stock / costo / compra
→ histórico
→ reglas / analítica
→ sugerencia de acción
→ aprobación humana
→ ejecución por API/WhatsApp/ERP/CRM

### Facturas y proveedores

Caso inicial:

`factura/remito → proveedor + artículo + cantidad + precio → histórico de precios`

Valor inmediato:

- detectar cuánto subió cada artículo;
- comparar proveedores;
- detectar cambios anómalos;
- construir una base de costos sin carga manual.

Evolución:

`histórico de compras + stock + consumo → stock estimado → alerta de faltante → sugerencia de reposición`

Luego:

`pedido sugerido → dueño/encargado aprueba → Agentis prepara/envía WhatsApp o API al proveedor → respuesta actualiza estado`

El envío final debe mantenerse inicialmente con **human-in-the-loop**.

## 4. Voice-to-Operations

Se incorpora como template prioritario a vigilar.

Objetivo: permitir que empleados/dueños registren tareas operativas hablando en lugar de cargar formularios.

Ejemplo:

“Entraron 24 Coca de 2,25, 12 Sprite y quedan seis aguas.”

Flujo:

`audio WhatsApp`
→ speech-to-text
→ extracción estructurada
→ validación/confianza
→ catálogo/product matching
→ movimiento de stock
→ logs/auditoría
→ alertas/reglas posteriores

Aplicaciones reutilizables:

- inventario;
- recepción de mercadería;
- órdenes de trabajo;
- visitas comerciales;
- gastos;
- inspecciones;
- partes diarios;
- logística;
- mantenimiento;
- pedidos internos;
- actualizaciones de CRM.

Principio: **usar interfaces que el trabajador ya usa**, especialmente WhatsApp/voz, y estructurar el negocio por detrás.

## 5. Inventory + Purchasing Intelligence

Sobre el Operations Core agregar módulos independientes y reutilizables:

### Inventory Module
- movimientos;
- stock actual/estimado;
- mínimos;
- consumo;
- anomalías;
- proyección de agotamiento.

### Purchasing Module
- proveedores;
- históricos de precio;
- condiciones;
- lead time;
- comparación;
- pedido sugerido;
- aprobación humana;
- comunicación al proveedor;
- seguimiento del pedido.

Ejemplo de salida:

`Coca se termina el martes → sugerir 36 unidades a proveedor X → último precio +8,2% → Mati/dueño aprueba → enviar pedido por WhatsApp`

## 6. Arquitectura de “empleados digitales” sobre conocimiento compartido

No crear una colección de agentes aislados.

Modelo deseado:

`Empresa`
→ `Knowledge Graph / Business Context compartido`
→ `Agentes especializados por profesión`
→ `Tools / APIs / acciones`

Roles posibles:

- Sales Agent;
- Support Agent;
- Stock Agent;
- Purchasing Agent;
- Finance/Invoices Agent;
- Booking Agent;
- Content/Ads Agent.

Cada agente debe tener:

- responsabilidad concreta;
- permisos concretos;
- contexto permitido;
- herramientas permitidas;
- contratos/eventos claros con otros agentes.

No duplicar conocimiento. Los agentes deben reutilizar nodos compartidos y consultar una misma representación de clientes, proveedores, productos, procesos, reglas y documentos según permisos.

Graphify/knowledge graph encaja como parte de esta visión, complementado con RAG y estructuras operativas en Postgres/Supabase cuando corresponda.

### Ejemplo inter-agente

`stock_bajo`
→ Stock Agent
→ Purchasing Agent consulta proveedor/precios
→ genera propuesta
→ Human Approval Gate
→ Communications/WhatsApp Adapter
→ proveedor
→ respuesta
→ estado de compra / inventario actualizado

## 7. Regla de producto: agentes sólo cuando agregan separación real

No crear “20 agentes” por estética.

Crear un agente separado sólo si cambia de manera material alguno de estos elementos:

- responsabilidad;
- permisos;
- contexto;
- herramientas;
- objetivo;
- frecuencia de ejecución;
- necesidad de auditoría/aislamiento.

Si sólo cambia un prompt o una configuración de vertical, debe seguir siendo el mismo core con `Client Config`.

## 8. Roadmap actualizado

Orden de prioridad acordado:

1. **Lead-to-Booking Core**
2. **WhatsApp + CRM adapters**
3. **Human Handoff / HITL / Chatwoot cuando aplique**
4. **Lead Reactivation**
5. **Voice-to-Booking**
6. **Voice-to-Operations**
7. **Document/Invoice Intake**
8. **Inventory Intelligence**
9. **Purchasing / Supplier Ordering**
10. **Vertical configs/demos sobre el mismo core**

Regla dinámica:

Si el radar de demanda empieza a mostrar repetidamente inventario, compras, facturas, procurement o carga operativa manual, adelantar Operations Core en el roadmap.

## 9. Demos verticales recomendadas

Mantener dos demos iniciales sobre un mismo core comercial:

### Clínica / estética
`WhatsApp → FAQs → qualification → agenda → reminders → CRM → handoff`

### Canchas / servicios con reservas
`consulta → disponibilidad → reserva → seña/pago cuando aplique → recordatorio → seguimiento`

Y preparar una tercera demo operacional reutilizando Operations Core:

### Comercio / distribuidor / local con stock
`voz/factura → stock/costo → alertas → pedido sugerido → aprobación → proveedor`

## 10. Principios a preservar

- 70–90% de reuso objetivo.
- `Core + Client Config + adapters`, no forks por cliente.
- API/webhook primero; browser automation sólo si no hay mejor alternativa.
- Human-in-the-loop antes de acciones económicas/comerciales sensibles hasta tener suficiente confianza.
- Vender resultado de negocio, no nombres de herramientas.
- La demanda real decide qué template construir primero.
- Priorizar procesos manuales repetitivos que ya “duelen”; la IA/automatización entra después como mecanismo, no como pitch principal.
