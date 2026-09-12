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

`Obsidian/MatiOS → Graphify/indexación → retrieval de subgrafo → LLM → respuesta con fuentes`

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
└── Token / retrieval metrics
```

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

## Relación con MarkItDown

Para documentos externos:

`PDF/DOCX/PPTX/etc. → MarkItDown → Markdown normalizado → ingestión Graphify`

Evitar enviar documentos completos al LLM repetidamente.

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
- feedback de Mati sobre utilidad de la respuesta.

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
- consulta por CLI/agente;
- fuentes visibles;
- medir tokens/latencia/calidad.

### MVP 1
Si MVP 0 demuestra valor:
- pequeña API de knowledge retrieval;
- chat interno;
- visualización de subgrafo relevante;
- search/filter;
- ingest status;
- health checks.

### MVP 2
Sólo si Mati lo usa realmente:
- UI propia integrada a Agentis/MatiOS;
- communities;
- sugerencias de conexiones;
- detección de duplicados;
- source viewer;
- historial de preguntas;
- routing de modelos;
- Obsidian deep links;
- métricas de costo/calidad.

## Reutilización antes de construcción

Antes de escribir UI/backend propio comparar/reutilizar:

1. `Graphify-Labs/graphify` / Graphify principal.
2. `thanhauco/llm-obsidian-graphify` como referencia de app completa graph + chat.
3. `Nodesify/nodesify-graphify` por wiki/vault export, Canvas e incremental updates.
4. `eric-orozco/graphify-obsidian-claude_code-guide` como SOP de setup/mantenimiento.

Regla Agentis: buscar 60–80% resuelto antes de construir el resto.

## Hipótesis a validar

La UI tipo KAI Vault sólo vale la pena si mejora alguna de estas variables frente a Obsidian + Graphify directo:
- menor tiempo para encontrar contexto;
- menos tokens por tarea;
- mejor precisión/recall;
- más reutilización de conocimiento;
- menos decisiones repetidas;
- mejor onboarding de agentes;
- mejor experiencia para Mati;
- mayor detección de conexiones no obvias.

Si no mejora métricas o uso real, mantener Obsidian + Graphify sin otra app.

## Principio

> Obsidian guarda el conocimiento; Graphify lo conecta; los agentes lo consultan; una UI propia sólo se construye si hace ese ciclo claramente mejor.

Última actualización: 2026-09-11.
