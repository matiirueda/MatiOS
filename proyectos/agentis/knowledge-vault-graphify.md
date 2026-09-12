# Agentis / MatiOS — Knowledge Vault + Graphify

## Objetivo

Evaluar y formalizar una capa de conocimiento conversacional que combine Obsidian/MatiOS con un grafo consultable por IA. La referencia surgió a partir de una app tipo “KAI Vault” que permite visualizar, consultar y activar conocimiento desde una interfaz propia.

La idea no es copiar una UI por copiarla. El objetivo es resolver un problema real: que Mati y los agentes puedan preguntar sobre proyectos, decisiones, aprendizaje, facultad y documentación sin releer el vault completo ni perder relaciones entre notas.

## Conclusión de investigación

Sí existen repos/templates públicos que ya implementan buena parte de esta idea, por lo que no conviene construir desde cero.

### Referencia 1 — `thanhauco/llm-obsidian-graphify`

Repo público funcional end-to-end que combina:
- ingesta de Markdown estilo Obsidian (`[[wikilinks]]`, tags, frontmatter);
- ingesta de código;
- grafo persistente de nodos y relaciones;
- retrieval híbrido lexical + semántico;
- expansión por relaciones del grafo;
- presupuesto explícito de contexto/tokens;
- respuestas grounded con fuentes;
- watch mode para reingesta automática;
- backend Node/TypeScript;
- almacenamiento JSON o SQLite;
- UI React/Vite con grafo + chat + ingestión;
- proveedores LLM intercambiables (local/Ollama, Claude o fallback).

Es la referencia más cercana a la app mostrada y puede servir como starter/benchmark para un MatiOS Knowledge Vault.

### Referencia 2 — Graphify + Obsidian

El ecosistema Graphify ya puede exportar/generar estructuras compatibles con Obsidian y existe documentación comunitaria para mantener un grafo incremental sincronizado con repos y vaults.

Repos/guías relevantes:
- `eric-orozco/graphify-obsidian-claude_code-guide`
- `Nodesify/nodesify-graphify`

Nodesify/Graphify puede producir un wiki navegable y un vault Obsidian con notas por nodo, frontmatter, wikilinks y Canvas. También soporta actualización incremental y una capa semántica local opcional.

## Decisión para MatiOS

**Sí vale la pena construir una experiencia parecida, pero no ahora como producto desde cero.**

Primero reutilizar Graphify + Obsidian + repos existentes. Construir una UI propia sólo cuando tengamos claro qué fricciones reales quedan.

Secuencia recomendada:

`Obsidian/MatiOS → Graphify/indexación → retrieval de subgrafo → LLM Router → respuesta con fuentes`

Más adelante:

`MatiOS Knowledge Vault UI → búsqueda/chat/grafo/salud del vault → Graphify/Knowledge API → Obsidian + repos`

## Qué problema resuelve

Sin esta capa, cada agente tiende a:
- buscar archivos por texto;
- abrir muchos documentos;
- consumir contexto innecesario;
- reconstruir relaciones en cada sesión;
- olvidar decisiones y conexiones transversales.

Con un grafo persistente:
- el conocimiento se ingesta una vez;
- cada consulta recupera sólo el subgrafo relevante;
- las relaciones entre conceptos/proyectos/notas se vuelven consultables;
- se pueden devolver fuentes concretas;
- se reduce contexto inútil;
- el sistema puede detectar notas aisladas, duplicadas o poco conectadas.

No asumir números de ahorro de tokens de terceros como garantía propia. Agentis/MatiOS debe medir reducción real de tokens, recall, precisión y tiempo de respuesta sobre su propio corpus.

## Arquitectura recomendada

```text
Obsidian MatiOS
+ repos GitHub
+ docs / PDFs convertidos a Markdown
        ↓
Ingestion Layer
        ↓
Graphify / Knowledge Graph
        ↓
Knowledge Retrieval API
        ↓
Context Router
        ↓
LLM Router
        ↓
Local model o Cloud model según política
        ↓
respuesta + fuentes + subgrafo usado
```

