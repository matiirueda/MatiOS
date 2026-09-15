# Deep Dive — Erik Taveras: homelab, agentes, skills, n8n, MCP y producto

> Fecha: 2026-09-15  
> Alcance: investigación pública sobre Erik Taveras, AutoDev Community, TaverasOS/Taveras Solutions, TalosFlow y repos públicos; contraste con documentación primaria de Hermes Agent y n8n.  
> Objetivo: extraer decisiones aplicables a MatiOS/Agentis, distinguir patrón reusable de hype y convertir hallazgos en experimentos concretos.

---

## 0. Veredicto ejecutivo

Erik no tiene una “herramienta secreta”. Lo valioso es que ensambló de forma coherente varias piezas que nosotros también venimos identificando:

- **n8n como orquestador**, no como cerebro;
- **agentes/runtimes separados de los modelos**;
- **skills como procedimientos versionables**;
- **MCP como interfaz común de herramientas**;
- **human-in-the-loop en acciones de dinero, clientes o reputación**;
- **aislamiento real por permisos/radio de daño**;
- **observabilidad y costos como parte del producto**;
- **homelab como plataforma de aprendizaje y ejecución, no como hobby de hardware**;
- **convertir cada problema repetido en un artefacto reutilizable: skill, script, workflow, repo, tutorial o producto**.

La conclusión para MatiOS no es “copiar su stack”. Es avanzar hacia una **plataforma de empleados digitales empaquetables y auditables**, donde el runtime, el modelo, los tools y la memoria puedan cambiar sin romper la definición del empleado.

El hallazgo más fuerte de esta segunda ronda es que Hermes ya está evolucionando hacia algo sorprendentemente parecido a la idea que llamamos **Employee Pack**: perfiles distribuibles con `SOUL.md`, configuración, MCP, skills, cron y una separación explícita entre archivos mantenidos por el autor y estado privado del usuario. Eso reduce mucho el trabajo conceptual que tendríamos que inventar desde cero.

---

# 1. Lo más importante de Erik no es el homelab: es su patrón operativo

Al recorrer su web, comunidad, repos y recursos recientes, aparece un patrón consistente:

```text
Problema real
→ lo resuelve para sí mismo o para un cliente
→ escribe criterio y reglas
→ automatiza las partes repetibles
→ empaqueta el procedimiento como skill/script/app/workflow
→ publica el aprendizaje
→ usa el contenido como distribución
→ el feedback mejora el artefacto
→ algunas piezas pasan a producto/servicio
```

Ejemplos públicos:

- `Client-Payment-Skill`: conversación → Stripe → PDF → email con aprobación humana.
- skill de Zoom: llamada → transcripción → compromisos/objeciones/follow-up.
- skill de Instagram: comentarios → temas/FAQs/leads/ideas de contenido.
- skill de edición de video: raw footage → reglas cuantificadas → QA → reel.
- ESP32 data panel: proyecto físico → repo + skill que encapsula pinout, trampas y criterio.
- InvoiceFlow: foto/WhatsApp → OCR → validación → DB → analytics/export.
- Django SaaS boilerplate: infraestructura repetitiva de SaaS convertida en base reusable.

La idea detrás de esto está resumida en una frase de su recurso de edición: **la IA no reemplaza el criterio; evita tener que ejecutarlo manualmente todas las veces**.

### Aplicación MatiOS

Este patrón debería ser una regla operativa:

```text
Cada vez que resolvemos algo por segunda o tercera vez:
1. identificar decisiones repetibles;
2. separar criterio humano de ejecución mecánica;
3. convertir el criterio en spec/skill/tests;
4. convertir ejecución en código/workflow;
5. guardar evidencia de qué funcionó;
6. hacerlo reutilizable entre proyectos.
```

Esto conecta Content Factory, Agentis, desarrollo, research y negocios físicos.

---

# 2. TalosFlow: más cercano a Agentis de lo que parecía

La página pública actual de TalosFlow describe un CRM multi-tenant centrado en WhatsApp, con:

- Meta WhatsApp Cloud API;
- onboarding vía Embedded Signup;
- inbox en tiempo real;
- bot ↔ humano;
- base RAG con pgvector;
- memoria/contexto;
- function calling;
- scoring y funnels;
- auto-follow-up;
- aislamiento por tenant;
- matriz de roles/permisos;
- audit logs por tenant.

