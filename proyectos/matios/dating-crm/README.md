# MatiOS Dating CRM

## Objetivo

Construir un CRM relacional personal para MatiOS que concentre señales de Instagram, historial de conversaciones, contexto de citas y prioridades de seguimiento, y que permita a un agente sugerir aperturas, reactivaciones y próximos mensajes con contexto real.

La idea es evolucionar desde un análisis manual de exportaciones de Instagram hacia un sistema incremental y, más adelante, un copiloto conectado a mensajería. La navegación de Stories se trata como un módulo experimental separado de la integración oficial.

## Principios

- Separar **interés observado** de **oportunidad de cita**.
- No interpretar un like aislado como prueba de atracción.
- Dar más peso a señales de mayor esfuerzo: respuesta a Story, DM iniciado, conversación sostenida, aceptación/propuesta de plan.
- Aplicar recencia: una señal repetida reciente pesa más que actividad vieja.
- Mantener el interés de Mati como variable independiente del interés de la otra persona.
- El agente recomienda; el envío automático queda limitado a integraciones oficiales y reglas explícitas.
- La automatización experimental de navegador debe ser selectiva, de bajo volumen y desacoplada del CRM principal.

## Arquitectura propuesta

```text
Instagram Export / APIs
        |
        v
Ingesta y normalización
        |
        v
CRM relacional
  - contacts
  - interactions
  - conversations
  - relationship_state
  - manual_context
        |
        +--------------------+
        |                    |
        v                    v
Observed Interest       Date Opportunity
Score                   Score
        |                    |
        +---------+----------+
                  v
             Watchlist
                  |
                  v
       Story Opportunity Radar
                  |
                  v
        Agente de conversación
                  |
                  v
      Sugerencia / borrador / acción
```

## Estados de relación

- `never_spoken`: nunca hablaron.
- `spoken_no_date`: hablaron pero nunca salieron.
- `invited_no_date`: hubo invitación pero no cita.
- `dated`: ya hubo al menos una cita.
- `past_romantic`: beso/sexo/historial romántico previo si Mati decide registrarlo.
- `paused`: hubo interés pero no conviene actuar ahora.
- `discarded_by_me`: Mati no quiere invertir.

## Modelo inicial de contacto

```text
contact_id
instagram_username
display_name
source                 # instagram / tinder / bumble / manual
source_date
relationship_state
my_interest            # 0-5 manual
observed_interest_score
opportunity_score
watchlist_priority
last_interaction_at
last_inbound_at
last_outbound_at
last_story_signal_at
notes
```

## Eventos a normalizar

Cada interacción debe terminar en una tabla/event log común:

```text
event_id
contact_id
event_type
timestamp
direction              # inbound / outbound / passive
source                  # story / dm / post / app / manual
source_id
metadata
```

Tipos deseados:

- `story_like`
- `story_reply`
- `dm_received`
- `dm_sent`
- `dm_initiated_by_contact`
- `post_like`
- `comment`
- `follow`
- `date_invite_sent`
- `date_invite_accepted`
- `date_invite_declined`
- `date_happened`
- `manual_note`

## Scoring

### 1. Observed Interest Score

Solo conducta observable de la otra persona.

Jerarquía conceptual:

```text
vista pasiva < like < reply de Story < DM iniciado < charla sostenida < aceptar/proponer plan
```

Debe considerar:

- frecuencia;
- recencia;
- repetición;
- iniciativa;
- esfuerzo de la señal;
- aceleración reciente.

No se presenta inicialmente como porcentaje de probabilidad. Se usa para ranking y categorías (`bajo`, `medio`, `alto`, `muy alto`).

### 2. Date Opportunity Score

Combina:

- Observed Interest Score;
- `my_interest`;
- estado de relación;
- invitaciones previas;
- rechazos y contrapropuestas;
- tiempo desde último contacto;
- momentum pendiente;
- contexto manual.

Más adelante se puede calibrar con outcomes reales: invitación -> respuesta -> cita -> segunda cita.

## Watchlist dinámica

El módulo de Stories no debe recorrer todo Instagram. Solo observa contactos con una razón concreta.

Entradas posibles a watchlist:

- varios likes/reacciones recientes;
- conversación previa;
- `my_interest` alto;
- contacto nuevo proveniente de Tinder/Bumble;
- invitación o conversación pendiente;
- subida reciente de score;
- contacto marcado manualmente.

Prioridades tentativas:

- `P1`: alta oportunidad / contacto nuevo de app / señales repetidas recientes.
- `P2`: interés medio con historial útil.
- `P3`: observación ocasional.
- `OFF`: sin señales o sin interés de Mati.