La UI es una capa aparte:

```text
Knowledge Vault UI
├── Ask / Chat
├── Graph Explorer
├── Search
├── Communities / clusters
├── Source viewer
├── Vault health
├── Ingest / sync status
├── Local / Hybrid / Cloud mode
└── Token / cost / retrieval metrics
```

## Estrategia Local / Hybrid / Cloud

Este caso es un candidato fuerte para usar modelos locales porque muchas tareas del Knowledge Vault no necesitan un modelo frontier.

### Local mode

Objetivo: máxima privacidad y costo marginal bajo.

Posibles tareas locales:
- clasificación de notas;
- metadata/tagging sugerido;
- embeddings;
- clustering/communities;
- deduplicación semántica;
- resúmenes cortos;
- extracción de entidades/relaciones;
- consultas simples sobre subgrafos recuperados;
- health checks del vault.

Stack candidato:

`Obsidian + Graphify + embeddings locales + Ollama/model server local + modelo local`

Todo el pipeline puede correr en la PC sin enviar el corpus a un proveedor externo.

### Hybrid mode — recomendado para MatiOS

Usar local por defecto y escalar a cloud sólo cuando aporte una mejora real.

Patrón:

`consulta → retrieval/subgrafo → router → local first → confidence/eval → cloud fallback si hace falta`

Criterios para escalar a modelo externo:
- baja confianza;
- ambigüedad alta;
- síntesis entre muchas fuentes;
- tarea estratégica compleja;
- razonamiento importante;
- respuesta local insuficiente según eval/feedback;
- necesidad de un modelo multimodal o especializado.

Cloud candidates: Claude, GPT, Gemini u otros proveedores según Model Router.

### Cloud mode

Usar cuando se priorice máxima capacidad o cuando el hardware local no alcance. No debe ser el default por comodidad si una tarea simple puede resolverse localmente.

## Model Router aplicado al Knowledge Vault

El Knowledge Vault debe conectarse al Agentis Model Router.

No seleccionar modelo por marca fija. Seleccionar capacidad según:

`task_type + complexity + privacy_class + latency_need + quality_threshold + context_size + budget → model/provider`

Ejemplo:

```text
clasificar nota             → local small model
embeddings                  → local embedding model
resumir 1 nota              → local model
consulta factual simple     → local model
cruzar proyecto + decisiones→ local medium → cloud fallback
estrategia compleja         → cloud frontier
imagen/documento visual     → modelo multimodal especializado
```

Medir al menos:
- model/provider;
- local vs cloud;
- latency;
- tokens/context size;
- costo;
- retrieval size;
- confidence/eval score;
- fallback reason;
- feedback de Mati;
- respuesta con fuentes;
- error/hallucination detectada.

Objetivo futuro: poder afirmar con evidencia qué porcentaje de consultas del Knowledge Vault se resuelve localmente con calidad suficiente.

## Privacidad y clasificación de datos

El router no debe decidir sólo por costo/calidad. También por política de privacidad.

Clases sugeridas:

`local-only`  
Nunca enviar contenido a modelos externos.

`cloud-allowed`  
Puede procesarse con proveedores externos autorizados.

`cloud-with-redaction`  
Antes de enviar, eliminar/anonimizar campos sensibles.

`restricted`  
Sólo herramientas explícitamente autorizadas y con HITL cuando corresponda.

La clasificación puede aplicarse por carpeta, nota, proyecto, fuente o tipo de dato.

Principio:

> El contexto sensible no sale de la máquina sólo porque el modelo cloud sea mejor.

## Relación con Obsidian

Obsidian sigue siendo el editor humano y source of truth del conocimiento transversal.

Graphify no debe reemplazar las notas. Debe actuar como índice/grafo derivado y regenerable.

Principio:

`Markdown canónico → graph/index derivado`

Nunca hacer que el grafo sea la única copia de conocimiento importante.

## Relación con Graphify técnico