Esto es muy importante porque el producto ya no se presenta simplemente como “bot de WhatsApp”. Es una **plataforma operacional alrededor de conversaciones**.

### Lo que copiaría conceptualmente

1. **Inbox humano y agente en la misma superficie**. El handoff no es excepción: es un modo explícito.
2. **Tenant isolation como feature de primera clase**.
3. **Audit log por tenant**, especialmente cuando el agente cambia datos o etapas.
4. **Knowledge base + actions**. RAG solo responde; function calling permite operar.
5. **Pipeline/lead scoring estructurado**, no todo guardado en memoria vectorial.

### Donde Agentis debería diferenciarse

No quiero que Agentis sea solo otro WhatsApp CRM.

La ventaja debe ser horizontal:

```text
Conversation layer
+ structured operational data
+ employee packs
+ permissions / approvals
+ auditability
+ customer preference memory
+ reusable workflows
+ metrics / evals
```

TalosFlow puede ser un benchmark de UX/onboarding, pero Agentis debería aspirar a que el CRM sea **una de las superficies**, no el producto entero.

---

# 3. Hermes Agent: validación fuerte del diseño “empleado = paquete”

## 3.1 El runtime no es el modelo

Hermes confirma una separación sana:

```text
agent runtime != model
```

El runtime aporta memoria, herramientas, canales, cron, skills, delegación, sandbox y estado. El modelo puede reemplazarse.

Para Agentis esto evita un error enorme: ligar un “empleado” a GPT/Claude/Hermes específico.

El contrato debería vivir arriba:

```text
Employee Definition
    ↓
Runtime Adapter
    ↓
Hermes / Claude Code / Codex / future runtime
    ↓
Model Adapter
    ↓
OpenAI / Anthropic / local / other
```

---

## 3.2 Skills como memoria procedural

Hermes trata skills como conocimiento procedural. No es solo “información que el agente recuerda”; es **cómo hacer una tarea**.

Distinción útil:

```text
Knowledge memory = qué sé
Procedural memory = cómo hago
Operational state = qué está pasando ahora
```

En MatiOS debemos evitar mezclar las tres.

Ejemplo:

- “Cliente X usa GoHighLevel” → conocimiento/contexto.
- “Cómo crear un lead y registrar source” → skill/procedimiento.
- “Lead 582 esperando aprobación” → estado operacional.

---

## 3.3 Blueprints: casi exactamente nuestra idea de automatización instalable

La documentación oficial de Hermes permite que una skill incluya un `blueprint` con una automatización sugerida. La instalación **no crea silenciosamente el cron**; se propone y el usuario lo acepta.

Esto es una decisión de producto excelente:

```text
install package != grant autonomy
```

Un Employee Pack de Agentis debería seguir el mismo principio:

```text
Instalar empleado
→ ver capacidades
→ ver permisos solicitados
→ ver schedules propuestos
→ aceptar/rechazar
→ conectar credenciales
→ prueba controlada
→ activar producción
```

No se debe activar autonomía por el mero hecho de instalar una plantilla.

---

## 3.4 Profile distributions: hallazgo clave

Hermes ya soporta distribuciones de perfiles que pueden contener algo similar a:

```text
SOUL.md
config.yaml
mcp.json
skills/
cron/
distribution.yaml
README.md
```

Y distingue entre:

### Mantenido por la distribución
- identidad base;
- skills;
- MCP config;
- automatizaciones;
- configuración versionada.

### Mantenido por el usuario
- memorias;
- sesiones;
- auth/secrets;
- logs;
- workspace;
- estado local.

Eso es exactamente lo que necesitamos para que un Employee Pack pueda **actualizarse sin pisar el historial del cliente**.

### Diseño MatiOS derivado

```text
Employee Pack (versionado por nosotros)
├── manifest.yaml
├── role.md / SOUL.md
├── policies.yaml
├── tool_contracts/
├── skills/
├── workflows/
├── schedules/
├── evals/
└── migration/

Tenant State (propiedad del cliente)
├── credentials
├── customer data
├── memory
├── conversation history
├── approvals
├── audit logs
└── business overrides
```

**Nunca mezclar paquete versionado con estado del cliente.**

---

# 4. n8n MCP cambió el rol de Claude/Codex en nuestro stack

La documentación oficial de n8n confirma que su MCP de instancia ya puede:

- buscar workflows;
- crear workflows;
- editar workflows;
- crear/editar data tables;
- probar/ejecutar workflows expuestos.

