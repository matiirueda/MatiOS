# Agentis — China Radar & Business Operator

## Objetivo

Usar China como radar adelantado de patrones de automatización, agentes, comercio conversacional y operación empresarial que puedan trasladarse a Argentina/LATAM. El objetivo no es vender inicialmente en China ni copiar herramientas por moda, sino detectar ideas transferibles antes de que sean demanda explícita local.

## Hipótesis estratégica

La dirección de largo plazo de Agentis no es vender un chatbot aislado. Es construir una capa operativa modular para pymes donde agentes especializados puedan leer el contexto del negocio, analizarlo, recomendar acciones y ejecutar tareas mediante herramientas reales, con human-in-the-loop donde corresponda.

Patrón objetivo:

`Canales + CRM + datos propios + knowledge → Orchestrator → agentes especializados → tools/adapters → acciones → métricas/aprendizaje`

El CRM no debe entenderse sólo como inbox o lugar donde un humano retoma una conversación. Debe funcionar como una fuente de memoria operativa del negocio. Se complementa con una base Agentis propia para eventos, métricas, features, historial y datos que no convenga o no sea posible guardar en el CRM.

## Señales observadas en China — 2026-09

### De chatbot a Business Operator

La señal relevante es el paso desde IA que sólo conversa hacia IA que participa en workflows empresariales y ejecuta acciones. Se observan plataformas y ecosistemas orientados a coordinar múltiples agentes, templates de trabajadores/agentes digitales e integración con herramientas de trabajo existentes.

Traducción para Agentis:

`mensaje/evento → entender intención/contexto → elegir agente → consultar datos → proponer/ejecutar acción → actualizar sistemas → medir resultado`

### Verticalización

Se observan asistentes y agentes orientados a industrias/comercios concretos, incluyendo operación y análisis de negocios locales. Esto refuerza la estrategia de Agentis de mantener un core común y crear demos/productos verticales principalmente mediante configuración.

Patrón:

`Agentis Core + Vertical Config + Client Config + adapters`

No crear forks del core para barberías, restaurantes, inmobiliarias, clínicas, estudios jurídicos, home services, etc. cuando las diferencias puedan expresarse como configuración, knowledge, prompts, reglas, campos y adapters.

### Conversación → transacción

Los ecosistemas chinos de super-apps muestran una dirección donde una conversación puede terminar en una acción/transacción real, no sólo en una recomendación.

Traducción Argentina/LATAM:

`WhatsApp → intención → consulta → calificación/cotización → turno/reserva → seña/pago cuando aplique → CRM → follow-up`

WhatsApp puede actuar como interfaz principal del sistema para muchas pymes sin necesidad de crear una app propia para el cliente final.

### CRM: System of Record → System of Execution

El CRM debe ser tratado como memoria operativa y superficie de ejecución, no sólo como inbox/pipeline.

Agentis debería poder usar CRM + base propia para:
- historial de conversaciones y oportunidades;
- compras/turnos/servicios cuando estén disponibles;
- última interacción y frecuencia;
- lifecycle del cliente;
- campañas y respuestas;
- métricas de conversión;
- señales de churn/inactividad;
- preferencias y segmentación permitida;
- tareas y acciones realizadas por agentes;
- trazabilidad y auditoría.

Sobre esa información, pequeños agentes reutilizables pueden detectar oportunidades y proponer/ejecutar acciones.

## Arquitectura objetivo: Agentis Business Operator

### Orchestrator Agent

Responsabilidad: recibir eventos/intenciones, consultar contexto y decidir qué agente especializado debe actuar. No debe contener toda la lógica de negocio. Coordina módulos pequeños y reemplazables.

Ejemplo:

`WhatsApp / webhook / schedule / CRM event`
`→ Orchestrator`
`→ Sales | Booking | Support | Retention | Loyalty | Quote | Analytics | Campaign Agent`
`→ tools/adapters`
`→ CRM / WhatsApp / Calendar / DB / payments / other systems`

### Agentes especializados reutilizables

**Lead / Qualification Agent** — entiende y califica leads, actualiza CRM y decide siguiente paso.

**Booking Agent** — consulta disponibilidad, agenda/reagenda/cancela y actualiza sistemas.

**Support Agent** — responde con knowledge del negocio y escala excepciones a humano.

**Quote Agent** — extrae requerimientos, arma/cotiza o coordina sourcing y solicita aprobación cuando corresponda.

**Retention / Reactivation Agent** — detecta clientes que dejaron de volver y propone campañas o contactos personalizados.

Ejemplo: `cliente frecuente → 60/90 días sin volver → segmento relevante → propuesta de acción → HITL → WhatsApp/campaña → medir retorno`.

**Loyalty Agent** — detecta clientes frecuentes/valiosos y recomienda acciones de fidelización, regalos, beneficios o mensajes.

Ejemplo: `frecuencia + valor + antigüedad → detectar cliente valioso → sugerir recompensa → aprobación → acción → registrar resultado`.