Hasta ahora MatiOS definía Graphify principalmente como comprensión técnica de repos. La investigación muestra que puede ampliarse a una función más general de Knowledge Graph sobre:
- código;
- documentación;
- notas;
- PDFs/documentos previamente normalizados;
- decisiones;
- proyectos.

Separar lógicamente dos scopes aunque compartan engine:

`Project Graph = arquitectura/código`  
`Knowledge Graph = conocimiento transversal/persona/negocio/estudio`

Luego permitir consultas que crucen ambos cuando sea útil.

Ejemplo objetivo:

“¿Qué aprendimos sobre seguimiento de leads, dónde lo aplicamos en Agentis y qué workflow/código lo implementa?”

El sistema debería poder recorrer:

`Knowledge note → Decision → Agentis component → workflow/code → métricas`

sin cargar todo el vault y todo el repo al modelo.

## Relación con MarkItDown

Para documentos externos:

`PDF/DOCX/PPTX/etc. → MarkItDown → Markdown normalizado → ingestión Graphify`

Evitar enviar documentos completos al LLM repetidamente.

Si el documento es escaneado o contiene información visual necesaria, usar OCR/visión sólo cuando corresponda.

## Knowledge Health / mantenimiento

Una parte especialmente valiosa de una app propia sería medir la salud del vault, no sólo mostrar un grafo bonito.

Métricas candidatas:
- notas sin links;
- nodos aislados;
- notas casi duplicadas;
- links rotos;
- conceptos con múltiples fuentes contradictorias;
- notas stale;
- clusters sin MOC;
- densidad/conectividad por área;
- knowledge coverage por proyecto;
- consultas sin buena evidencia;
- ratio respuesta con fuente;
- tokens recuperados vs corpus completo;
- feedback de Mati sobre utilidad de la respuesta;
- porcentaje resuelto localmente;
- fallback local → cloud;
- costo por respuesta útil.

El objetivo no es “tener un grafo lindo”, sino mejorar recuperación, consistencia, trazabilidad y calidad de respuesta.

## Agentes y permisos

Fases:

1. Read-only: agentes consultan vault/grafo.
2. Suggest mode: agente propone nuevos links, tags, merges o notas.
3. HITL write: Mati aprueba cambios de conocimiento.
4. Auto-write limitado sólo para tareas de bajo riesgo y reglas claras.

No permitir que un LLM reescriba conocimiento canónico sin trazabilidad.

## MVP recomendado

No construir todavía un KAI Vault completo.

### MVP 0
- Obsidian MatiOS real;
- Graphify sobre una carpeta seleccionada del vault + Agentis repo;
- embeddings/modelo local cuando sea viable;
- consulta por CLI/agente;
- fuentes visibles;
- medir tokens/latencia/calidad/local-vs-cloud.

### MVP 0.5 — experimento de routing

Crear un set de ~20 preguntas reales de Mati y comparar:
- local only;
- cloud only;
- hybrid local-first con fallback.

Medir:
- calidad percibida;
- groundedness/fuentes;
- latency;
- costo;
- cantidad de contexto enviado;
- fallback rate;
- privacidad/exposición de datos.

Elegir routing con evidencia, no intuición.

### MVP 1
Si MVP 0 demuestra valor:
- pequeña API de knowledge retrieval;
- chat interno;
- visualización de subgrafo relevante;
- search/filter;
- ingest status;
- health checks;
- selector/indicador Local-Hybrid-Cloud.

### MVP 2
Sólo si Mati lo usa realmente:
- UI propia integrada a Agentis/MatiOS;
- communities;
- sugerencias de conexiones;
- detección de duplicados;
- source viewer;
- historial de preguntas;
- routing de modelos;
- políticas de privacidad;
- Obsidian deep links;
- métricas de costo/calidad.

## Reutilización antes de construcción

Antes de escribir UI/backend propio comparar/reutilizar:

1. `Graphify-Labs/graphify` / Graphify principal.
2. `thanhauco/llm-obsidian-graphify` como referencia de app completa graph + chat.
3. `Nodesify/nodesify-graphify` por wiki/vault export, Canvas e incremental updates.
4. `eric-orozco/graphify-obsidian-claude_code-guide` como SOP de setup/mantenimiento.
5. Ollama o serving local equivalente para experimentar antes de construir infraestructura propia.

Regla Agentis: buscar 60–80% resuelto antes de construir el resto.

## Comparativa Memanto vs Graphify vs LightRAG — decisión 2026-09-12

No son equivalentes y no conviene elegir uno como reemplazo universal de los otros.

### Memanto — memoria operativa de agentes

Rol recomendado: **episodic/semantic agent memory**.

Fortalezas:
- memoria persistente entre sesiones;
- recall semántico y temporal;
- tipos de memoria como decisiones, preferencias, objetivos y errores;
- confidence/provenance;
- detección de conflictos;
- expiración/corrección de recuerdos;
- integración directa con Claude Code, Codex, Cursor y otros agentes;
- `MEMORY.md` como briefing compacto para evitar releer historial completo;
- puede correr on-prem y tiene mecanismos de export/migración.

No debe ser la fuente canónica de documentos/proyectos. Su función es recordar lo que los agentes aprendieron o decidieron y recuperar sólo lo necesario para continuidad operativa.

Ejemplos:
- “este bug ya apareció y se resolvió así”;
- “Mati aprobó esta convención”;
- “esta decisión reemplazó la anterior”;
- “el último intento falló por X”;
- “la próxima tarea pendiente es Y”.

### Graphify — estructura y relaciones explícitas del corpus

Rol recomendado: **project/knowledge graph derivado**.

Fortalezas:
- parseo determinístico de código mediante AST;
- ingesta de docs, SQL, configs, PDFs y otros artefactos;
- relaciones explicables;
- graph query/path/explain;
- clustering/community structure;
- actualización incremental;
- export a Obsidian/wiki/GraphML/Neo4j;
- útil para navegar arquitectura y conectar conceptos sin releer todos los archivos.

Graphify es especialmente fuerte en “cómo se conecta esto con aquello”, arquitectura, dependencias, relaciones de proyecto y visualización/consulta de la estructura del conocimiento.

### LightRAG — retrieval/generation sobre un corpus grande

Rol recomendado: **document RAG / knowledge retrieval engine cuando el corpus lo justifique**.

Fortalezas:
- combina knowledge graph + vector embeddings;
- modos local/global/hybrid/naive/mix;
- retrieval orientado tanto a preguntas puntuales como a síntesis cross-document;
- múltiples estrategias de chunking;
- configuración distinta de modelos por rol (extract/query/keywords/VLM);
- soporte de despliegue local y backends de almacenamiento escalables;
- puede devolver referencias/contexto recuperado y conectarse a eval/tracing.

Costo/contra principal: es una capa extra de ingesta, extracción y storage que no deberíamos introducir hasta demostrar que Graphify + búsqueda directa no alcanza.

### Obsidian — source of truth humano

Rol: **conocimiento canónico editable por Mati**.

No reemplazarlo con Memanto, Graphify ni LightRAG. Esos sistemas son índices/memorias derivadas y regenerables.

### Arquitectura objetivo combinada

```text
Obsidian / GitHub / documentos
        ↓
MarkItDown + normalización
        ↓
fuente canónica Markdown/código
        ├────────────→ Graphify → relaciones/project graph
        ├────────────→ LightRAG (opcional) → document retrieval
        └────────────→ agentes trabajan
                            ↓
                    Memanto → memoria operativa
                            ↓
consulta nueva
        ↓
Context Router
        ↓
1) Memanto recall: qué aprendimos/decidimos antes
2) Graphify: qué archivos/nodos/relaciones son relevantes
3) LightRAG sólo si la pregunta requiere corpus documental amplio o cross-document retrieval
        ↓
Context Budgeter / dedupe
        ↓
LLM Router local/cloud
        ↓
respuesta con fuentes
```