n8n lo presenta explícitamente como una forma de construir y depurar desde Claude/ChatGPT/IDE sin copiar JSON.

## Implicación

Nuestra secuencia de prototipado puede mejorar:

```text
Mati define proceso / aceptación
↓
Claude Code o Codex
↓ MCP
crea workflow n8n
↓
prueba ejecución
↓
lee error / corrige
↓
documenta
↓
si madura, extraemos lógica compleja a código
```

Esto hace viable lo que veníamos llamando “empleado n8n developer”.

### Pero con una restricción importante

No darle acceso irrestricto al n8n de producción.

Separar:

- instancia/project de dev;
- workflows staging;
- producción con promoción controlada;
- credenciales de dev distintas;
- backup/export antes de cambios importantes.

La capacidad de editar workflows vía MCP es potentísima pero aumenta el radio de daño.

---

# 5. Human-in-the-loop: ya es primitive de infraestructura

La documentación actual de n8n permite poner aprobación humana **delante de herramientas concretas** de un agente. El workflow pausa y muestra nombre de tool + parámetros. El humano aprueba o rechaza.

Canales soportados incluyen chat, Slack, Discord, Telegram, Teams, Gmail, WhatsApp Business Cloud, Google Chat y Outlook.

Esto valida nuestra regla:

```text
AI prepares
Human authorizes
System executes
```

No necesitamos inventar desde cero toda la mecánica para prototipos n8n.

### Taxonomía recomendada de riesgo

#### Nivel 0 — lectura
- leer catálogo;
- buscar agenda;
- consultar stock;
- resumir conversación.

Autónomo.

#### Nivel 1 — reversible interno
- crear draft;
- mover etapa CRM;
- crear tarea;
- etiquetar lead.

Autónomo al principio con logs; evaluar luego.

#### Nivel 2 — comunicación externa
- enviar WhatsApp;
- enviar email;
- publicar contenido;
- confirmar cita.

Aprobación inicialmente; automatizar solo flujos muy acotados y testeados.

#### Nivel 3 — dinero / contrato / irreversible
- cobrar;
- emitir reembolso;
- eliminar datos;
- comprar;
- modificar precio/promoción;
- aceptar términos.

Aprobación fuerte + idempotencia + audit log.

---

# 6. El Tool Gateway sigue siendo necesario aunque usemos MCP

MCP es el protocolo de tool exposure; **no reemplaza nuestra política de seguridad**.

Erik explica correctamente que si un permiso existe solo en el prompt, no es un límite real. Hermes y n8n también agregan toolsets/approval, pero para Agentis multi-tenant necesitamos una capa propia.

## Agentis Tool Gateway

```text
employee runtime
      ↓ MCP/HTTP
Agentis Tool Gateway
      ├── tenant scope
      ├── employee scope
      ├── action allowlist
      ├── schema validation
      ├── rate limits
      ├── spend limits
      ├── idempotency
      ├── approval requirement
      ├── policy evaluation
      ├── secrets broker
      └── audit event
             ↓
 n8n / CRM / WhatsApp / DB / calendar / payments
```

### La regla más importante

**El runtime del agente no debería ver la credencial final cuando pueda evitarse.**

Ideal:

```text
agent → scoped capability token → gateway → provider credential
```

Eso permite revocar un empleado sin rotar todas las credenciales del negocio.

---

# 7. Delegación: usar subagentes como workers efímeros, no como memoria compartida

Hermes deja claro que sus delegates trabajan en contextos aislados. Para trabajo que debe sobrevivir a la sesión recomienda cron/procesos persistentes.

Esto nos da una regla de arquitectura:

### Subagent = trabajador temporal

- recibe objetivo y contexto mínimo;
- no necesita toda la memoria;
- produce artefacto/evidencia;
- termina.

### Employee = entidad durable

- identidad;
- permisos;
- memoria;
- métricas;
- historial;
- schedules;
- owner.

No confundamos un “subagente” con un “empleado”.

---

# 8. Modelo escalonado: gran oportunidad para costos de Agentis

Erik propone una escalera:

```text
Filtro pequeño
→ trabajador pequeño/mediano
→ especialista grande solo si hace falta
```

Más importante que sus porcentajes de ahorro es el criterio: **usar el modelo más pequeño que alcance la calidad requerida**.

## Agentis model routing v0

Ejemplo WhatsApp:

