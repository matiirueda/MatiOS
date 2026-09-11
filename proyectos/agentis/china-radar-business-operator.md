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

## Estrategia de modularización

No intentar diseñar desde el día 1 una constelación perfecta de microagentes. La secuencia preferida es:

`flujo grande funcional → observar comportamiento real → detectar fronteras → extraer módulos/agentes → reutilizar`

Principio:

> Primero integrar para aprender. Después desacoplar para escalar.

Separar por responsabilidad y contrato, no por moda. Un módulo merece independizarse cuando tiene entradas/salidas claras, errores o estado propios, cambia de manera independiente o aparece reutilizado en varios flujos.

Un “agente” no tiene por qué ser siempre un LLM autónomo: puede ser un subworkflow de n8n determinista. El LLM se incorpora sólo cuando la tarea requiere lenguaje, ambigüedad, razonamiento o generación.

## Model Router — costo/calidad por especialidad

Agentis no debe usar el mismo modelo para todo ni asumir que el modelo más caro es siempre el correcto. Cada agente/componente debería declarar qué capacidad necesita y permitir que una capa de routing elija el proveedor/modelo más adecuado.

Patrón objetivo:

`task type + modality + complexity + quality threshold + latency need + context size + budget → model/provider`

Ejemplos:
- clasificación, extracción estructurada, dedupe semántico, scoring inicial y prospecting simple → modelo pequeño/barato si alcanza la calidad requerida;
- decisiones ambiguas, planificación, análisis comercial complejo o excepciones → modelo más capaz;
- imagen/video/audio → modelos especializados por modalidad;
- código → modelos especializados de ingeniería como Claude/Codex según la tarea;
- revisión crítica → preferentemente modelo/agente distinto del productor cuando aporte diversidad real.

El agente debe pedir una capacidad (“clasificar lead”, “extraer campos”, “generar imagen”, “revisar workflow”) y no quedar acoplado innecesariamente a un nombre de modelo concreto.

### Fallback y escalado

El router debe poder aplicar escalado progresivo:

`modelo barato → validar confianza/resultado → si falla o hay ambigüedad → modelo más fuerte → si sigue siendo sensible → HITL`

Esto permite reducir costo manteniendo calidad y reservar modelos caros para los casos donde realmente agregan valor.

### Objetivo de costo

Optimizar costo por resultado útil, no costo por llamada. Un modelo barato que obliga a reintentos frecuentes, genera errores o baja conversión puede ser más caro que uno superior.

## Observabilidad, logs y evaluación continua

La capacidad de medir debe diseñarse desde el comienzo, aunque la primera implementación sea simple. Sin logs y métricas no se puede saber qué agente, prompt o modelo funciona mejor ni dirigir correctamente el Model Router.

Cada ejecución relevante debería registrar, cuando aplique:
- `trace_id / run_id`;
- cliente/vertical/workflow/agente;
- versión del workflow/agente/prompt/config;
- proveedor y modelo utilizado;
- motivo/ruta elegida por el router;
- tokens o unidades consumidas;
- costo estimado/real;
- latencia;
- cantidad de retries/fallbacks;
- tool calls realizadas y resultado;
- input/output estructurado necesario para evaluación, respetando privacidad y minimización de datos;
- error/failure reason;
- intervención humana y motivo;
- outcome de negocio posterior cuando pueda asociarse.

### Métricas técnicas

Ejemplos:
- tasa de éxito por agente/modelo;
- latencia p50/p95;
- costo medio por ejecución;
- tokens por tarea;
- tasa de retry;
- tasa de fallback a modelo superior;
- tool-call failure rate;
- porcentaje de conversaciones que requieren handoff humano.

### Métricas de calidad

No limitar evaluación a “la API respondió 200”. Según el agente medir:
- accuracy de clasificación/extracción sobre muestras etiquetadas;
- respuestas aceptadas/corregidas por humanos;
- errores o alucinaciones detectadas;
- cumplimiento de formato/reglas;
- resolución sin escalado;
- calidad de cotización/recomendación;
- precisión de selección de tool/action.

### Métricas de negocio

Siempre que sea posible conectar la evaluación técnica con outcomes reales:

`modelo/agente → acción → resultado de negocio`

Ejemplos:
- lead → respuesta → booking;
- booking → asistencia/no-show;
- reactivation → respuesta → compra/turno;
- campaña → conversión/ingreso;
- support → resolución / escalado;
- quote → aceptación;
- loyalty action → recurrencia posterior.

La meta es poder responder preguntas como:
- “¿El modelo barato mantiene conversión?”
- “¿Qué prompt reduce handoffs?”
- “¿Qué agente está generando más errores?”
- “¿El modelo premium agrega suficiente valor para justificar su costo?”
- “¿Qué vertical necesita reglas distintas?”

### Feedback loop / mejora continua

Patrón deseado:

`logs + outcomes + feedback humano → dataset/evals → comparar modelos/prompts/config → actualizar router/agente → medir nuevamente`

Los cambios de modelo, prompt o lógica importante deberían poder compararse con una baseline mediante evals o A/B tests controlados antes de expandirse a todos los clientes.

Principio:

> Lo que no medimos no se puede optimizar. Agentis debe aprender no sólo de las conversaciones, sino también de qué modelo, agente y decisión produjo mejores resultados al menor costo total.

## Data layer

Separar conceptualmente:

`CRM = memoria comercial/operativa compartida con el cliente`

`Agentis DB = eventos + métricas + features + logs + estado técnico + datos auxiliares + aprendizaje del sistema`

No duplicar datos sin necesidad. Definir source-of-truth por entidad/campo. Usar adapters para que GHL sea el primer CRM pero no el único posible.

Candidato actual para Agentis DB: Supabase/Postgres. Redis sólo cuando estado efímero, locking, colas o performance lo justifiquen.

Los logs de observabilidad y evaluación deben diseñarse con retención, privacidad y acceso definidos. No almacenar datos sensibles “por las dudas”; registrar lo necesario para operación, auditoría y evaluación.

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

### 6. Cost-aware AI como ventaja operativa

Diseñar desde temprano routing de modelos + observabilidad para que la misma capacidad pueda usar modelos diferentes según complejidad, modalidad, costo y calidad. Esto puede convertirse en ventaja de margen para Agentis y en una forma de ofrecer soluciones mejores sin pagar siempre el modelo premium.

## Implicación para roadmap

No cambiar el orden inmediato por estas señales. Mantener:

`Factory v0.1 → Lead & Booking Core → WhatsApp/GHL/Calendar/HITL → primera demo vertical → segunda vertical sin fork → Voice/Retell`

Pero diseñar primitives y contratos evitando bloquear la evolución hacia:

`Lead Agent → agentes especializados → Orchestrator → Agentis Business Operator`

Desde Factory v0.1 incluir observabilidad mínima: identificadores de ejecución, agente/workflow, versión/config, modelo/proveedor, costo/uso, latencia, outcome, error y handoff. El sistema de evals sofisticado puede crecer después, pero los datos necesarios no deberían empezar a recolectarse tarde.

## Principios de diseño

> Cada capacidad importante debe tender a ser un agente/componente pequeño, testeable y reutilizable. El orquestador coordina; no concentra toda la inteligencia ni toda la lógica.

> Primero integrar para aprender. Después desacoplar para escalar.

> Usar LLM sólo donde aporta. Determinismo cuando alcance; razonamiento cuando haga falta.

> Elegir modelo por capacidad, calidad necesaria y costo total esperado, no por marca ni por “usar siempre el mejor”.

> Lo que no se mide no se puede optimizar: cada agente importante debe poder relacionar ejecución, costo, calidad y outcome.

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