### Regla anti-duplicación

No indexar y mandar al modelo tres copias del mismo conocimiento.

- **Obsidian/GitHub**: verdad canónica.
- **Memanto**: recuerdos compactos y temporales derivados de trabajo real.
- **Graphify**: relaciones/estructura derivadas del corpus.
- **LightRAG**: chunks/entities/embeddings derivados sólo donde aporte retrieval adicional.

El Context Router debe fusionar, deduplicar y limitar el contexto final.

### Estrategia de costo/tokens

El ahorro no viene simplemente de “tener memoria”, sino de **seleccionar mejor contexto**.

Objetivo por consulta:

`query → retrieve cheap → rank → dedupe → context budget → infer`

Orden de costo recomendado:
1. lookup/cache/metadata determinístico;
2. Memanto recall compacto;
3. Graphify query/subgraph;
4. búsqueda lexical/semántica local;
5. LightRAG si hace falta retrieval más profundo;
6. modelo local para síntesis simple;
7. cloud frontier sólo si la complejidad/calidad lo exige.

Medir:
- tokens recuperados;
- tokens finalmente enviados al LLM;
- número de fuentes/recuerdos candidatos vs usados;
- duplicación de contexto;
- recall/precision;
- groundedness;
- latency;
- costo total;
- fallback rate;
- correcciones humanas;
- costo por respuesta útil.

### Decisión de implementación

**No instalar las tres capas completas el primer día.**

Orden recomendado:

1. Obsidian + GitHub como canon.
2. Graphify para Project/Knowledge Graph y navegación.
3. Memanto como experimento para continuidad de Claude/Codex y memoria operativa.
4. Crear benchmark propio con preguntas reales y medir si Memanto reduce relectura/tokens y mejora continuidad.
5. Introducir LightRAG sólo si aparecen consultas documentales donde Graphify + búsqueda normal tengan recall insuficiente.
6. Una UI Knowledge Vault propia consume estas capacidades detrás de adapters; nunca debe quedar acoplada a un único proveedor.

Hipótesis inicial: **Graphify + Memanto son complementarios y tienen alta probabilidad de convivir. LightRAG es opcional y debe ganarse su lugar con métricas.**

### Experimento recomendado

Dataset de 30–50 preguntas/tareas reales repartidas entre:
- continuidad de proyecto y decisiones pasadas;
- arquitectura/código;
- preguntas sobre notas/documentos;
- preguntas cross-document;
- cambios temporales (“qué habíamos decidido antes y qué cambió”).

Comparar:
- búsqueda/Markdown directo;
- Graphify;
- Memanto;
- Graphify + Memanto;
- Graphify + LightRAG;
- Graphify + Memanto + LightRAG.

No medir sólo exactitud. Registrar contexto enviado, costo, latencia, groundedness y cantidad de intervención humana.

## Hipótesis a validar

La UI tipo KAI Vault sólo vale la pena si mejora alguna de estas variables frente a Obsidian + Graphify directo:
- menor tiempo para encontrar contexto;
- menos tokens por tarea;
- mejor precisión/recall;
- más reutilización de conocimiento;
- menos decisiones repetidas;
- mejor onboarding de agentes;
- mejor experiencia para Mati;
- mayor detección de conexiones no obvias;
- mayor privacidad al resolver tareas localmente;
- menor costo por respuesta útil.

Si no mejora métricas o uso real, mantener Obsidian + Graphify sin otra app.

## Principios

> Obsidian guarda el conocimiento; Graphify lo conecta; los agentes lo consultan; una UI propia sólo se construye si hace ese ciclo claramente mejor.

> Local primero cuando la calidad alcance; cloud cuando aporte capacidad real; privacidad siempre forma parte del routing.

> No optimizar por costo por llamada: optimizar por costo, calidad y privacidad del resultado útil.

> Memoria, grafo y RAG no son sinónimos: cada capa debe justificar el contexto y costo que agrega.

Última actualización: 2026-09-12.