### Sin LLM
- horarios exactos;
- precios estructurados;
- stock;
- estado de reserva;
- confirmaciones mecánicas.

Primero buscar en DB/reglas.

### Small model
- clasificación intent;
- extracción de campos;
- resumen corto;
- routing;
- sentiment/urgency simple.

### Strong model
- negociación;
- ambigüedad;
- conversación compleja;
- planning;
- investigación;
- generar propuesta.

Esto puede convertirse en una feature de plataforma: **Model Router basado en evaluación, costo y riesgo.**

No mover tareas a modelos chicos por intuición. Crear un set de casos reales y medir.

---

# 9. Observabilidad: pasar de “servidores” a “empleados”

El homelab de Erik usa herramientas estándar para uptime, métricas y logs. La lección no es instalar todas.

Necesitamos dos planos de observabilidad:

## Infra
- CPU/RAM/storage;
- uptime;
- containers;
- queues;
- DB;
- latency.

## Employee Operations
- jobs started/completed/failed;
- tool calls;
- approvals;
- retries;
- token/model cost;
- error class;
- handoff humano;
- conversion/business outcome;
- eval score;
- workflow/skill/model version.

Un empleado que “está online” pero toma malas decisiones está caído desde el punto de vista del negocio.

### MatiOS Control Center

El HUD del homelab inspiró una mejor idea:

```text
EMPLOYEES
Sales Agent       OK      42 jobs      4 approvals
Research Agent    OK      9 jobs       $0.84
Content Agent     WARN    2 QA fails
Inventory Agent   OK      125 events

BUSINESS
Leads handled
Meetings booked
Quotes sent
Human minutes saved
Revenue influenced
Cost per task

QUALITY
Eval pass rate
Handoff rate
Rejection rate
Incident count
```

Esto sí podría ser una capa vendible de Agentis.

---

# 10. El patrón “conversaciones → datos reutilizables” aparece varias veces

La skill de Zoom de Erik dice algo muy cercano a una idea fundamental para MatiOS: el valor no es obtener la transcripción, sino hacer que las conversaciones dejen de desaparecer y se conviertan en material que puede buscarse y cruzarse meses después.

Esto encaja directamente con el **Customer Preference Graph** recién documentado en MatiOS.

El mismo patrón aplica a:

```text
WhatsApp
Zoom
Instagram comments
support chats
sales calls
forms
reviews
purchase history
```

Pero no conviene tirar todo a una vector DB y llamarlo “memoria”.

Hay que extraer estructuras:

- necesidades;
- objeciones;
- preferencias;
- compromisos;
- entities;
- fechas;
- productos;
- decisión;
- sentimiento/confianza;
- provenance.

Texto original queda como evidencia; datos estructurados alimentan operación.

---

# 11. Content Factory: Erik está construyendo un loop similar al nuestro

Sus recursos recientes muestran un pipeline implícito:

```text
proyecto real
→ reel/video
→ comentarios señalan interés
→ recurso/skill open source
→ comunidad/newsletter
→ reputación
→ consultoría/producto
→ nuevos casos reales
→ nuevo contenido
```

Además tiene una skill que analiza comentarios de Instagram para detectar:

- temas;
- FAQs;
- leads;
- ideas de contenido.

Es decir, el output del contenido vuelve como input al producto.

### Aplicación a MatiOS Content Factory

```text
Own business activity
→ capture raw material
→ research/angles
→ publish
→ capture comments/DMs/metrics
→ classify demand/signals
→ generate backlog
→ build/test product
→ publish results
```

Esto es más potente que automatizar “hacer posts”.

La Content Factory debería ser una **máquina de aprendizaje comercial**, no solo una máquina de volumen.

---

# 12. Skills: el formato que deberíamos exigir internamente

Al inspeccionar el `Client-Payment-Skill`, el valor está en que define:

- trigger/description;
- información obligatoria;
- secuencia;
- herramientas;
- validaciones;
- scripts;
- aprobación antes del email;
- outputs;
- manejo de configuración.

Pero podemos endurecer el estándar para MatiOS.

## MatiOS Skill Spec v0

Cada skill debería incluir:

```text
metadata
- name
- purpose
- version
- owner
- risk level
- supported runtimes

triggers
- when to use
- when NOT to use

inputs
- required
- optional
- validation

procedure
- deterministic steps
- reasoning points

permissions
- tools allowed
- data scope
- network scope

approvals
- exact actions that require human confirmation

outputs
- schema
- artifacts

failures
- expected errors
- recovery
- stop conditions

tests/evals
- happy paths
- adversarial cases
- regression cases

observability
- events emitted
- metrics

references
- docs/source of truth
```

