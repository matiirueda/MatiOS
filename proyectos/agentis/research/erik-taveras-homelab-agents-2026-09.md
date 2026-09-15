# Investigación: Erik Taveras — homelab, agentes y arquitectura aplicable a MatiOS/Agentis

> Estado: investigación en curso  
> Inicio: 2026-09-15  
> Objetivo: extraer patrones técnicos y de producto reutilizables para MatiOS, Agentis y la futura fábrica de empleados digitales, evitando copiar infraestructura por moda.

## Resumen ejecutivo

Erik Taveras opera un homelab con 6 nodos y 132 contenedores, pero el valor para nosotros no está en replicar el hardware sino en las decisiones de arquitectura: separar por criticidad/radio de daño, usar n8n como capa de orquestación, aislar agentes que ejecutan código, desacoplar el runtime del agente del modelo LLM, exponer capacidades a través de gateways/MCP con permisos restringidos y hacer observabilidad/backup antes de autonomía.

Su stack comercial confirma además una tesis muy cercana a Agentis: Python/Django/FastAPI + n8n + MCP + WhatsApp Business API + agentes conectados a sistemas reales. Su producto TalosFlow aplica IA a un CRM de WhatsApp para calificación de leads, transcripción de audios, pipeline y agenda.

## 1. Arquitectura del homelab

Fuente principal: guía de Erik publicada el 2026-09-08, "El mapa completo de mi homelab: 6 nodos, 132 contenedores y cómo se conectan".

### Principios extraídos

- El criterio de ubicación de un servicio no es solamente CPU/RAM: también importa el **radio de daño**.
- Cualquier cosa que ejecute código no escrito/controlado por el operador (agentes, servicios expuestos a webhooks, experimentos) debe vivir aislada del núcleo.
- Una sola máquina puede ser suficiente al principio. La expansión de hardware llega después de medir uso real.
- Erik propone sumar un segundo nodo recién cuando el principal se acerca a ~70% de RAM y mover primero las cargas autónomas.
- El NAS guarda; los nodos computan.
- Un backup que nunca fue restaurado de prueba no se considera backup confiable.

### Capas de red

- Público: Cloudflare Tunnel; evita abrir puertos del router.
- Privado: Tailscale para SSH y paneles administrativos.
- Datos: NFS/SMB hacia NAS; NAS no expuesto a Internet.
- Observabilidad: Beszel + Uptime Kuma + Glances.
- Orquestación: n8n recibe eventos/webhooks y decide qué ejecutar.

Patrón conceptual:

```text
Internet
  -> Cloudflare Tunnel
  -> apps públicas

Dispositivos/admin
  -> Tailscale
  -> SSH / paneles privados

Servicios
  -> n8n / workflows
  -> APIs / DB / canales

Nodos
  -> Beszel / Glances
  -> nodo de observabilidad

Datos persistentes
  -> NAS / snapshots / backup
```

## 2. n8n como sistema nervioso, no como cerebro

Erik describe n8n como el pegamento del sistema: recibe webhooks, dispara flujos, responde mensajes, publica, genera newsletters y registra acciones.

Esto refuerza la arquitectura que venimos definiendo en Agentis:

```text
Canales/eventos
   -> n8n (orquestación)
   -> agent/runtime cuando hace falta razonamiento
   -> servicios deterministas / APIs cuando no hace falta LLM
   -> DB estructurada
   -> audit log
```

Regla MatiOS derivada:

**No convertir n8n en un monolito inteligente.** Usarlo para coordinación, visibilidad de procesos y composición de herramientas. Mover lógica compleja/reutilizable a servicios versionados en código.

## 3. Hermes como runtime de empleado autónomo

Erik recomienda Hermes Agent (Nous Research) para tareas que deben continuar sin una persona presente. La distinción que usa es útil:

- Claude/Claude Code: trabaja **con** la persona.
- Hermes: trabaja **por** la persona en tareas programadas o persistentes.

Hermes no es el modelo. Es un runtime que agrega:

- memoria persistente;
- skills;
- herramientas;
- cron jobs;
- mensajería;
- subagentes;
- integración MCP;
- distintos backends de ejecución/sandbox.