Para contactos nuevos de Tinder/Bumble se puede activar una ventana de observación intensa de 14-21 días y degradarla automáticamente si no aparecen señales.

## Story Opportunity Radar (experimental)

Objetivo: detectar oportunidades puntuales, no mirar Stories masivamente.

Flujo deseado:

```text
Watchlist
  -> navegador consulta perfiles priorizados
  -> detecta Story nueva
  -> captura metadata y contenido mínimo necesario
  -> visión/LLM describe tema
  -> consulta historial del CRM
  -> clasifica: IGNORAR / POSIBLE / BUENA / MUY BUENA
  -> genera 2-3 aperturas
  -> Mati aprueba
  -> envío por canal permitido
```

Guardar preferentemente:

- username;
- timestamp;
- tipo de Story;
- descripción breve;
- texto detectado si existe;
- temas/tags;
- si generó oportunidad;
- acción tomada;
- outcome.

Evitar conservar multimedia completa cuando no sea necesario.

## Casos de uso del agente

- “¿Quién viene mostrando más interés este mes?”
- “Mostrame chicas que me gustan y con oportunidad alta.”
- “Nunca hablé con ella: ¿hay suficientes señales para abrir?”
- “Hablamos hace dos meses y quedó muerto: ¿cómo retomo?”
- “¿Quién inició más veces conversación conmigo?”
- “¿Qué contactos están calentándose?”
- “¿Qué contactos se enfriaron?”
- “Dame 3 mensajes para esta Story usando nuestro historial.”
- “No quiero remar: filtrame solo oportunidades con reciprocidad.”

## Dashboard MVP

- Top por Observed Interest.
- Top por Date Opportunity.
- Más likes a Stories.
- Más respuestas a Stories.
- Más DMs entrantes/iniciados.
- `Heating up` (aceleración reciente).
- `Cooling off`.
- Nuevos contactos de Tinder/Bumble.
- Hablamos pero nunca salimos.
- Nunca hablamos pero muestran señales.
- Historial romántico previo separado de prospectos nuevos.

## Roadmap

### Fase 1 — Import histórico de Instagram
- [ ] Recibir ZIP JSON de Instagram.
- [ ] Identificar archivos y semántica real de cada export.
- [ ] Normalizar usernames.
- [ ] Construir event log.
- [ ] Construir primera ficha por contacto.

### Fase 2 — Scoring + tablero
- [ ] Definir pesos iniciales.
- [ ] Implementar recency decay.
- [ ] Calcular Observed Interest.
- [ ] Agregar contexto manual.
- [ ] Calcular Date Opportunity.
- [ ] Dashboard inicial.

### Fase 3 — Memoria conversacional
- [ ] Ingesta de DMs.
- [ ] Resumen por contacto.
- [ ] Extracción de temas/callbacks.
- [ ] Estado de conversación y próxima acción.

### Fase 4 — Agente copiloto
- [ ] Skill/prompt de conversación.
- [ ] Generación de aperturas y reactivaciones.
- [ ] Recomendación basada en reciprocidad e historial.
- [ ] Aprobación humana antes de enviar.

### Fase 5 — Integración incremental
- [ ] Investigar y conectar APIs oficiales de Instagram Messaging disponibles para la cuenta profesional.
- [ ] Webhooks/eventos entrantes.
- [ ] Persistencia incremental en CRM.
- [ ] Borradores y respuestas desde MatiOS.

### Fase 6 — Story Opportunity Radar
- [ ] Investigar límites oficiales de Stories.
- [ ] POC de navegador en lote chico y supervisado.
- [ ] Watchlist dinámica.
- [ ] Captura selectiva de Stories.
- [ ] Clasificador de oportunidad.
- [ ] Métricas de efectividad y límites operativos.

## Métricas de éxito

A futuro, registrar outcomes para aprender del comportamiento real:

```text
apertura sugerida
-> enviada
-> respondió
-> conversación sostenida
-> invitación
-> aceptó
-> cita ocurrió
-> segunda cita
```

Con suficientes ejemplos, los scores se podrán calibrar sobre datos de Mati en vez de reglas genéricas.

## Reutilización futura en Alien

El núcleo debe ser genérico. No modelar “chicas” como entidad especial: usar `contact`, `interaction`, `relationship_state`, `signal`, `conversation`, `event`, `recommended_action`.

MatiOS tendrá una vista de dating, pero el mismo motor podrá reutilizarse después para networking, ventas, leads y seguimiento de relaciones dentro de Alien.