La skill deja de ser un prompt largo y pasa a ser una unidad de software operacional.

---

# 13. Los repos públicos de Erik más útiles para nosotros

## A. Client-Payment-Skill — ADAPTAR patrón

Valor:
- skill concreta;
- MCP + script;
- human approval;
- artefactos persistentes;
- MIT.

Qué nos sirve: estructura y el patrón conversación → tools → documento → aprobación → envío.

No copiar literal: está personalizado a Stripe/SMTP y no es multi-tenant.

**Decisión: TEST/ADAPT.**

---

## B. InvoiceFlow/facturas-opensource — ADAPTAR arquitectura

Tiene buenas ideas de producto:

- WhatsApp como interfaz de captura;
- OCR/IA;
- confidence score;
- validaciones deterministas después de la IA;
- deduplicación por hash;
- rate limiting;
- costo de OpenAI;
- webhooks;
- multi-tenant;
- exportación a sistemas downstream.

Patrón particularmente bueno:

```text
AI extraction
→ deterministic validation
→ quality audit
→ persistence
→ event/webhook
```

Esto es exactamente cómo deberían funcionar muchos Employee Packs.

**Decisión: ADOPT patrón, no necesariamente repo completo.**

---

## C. django-saas-boilerplate — WATCH / referencia de packaging

Interesante por lo que deja afuera explícitamente y por separar open-source base de paid product.

Lección comercial:

```text
free useful core
→ demuestra calidad
→ paid layer ahorra trabajo difícil/repetitivo
```

MatiOS podría en el futuro publicar skills/Employee Packs base y vender:

- hosting;
- managed credentials;
- observability;
- multi-tenant;
- permissions;
- vertical packs;
- support;
- analytics.

---

## D. esp32-data-panel — WATCH por metodología

No nos interesa por el hardware en sí. Sí por cómo empaqueta:

- probe/autodiagnóstico;
- errores conocidos;
- skill con criterio acumulado;
- configuración fuera del repo;
- producto físico + software + contenido.

Se alinea con nuestros experimentos de productos físicos y MatiOS.

---

## E. claude-dashboard — IGNORE como componente, ADOPT idea

No necesitamos su dashboard físico de Claude.

Pero sí confirma que logs locales de herramientas/agentes pueden convertirse en métricas útiles de costo/actividad.

**Decisión: no integrar; usar inspiración para Control Center.**

---

# 14. Lo que NO copiaría

## 1. 132 contenedores

Resultado de necesidades acumuladas, no meta.

Nuestra meta debe ser reducir piezas hasta que una necesidad real justifique otra.

## 2. Hardware antes de carga

Con nuestra PC + Docker/VMs alcanzará para aprender mucho. Mini PC/NAS llega cuando una métrica lo pida.

## 3. Self-hosting ideológico

Self-host cuando mejora:
- costo;
- privacidad;
- control;
- disponibilidad;
- aprendizaje relevante.

SaaS cuando reduce operación sin generar lock-in crítico.

## 4. LLM para todo

DB/regla/API determinista antes que IA cuando la respuesta ya existe estructurada.

## 5. “Memoria infinita”

Memoria sin schema, provenance, decay y ownership se vuelve basura.

---

# 15. Matriz de decisión

| Hallazgo | Decisión | Prioridad | Motivo |
|---|---|---:|---|
| n8n como orquestador | ADOPT | P0 | Ya encaja con nuestro diseño |
| n8n native MCP para crear/editar workflows | TEST | P0 | Puede acelerar muchísimo prototipado |
| Human approval por tool en n8n | ADOPT | P0 | Primitive lista para nuestro HITL |
| Agentis Tool Gateway | BUILD | P0 | Necesario para seguridad multi-tenant |
| Hermes runtime | TEST | P0 | Muy alineado con empleados durables |
| Hermes profile distributions | ADAPT | P0 | Base conceptual del Employee Pack |
| Skills open standard | ADOPT | P0 | Evita lock-in de runtimes |
| Customer Preference Graph | BUILD MVP | P0/P1 | Diferenciación comercial fuerte |
| Employee Control Center | DESIGN | P1 | Observabilidad + producto vendible |
| FreshRSS/research radar | TEST | P1 | Alimenta varios proyectos a la vez |
| Model routing local/cloud | TEST LATER | P1 | Ahorro cuando exista volumen real |
| TalosFlow feature parity | BENCHMARK | P1 | Competidor/referencia directa |
| InvoiceFlow architecture | ADAPT | P1 | Buen patrón AI→validation→events |
| Homelab multi-node | WAIT | P2 | No hay carga que lo justifique aún |
| ESP32 panels | WATCH | P3 | Aprendizaje/marketing, no core |