El LLM puede cambiar sin reconstruir la identidad, herramientas y memoria del empleado.

### Implicación para MatiOS

Separar explícitamente:

```text
Employee identity / policy
Memory / knowledge
Skills / procedures
Tools / permissions
Runtime
Model provider
```

El modelo pasa a ser una dependencia intercambiable, no el producto.

## 4. Hallazgos adicionales del Hermes Agent oficial

Investigación sobre NousResearch/hermes-agent realizada 2026-09-15.

### Skills como memoria procedural

Hermes usa skills compatibles con el estándar agentskills.io y puede cargar habilidades on-demand. Las skills pueden vivir en directorios externos además de `~/.hermes/skills/`.

**Idea para MatiOS:** mantener la fuente de verdad de skills en Git/MatiOS y montar/sincronizar ese directorio con runtimes concretos (Hermes, Claude Code, Codex u otros), evitando que cada empleado tenga una biblioteca aislada.

### Cron jobs con skills

Hermes puede ejecutar tareas recurrentes cargando una o varias skills antes del prompt. También soporta `workdir` para arrancar una tarea dentro de un repo y cargar el contexto local (`AGENTS.md`, `CLAUDE.md`, etc.).

Esto permite un patrón interesante para nuestra fábrica:

```text
Skill versionada + schedule + repo/workdir + modelo seleccionado + canal de salida
= employee job reproducible
```

### Blueprints / automatizaciones distribuibles

Hermes ya contempla skills que declaran un `blueprint` de automatización. La instalación de la skill no habilita silenciosamente el cron: aparece como sugerencia y requiere aceptación.

Esto es muy relevante para Agentis porque apunta a un producto distribuible como paquete:

```text
skill + configuración + workflow + schedule sugerido + permisos
```

En el futuro podría existir un "Agentis Employee Pack" instalable por vertical, por ejemplo:

- recepcionista de cancha;
- ventas/comercial;
- investigador de mercado;
- control de stock;
- seguimiento de presupuestos;
- content researcher.

### Delegación y subagentes

Hermes ejecuta subagentes en sesiones aisladas y solo devuelve el resumen final al padre, reduciendo contaminación del contexto. Para tareas durables recomienda cron o procesos persistentes, no delegación efímera.

Patrón para MatiOS:

- orquestador decide el objetivo;
- workers reciben contexto mínimo explícito;
- cada worker devuelve artefacto + resumen + evidencia;
- no compartir contexto completo por defecto.

### Seguridad del scheduler

El runtime oficial incorpora límites como sesiones cron con tiempo máximo, locks para evitar ejecuciones duplicadas y restricciones para que un cron no cree recursivamente otros cron salvo opt-in.

Lección: la autonomía necesita límites de infraestructura, no solo prompts.

## 5. Tool/API Gateway: permisos reales, no instrucciones

Uno de los principios más importantes de la guía de Erik sobre Hermes:

> Si el límite existe solamente en el prompt, es una sugerencia. El límite real debe vivir en el servidor.

Ejemplo: un agente de email podría tener permiso técnico para leer/listar/borradores pero no enviar, borrar o mover mensajes.

Arquitectura recomendada para Agentis:

```text
Agent / employee
    -> Tool client / MCP
    -> Agentis Tool Gateway
        -> auth
        -> allowlist de operaciones
        -> scope por tenant/employee
        -> rate limits
        -> validation
        -> human approval cuando corresponda
        -> audit log
    -> n8n / microservices / SaaS APIs / DB
```

Evento de auditoría deseado:

```text
agent_id
customer_id / tenant_id
tool
operation
input_hash / sanitized_input
authorization_source
approval_id (si aplica)
result
latency
cost
model
workflow/version
timestamp
```

Esto debe quedar como principio central de Agentis.

## 6. Separación por radio de daño

El patrón de Erik es trasladable aunque inicialmente corramos todo en una sola PC.

No hace falta comprar varios equipos: podemos crear fronteras mediante Docker networks, usuarios, contenedores, VMs y credenciales diferentes.

### Propuesta MatiOS Lab v0