**Campaign Agent** — selecciona segmentos elegibles, genera propuesta/mensaje/oferta, coordina aprobación y ejecución, y mide resultados.

**Business Analyst Agent** — analiza CRM + base Agentis y genera métricas, anomalías y recomendaciones accionables.

Ejemplos:
- “Estos clientes no volvieron.”
- “Este segmento redujo frecuencia.”
- “Los martes cae la ocupación.”
- “Estos leads se pierden antes de reservar.”
- “Estos clientes son recurrentes y podrían recibir una acción de fidelización.”

El objetivo no es sólo mostrar dashboards: cuando sea seguro y conveniente, cada insight debe poder convertirse en una acción aprobable/ejecutable.

## Data layer

Separar conceptualmente:

`CRM = memoria comercial/operativa compartida con el cliente`

`Agentis DB = eventos + métricas + features + logs + estado técnico + datos auxiliares + aprendizaje del sistema`

No duplicar datos sin necesidad. Definir source-of-truth por entidad/campo. Usar adapters para que GHL sea el primer CRM pero no el único posible.

Candidato actual para Agentis DB: Supabase/Postgres. Redis sólo cuando estado efímero, locking, colas o performance lo justifiquen.

## Human-in-the-loop y permisos

Los agentes no deben recibir permiso universal por defecto. Cada tool/action debe tener nivel de riesgo y política de aprobación.

Ejemplo:

`leer métricas → automático`
`generar recomendación → automático`
`preparar campaña → automático`
`enviar campaña masiva / aplicar descuento / emitir cotización sensible → aprobación humana según reglas`

Mantener logs/auditoría de quién/qué agente tomó la decisión, qué datos utilizó, qué tool ejecutó y cuál fue el resultado.

## Content Factory + Business Operator

A futuro ambas fábricas pueden conectarse:

`Business Analyst detecta oportunidad → Campaign Agent define objetivo/segmento → Content Factory genera assets/copy/video → HITL → Publishing/WhatsApp/Ads → leads/respuestas → CRM → Lead/Sales Agent → conversión → métricas → aprendizaje`

Esto permitiría evolucionar desde “automatizamos tareas” hacia “Agentis ayuda a conseguir, convertir, atender y recuperar clientes”.

## China → Argentina: oportunidades adelantadas

### 1. WhatsApp como interfaz transaccional

Prioridad muy alta. Convertir conversaciones en acciones reales usando el mismo core: booking, cotización, CRM, follow-up y eventualmente pagos/señas.

### 2. AI Business Manager para pymes

Capa analítica/operativa que combine CRM + datos propios para detectar problemas/oportunidades y convertirlos en acciones. Construir después de tener suficiente core y datos reales; no desplazar Lead & Booking v1.

### 3. Vertical Business Operators

Mismo core con demos específicas para rubros de alta señal. Ej.: barberías, inmobiliarias, clínicas, restaurantes/home services según radar de demanda.

### 4. CRM como sistema de ejecución

El CRM Adapter debe evolucionar desde CRUD/contactos/pipeline hacia una interfaz para que agentes consulten contexto, creen tareas, cambien estados, disparen follow-ups y alimenten análisis.

### 5. Growth loop conectado a Content Factory

Insight → campaña → contenido → publicación/outreach → conversación → CRM → venta → medición. Potencial de largo plazo; construir modularmente.

## Implicación para roadmap

No cambiar el orden inmediato por estas señales. Mantener:

`Factory v0.1 → Lead & Booking Core → WhatsApp/GHL/Calendar/HITL → primera demo vertical → segunda vertical sin fork → Voice/Retell`

Pero diseñar primitives y contratos evitando bloquear la evolución hacia:

`Lead Agent → agentes especializados → Orchestrator → Agentis Business Operator`

## Principio de diseño

> Cada capacidad importante debe tender a ser un agente/componente pequeño, testeable y reutilizable. El orquestador coordina; no concentra toda la inteligencia ni toda la lógica.

> El valor futuro de Agentis no es sólo responder mensajes: es transformar datos y conversaciones del negocio en decisiones y acciones medibles.

## Radar China — reglas

En cada investigación separar:
1. adopción empresarial/casos reales;
2. herramientas/startups/productos emergentes;
3. hype o señales todavía débiles.

Para cada hallazgo preguntar:
- ¿qué problema real resuelve?;
- ¿qué evidencia de adopción existe?;
- ¿qué parte es específica del ecosistema chino?;
- ¿cuál es el equivalente técnico/comercial en Argentina?;
- ¿podemos implementarlo con Agentis Core + adapters?;
- ¿qué rubro local sería el mejor primer demo?;
- ¿es una idea para ahora, siguiente etapa o 6–24 meses?;
- ¿cambia realmente el backlog/stack o sólo confirma dirección?

Última actualización: 2026-09-11.