---

# 16. Experimentos concretos recomendados

## Experimento 1 — n8n Dev Employee

Objetivo: que Claude Code/Codex cree y modifique un workflow en una instancia de desarrollo mediante n8n MCP.

Workflow de prueba:

```text
Webhook
→ validar JSON
→ guardar Postgres
→ llamar agente solo si campo requiere clasificación
→ generar output
→ audit log
```

Criterios:
- puede construir sin edición manual significativa;
- puede ejecutar y corregir error;
- deja documentación;
- no accede a credenciales productivas.

---

## Experimento 2 — Hermes Research Employee

Un solo empleado durable, sin tocar clientes.

```text
Daily sources
→ collect
→ dedup
→ analyze
→ cite evidence
→ compare to MatiOS
→ output watch/test/adopt/ignore
```

Tools read-only inicialmente.

Medir:
- ruido;
- precisión;
- costo por hallazgo útil;
- cantidad de hallazgos que realmente terminan en backlog.

---

## Experimento 3 — Employee Pack v0

Crear un paquete manual para `Research Employee`:

```text
manifest
role
policies
tools
skills
schedule
evals
```

Hacer un adapter simple Hermes y un adapter Claude/Codex.

Objetivo: demostrar que el **empleado existe independientemente del runtime**.

---

## Experimento 4 — Customer Preference Extractor

20 conversaciones anonimizadas/sintéticas.

Extraer:
- preferencias explícitas;
- dislikes;
- intención;
- temas;
- productos;
- source/confidence.

Comparar contra etiquetado humano.

No automatizar campañas todavía.

---

## Experimento 5 — Tool Gateway mínimo

Una API con 3 operaciones:

```text
read_customer
create_draft_message
send_message
```

- las primeras dos permitidas;
- `send_message` requiere approval token.

Guardar cada llamada en audit table.

Esto prueba la arquitectura más importante con muy poco código.

---

# 17. Arquitectura candidata de MatiOS/Agentis después de esta investigación

```text
                    ┌─────────────────────────┐
                    │       MatiOS Git         │
                    │ skills / employee packs │
                    │ policies / evals / docs │
                    └───────────┬─────────────┘
                                │ version/deploy
                                ▼
┌──────────────┐       ┌───────────────────────┐
│ WhatsApp/Web │──────▶│   Agentis Runtime     │
│ Slack/etc.   │       │ employee coordinator  │
└──────────────┘       └───────┬───────────────┘
                                │ runtime adapter
                       ┌────────┴────────┐
                       │                 │
                    Hermes        Claude/Codex
                       │                 │
                       └────────┬────────┘
                                │ MCP/tools
                                ▼
                     ┌───────────────────┐
                     │ Agentis Tool GW   │
                     │ policy / auth     │
                     │ approval / audit  │
                     └─────────┬─────────┘
                               │
             ┌─────────────────┼────────────────────┐
             ▼                 ▼                    ▼
            n8n            microservices          SaaS APIs
             │                 │                    │
             └─────────────────┼────────────────────┘
                               ▼
                          PostgreSQL
                  operational structured data
                               │
             ┌─────────────────┴──────────────────┐
             ▼                                    ▼
       Customer Graph                       Observability
 preferences/provenance              cost/jobs/evals/outcomes
```

### Source of truth hierarchy

1. **DB estructurada** → precios, promos, stock, clientes, permisos, estados.
2. **MatiOS Git** → procedimientos, skills, policies, arquitectura, evals.
3. **Document/RAG store** → conocimiento no estructurado.
4. **Conversation history** → evidencia/contexto, no fuente final de datos críticos.

---

# 18. Principios que quedan reforzados