```text
CORE
- PostgreSQL
- n8n
- Tool Gateway
- audit log
- observabilidad
- repos/configuración

SANDBOX EMPLOYEES
- Hermes / runtimes experimentales
- browser/code execution
- credenciales limitadas

DEV EMPLOYEES
- Claude Code
- Codex
- CI/tests/security review

KNOWLEDGE
- MatiOS Git
- docs/markdown/yaml
- DB estructurada cuando aplique
- vector/search layer solo cuando genere valor
```

Principio: **misma máquina física no significa mismo dominio de confianza**.

## 7. Observabilidad

Stack observado en Erik:

- Beszel: métricas centralizadas de nodos;
- Uptime Kuma: disponibilidad HTTP;
- Glances: métricas que alimentan su HUD;
- Dozzle: logs;
- Diun: alerta de nuevas imágenes Docker.

Para MatiOS/Agentis no necesitamos copiar exactamente estas herramientas, pero sí las capacidades:

1. uptime;
2. CPU/RAM/disco;
3. logs consultables;
4. ejecuciones de agentes/workflows;
5. token/cost accounting;
6. fallas y retries;
7. estado de colas;
8. latencia;
9. approvals pendientes;
10. versionado de workflow/skill/model.

### MatiOS Control Center

La pantalla del reel no es un producto indispensable: parece ser un HUD propio leyendo Glances y otras métricas. Podemos construir más adelante un Control Center centrado no solo en infraestructura sino en **empleados digitales**.

Ejemplo:

```text
Employees online        8/9
Jobs today              247
Human approvals         3
Success rate            98.1%
LLM cost today          $X
n8n executions          Y
Agent incidents         Z
Leads processed         ...
Content pieces          ...
```

Ese dashboard puede terminar siendo parte vendible de Agentis.

## 8. FreshRSS + agente = radar reusable

Erik usa FreshRSS con fuentes de IA/seguridad/hardware que un agente resume diariamente.

Aplicación directa:

```text
Sources/RSS/web
 -> ingestion
 -> dedup
 -> classifier
 -> research agent
 -> evidence/ranking
 -> MatiOS knowledge
 -> opportunities
 -> Content Factory / Agentis backlog
```

Radares candidatos:

- AI/agent ecosystem;
- repos y skills;
- demanda freelance;
- competidores Agentis;
- oportunidades de producto;
- tech/news para Content Factory;
- cambios de APIs de Meta/WhatsApp/n8n;
- seguridad de agentes.

## 9. TalosFlow como caso de estudio directo

El perfil público de Erik describe TalosFlow como CRM de WhatsApp con IA que:

- usa la API oficial de Meta;
- califica leads;
- transcribe audios;
- gestiona funnels/pipelines;
- agenda citas;
- combina Django + n8n + OpenAI + WhatsApp Business API.

También declara trabajo activo en un "WhatsApp AI Agent" con n8n + MCP + Claude.

Esto lo convierte en competidor/referencia útil para Agentis. Debemos analizar no solo features sino:

- onboarding;
- pricing;
- multi-tenant;
- límites y permisos;
- handoff humano;
- trazabilidad;
- métricas comerciales;
- data model;
- integración con CRM externo vs CRM propio;
- canales adicionales;
- estrategia de verticalización.

## 10. OpenClaw y alternativas: no casarnos con un runtime

Erik publicó una comparación entre variantes de OpenClaw incluyendo Nanobot, ZeroClaw, Hermes, PicoClaw, NanoClaw, IronClaw, Moltworker y Moltis.

La conclusión que nos interesa no es "Hermes gana", sino mantener un contrato común para que el runtime sea sustituible.

### Criterios de evaluación para MatiOS

- seguridad / sandbox;
- permisos de herramientas;
- skills standard;
- MCP;
- cron/durabilidad;
- memoria;
- subagentes;
- costo de runtime;
- multi-channel;
- observabilidad;
- facilidad de despliegue en clientes;
- consumo RAM/CPU;
- soporte de modelos intercambiables;
- capacidad de correr local/VPS/serverless;
- mantenimiento/comunidad/licencia.

## 11. Insight de producto: Employee Pack

El descubrimiento más prometedor de esta investigación es pensar los empleados no como un prompt, sino como un paquete versionado y auditable.

Borrador conceptual:

```text
Employee Pack
├── manifest.yaml
├── role.md
├── policies.yaml
├── skills/
├── tools.yaml
├── workflows/
├── schemas/
├── knowledge/
├── tests/
├── evals/
├── approvals.yaml
├── schedules.yaml
└── observability.yaml
```

El pack define **qué sabe, qué puede hacer, con qué herramientas, bajo qué condiciones, cómo se evalúa y cómo se audita**.

Runtime adapters podrían permitir correr el mismo empleado sobre Hermes, Claude/Codex u otro agente.

Esto se alinea con la estrategia previa de MatiOS: skills reutilizables, dos empleados de desarrollo con perspectivas diferentes, n8n para prototipar y migrar lógica a código cuando madure.

## 12. Recomendación de experimento inicial

Antes de comprar hardware:

### MatiOS Research Employee v0

Objetivo: investigar diariamente herramientas/repos/agentes relevantes y devolver únicamente hallazgos con valor.

Pipeline:

```text
Feeds + web + GitHub
 -> deterministic collection
 -> dedup
 -> employee/research skill
 -> source/evidence check
 -> compare against MatiOS stack
 -> score impact
 -> human review
 -> accepted findings -> MatiOS
```

Salida mínima por hallazgo:

- qué es;
- problema que resuelve;
- por qué nos importa;
- alternativa actual nuestra;
- costo/lock-in;
- seguridad;
- madurez;
- decisión: ignore / watch / test / adopt;
- fuentes;
- fecha de revisión.

Este experimento alimenta simultáneamente Agentis, Content Factory, radar freelance y arquitectura de MatiOS.

## 13. Principios que quedan adoptados/propuestos

1. **n8n es orquestador, no cerebro ni fuente de verdad.**
2. **Modelo LLM intercambiable.** Identidad, skills, memoria y permisos viven fuera del modelo.
3. **Los permisos reales viven en infraestructura/gateway, no en el prompt.**
4. **Agentes autónomos aislados por radio de daño.**
5. **Observabilidad + backup + restore test antes de autonomía.**
6. **Git/MatiOS como fuente de verdad de skills/config/arquitectura.**
7. **Credenciales mínimas por empleado y por tenant.**
8. **Human-in-the-loop para acciones irreversibles o de alto impacto.**
9. **No comprar hardware hasta que una carga real lo justifique.**
10. **Empaquetar empleados como artefactos versionados/evaluables, no como prompts sueltos.**

## 14. Investigación pendiente

Para la siguiente ronda profundizar en:

- repos públicos de Erik y componentes realmente reutilizables;
- arquitectura, pricing y UX de TalosFlow;
- contenidos de Erik sobre MCP nativo de n8n;
- presentación "IA Aplicada a Negocios" y la separación orquestador/agente/modelo;
- skills públicas de Erik y cuáles merecen importar/adaptar;
- Hermes vs OpenClaw vs ZeroClaw vs NanoClaw para nuestros casos;
- agentes con perfiles/credenciales separados;
- patrón de seguridad de MCP/tool gateway;
- compatibilidad real de skills entre Hermes/Claude Code/Codex;
- forma de sincronizar MatiOS como source of truth con runtimes;
- estrategia de pruebas/evals para Employee Packs;
- arquitectura de observabilidad y costos por empleado/cliente.

## Fuentes iniciales

- Erik Taveras — AutoDev Community, "El mapa completo de mi homelab: 6 nodos, 132 contenedores y cómo se conectan", 2026-09-08.
- Erik Taveras — AutoDev Community, "Monta un agente Hermes que trabaje sin ti: el montaje correcto", 2026-08-31.
- Erik Taveras — AutoDev Community, "Guía VARIANTES - Las 8 versiones alternativas de OpenClaw", 2026-04-28.
- Erik Taveras — GitHub profile / README, consultado 2026-09-15.
- NousResearch/hermes-agent — README, AGENTS.md, docs de cron, skills y delegation, consultado 2026-09-15.
- n8n official docs — MCP server, consultado 2026-09-15.

## Nota de cautela

Algunas cifras o claims comerciales/técnicos de terceros provienen de sus propios perfiles/guías y deben verificarse contra fuentes primarias antes de convertirlos en decisiones de arquitectura o marketing de Agentis.