1. **Automate execution, preserve human criterion.**
2. **Model is replaceable; employee definition is durable.**
3. **Permissions are infrastructure, not prose.**
4. **Install is not autonomy. Activation requires explicit scopes/approval.**
5. **Structured facts beat remembered prose for operational truth.**
6. **Every important action emits an audit event.**
7. **Start read-only, then reversible writes, then external/irreversible actions.**
8. **Test with real cases before optimizing models/cost.**
9. **Build one reusable layer that benefits many verticals.**
10. **Conversations are a data asset only when transformed with provenance and consent.**
11. **Content should feed product learning, not just reach.**
12. **Homelab hardware is earned by workload, not bought for aesthetics.**

---

# 19. Fuentes principales consultadas

## Erik Taveras / AutoDev / TaverasOS

- Erik Taveras GitHub profile: `https://github.com/eriktaveras`
- TalosFlow public page: `https://www.eriktaveras.com/talosflow`
- TaverasOS: `https://eriktaveras.com/`
- AutoDev resources: `https://comunidad.eriktaveras.com/resources/`
- Homelab guide: `https://comunidad.eriktaveras.com/resources/guia-monta-tu-homelab-con-lo-que-sea-que-tengas-a-mano/`
- Hermes guide: `https://comunidad.eriktaveras.com/resources/montar-agente-hermes-que-trabaje-sin-ti/`
- OpenClaw alternatives: `https://comunidad.eriktaveras.com/resources/guia-variantes-las-8-versiones-alternativas-de-openclaw/`
- Containers Day / IA aplicada: `https://comunidad.eriktaveras.com/resources/presentacion-ia-aplicada-negocios-containers-day-2026/`
- LLM/SLM/Tiny model ladder: `https://comunidad.eriktaveras.com/resources/llm-slm-y-tiny-los-3-tamanos-de-modelos-de-ia-y-cual-usar-en-cada-caso/`
- Zoom skill: `https://comunidad.eriktaveras.com/resources/skill-zoom-videollamadas-claude-code/`
- Instagram analysis skill: `https://comunidad.eriktaveras.com/resources/analiza-tus-reels-de-instagram-con-claude-comentarios-leads-e-ideas-de-contenido/`
- Video editing skill: `https://comunidad.eriktaveras.com/resources/edicion-de-video-con-ia-skill-claude-code/`

## Erik public repos inspected

- `eriktaveras/Client-Payment-Skill`
- `eriktaveras/facturas-opensource`
- `eriktaveras/django-saas-boilerplate`
- `eriktaveras/esp32-data-panel`
- `eriktaveras/claude-dashboard`
- `eriktaveras/modelnap`

## Primary platform documentation

- Hermes Agent: `https://github.com/NousResearch/hermes-agent`
- Hermes cron docs: `https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/cron.md`
- Hermes skill creation / blueprints: `https://github.com/NousResearch/hermes-agent/blob/main/website/docs/developer-guide/creating-skills.md`
- Hermes profile distributions: `https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profile-distributions.md`
- n8n native MCP: `https://n8n.io/mcp/`
- n8n MCP docs: `https://docs.n8n.io/connect/connect-to-n8n-mcp-server`
- n8n HITL tool calls: `https://docs.n8n.io/build/integrate-ai/ai-examples/human-in-the-loop-for-tools`

---

# 20. Próxima línea de investigación

Profundizar cuando corresponda en:

1. levantar Hermes localmente y medir comportamiento real, no solo docs;
2. compatibilidad práctica de Agents Skills entre Claude/Hermes/Codex;
3. schema definitivo de Employee Pack;
4. secretos/capability tokens y policy engine;
5. sandbox más apropiado para agentes con browser/code;
6. multi-tenant observability;
7. TalosFlow onboarding y UX real si conseguimos demo/beta;
8. benchmark de OpenClaw/ZeroClaw/NanoClaw/Hermes con el MISMO conjunto de tareas;
9. estrategia de monetización open-core inspirada en sus repos/skills, pero alineada con Agentis;
10. privacy/data governance del Customer Preference Graph para clientes LATAM y futuros mercados.

---

## Nota epistemológica

Diferenciar siempre:

- **fuente primaria técnica**: repos/docs oficiales;
- **afirmación del autor sobre su propio producto**: útil pero no auditoría independiente;
- **benchmark/claim comercial**: requiere reproducirse antes de tomarlo como hecho operacional;
- **patrón conceptual**: puede ser valioso aun si una cifra específica cambia.

Por eso las decisiones anteriores se apoyan principalmente en capacidades verificables de repos/documentación, y no en números de estrellas, usuarios o ahorros declarados.
