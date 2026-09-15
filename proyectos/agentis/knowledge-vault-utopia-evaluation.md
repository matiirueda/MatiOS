# Agentis / MatiOS — Evaluación de Utopia

## Repo investigado

`deeplethe/utopia`

Utopia se presenta como un sistema open-source de conocimiento empresarial con ontología, grafo bitemporal, RAG, búsqueda híbrida, MCP, permisos y auditoría. No es simplemente un visualizador de nodos ni un vector store.

## Qué aporta distinto

### 1. Grafo bitemporal

Cada hecho mantiene dos ejes de tiempo:
- cuándo era verdadero en el mundo;
- cuándo el sistema pasó a creerlo/conocerlo.

Corregir un hecho no pisa el anterior: cierra su vigencia y enlaza la nueva versión. Esto permite reconstruir cómo cambió el conocimiento y qué se sabía al momento de una decisión.

Para MatiOS esto es relevante para:
- decisiones que cambian en el tiempo;
- reglas de Agentis versionadas;
- precios/promos/ofertas históricas;
- estrategias reemplazadas;
- configuraciones de clientes;
- memoria operacional con trazabilidad.

### 2. Ontología explícita

Utopia no sólo enlaza nodos: define clases, propiedades, dominios/rangos, cardinalidades y otras reglas. Las extracciones y relaciones deben respetar esa ontología.

Esto permite detectar conflictos estructurales y hacer razonamiento más controlado que un grafo libre.

### 3. Knowledge governance

Incluye:
- entity resolution;
- detección de duplicados;
- cola de revisión para casos dudosos;
- merges reversibles;
- conflictos temporales y de cardinalidad;
- decision ledger append-only;
- auditoría de quién cambió qué y cuándo.

Esto encaja con la filosofía Agentis de human-in-the-loop y trazabilidad.

### 4. Search + RAG + graph traversal

Combina:
- full-text search;
- pgvector;
- RRF para fusionar resultados;
- traversal del grafo;
- chat con citas inline;
- herramientas read-only por MCP.

Puede usar endpoints OpenAI-compatible y modelos locales como Ollama/vLLM, por lo que puede correr local/air-gapped.

### 5. Ingesta amplia

Soporta documentos y fuentes como PDF, DOCX, PPTX, XLSX/CSV, Markdown, HTML, web, RSS, GitHub, Jira, Notion, WebDAV y S3-compatible storage.

Para MatiOS no elimina necesariamente la utilidad de MarkItDown, pero sí demuestra que una futura Knowledge Layer puede normalizar e ingerir múltiples fuentes sin depender de pasar todo crudo al LLM.

### 6. Ontology2SQL / datos estructurados

Puede montar bases de datos y mapear tablas a la ontología para que el agente consulte datos estructurados junto con documentos/grafo.

Esto es especialmente interesante para Agentis Business Operator:

`CRM + Agentis DB + knowledge graph + documentos → agente consulta todo bajo una semántica común`.

## Comparación con nuestro stack

Utopia se solapa parcialmente con varias piezas, pero no es equivalente a ninguna de forma aislada.

### vs Graphify

Graphify es más liviano y orientado a comprender estructura/relaciones de repos y conocimiento derivado.

Utopia agrega:
- ontología formal;
- bitemporalidad;
- governance;
- decision ledger;
- permissions;
- RAG/search integrado;
- UI completa;
- consultas sobre DB mapeadas a ontología.

Lectura: Utopia es más cercano a una **plataforma de knowledge governance / world model**, mientras Graphify es una capa de comprensión/grafo.

### vs Memanto

Memanto está más orientado a memoria operativa de agentes: recordar decisiones, preferencias, errores y continuidad entre sesiones.

Utopia modela conocimiento factual/empresarial con estructura temporal y ontológica.

Lectura: pueden ser complementarios.

- Memanto = memoria episódica/operativa del agente.
- Utopia = conocimiento gobernado/temporal del dominio.

### vs LightRAG

LightRAG se concentra en retrieval/generation sobre corpus grandes combinando grafo y embeddings.

Utopia añade gobierno del conocimiento, ontología, tiempo, revisiones, decisiones y datos estructurados.

Lectura: si Utopia cubre bien retrieval para nuestro caso, podría hacer innecesario LightRAG. No conviene mantener ambos sin benchmark.

### vs Obsidian

No reemplaza Obsidian como fuente humana editable.

Obsidian debería seguir siendo canon humano/transversal; Utopia sería una representación estructurada, derivada y gobernada.

## Arquitectura candidata para MatiOS

No adoptar Utopia como reemplazo total inmediatamente.

Arquitectura a evaluar:

```text
Obsidian / GitHub / CRM / Agentis DB / documentos
        ↓
normalización / ingest
        ↓
Utopia experimental
  ├─ ontology
  ├─ bitemporal graph
  ├─ entity resolution
  ├─ hybrid retrieval
  ├─ decision ledger
  └─ MCP
        ↓
Context Router
        ↓
Model Router local/cloud
        ↓
agentes
```

Memanto podría seguir separado para memoria episódica del agente.

Graphify podría seguir siendo más adecuado para comprensión inmediata de código/repos, incluso si Utopia se adopta para conocimiento de negocio.

## Dónde Utopia podría aportar muchísimo a Agentis

### Business Operator

Ejemplos:
- “el cliente X tenía precio A hasta junio y luego B”;
- “qué promo estaba vigente cuando ocurrió esta venta”;
- “qué regla llevó a clasificar este cliente así”;
- “qué sabíamos en ese momento cuando decidimos lanzar esta campaña”;
- “qué cambió en el negocio durante los últimos 90 días”.

La bitemporalidad permite responder sin perder historia.

### Multi-cliente

Cada negocio puede tener su ontología/config y permisos, evitando mezclar conocimiento entre clientes.

### Compliance / auditoría

El decision ledger y las fuentes por hecho permiten explicar por qué un agente actuó, qué dato usó y qué versión de la realidad conocía.

### CRM como memoria operativa

Datos del CRM y Agentis DB podrían mapearse a entidades/relaciones comunes, convirtiendo la Knowledge Layer en una capa semántica sobre múltiples sistemas.

## Riesgos y límites

Utopia está en v0.1 y el propio proyecto advierte que el schema cambia entre versiones y las migraciones no tienen rollback.

También agrega bastante complejidad frente a Graphify + Markdown.

No adoptar por features o estrellas. Debe demostrar valor sobre nuestro corpus y workloads.

## Benchmark recomendado

Comparar en un subset real de MatiOS + Agentis:

1. Obsidian/Search directo.
2. Graphify.
3. Graphify + Memanto.
4. Utopia.
5. Utopia + Memanto si el experimento lo justifica.

Preguntas:
- factual simple;
- relación entre conceptos;
- historial de decisiones;
- “qué cambió entre fecha A y B”;
- conflictos entre notas;
- deduplicación de entidades;
- preguntas que crucen docs + datos;
- continuidad de trabajo de agentes.

Medir:
- precisión/groundedness;
- temporal correctness;
- tokens enviados al modelo;
- latencia;
- costo;
- calidad de fuentes;
- cantidad de intervención humana;
- complejidad operativa;
- facilidad de backup/migración;
- privacidad/local execution.

## Decisión actual

**No reemplazar todavía Graphify + Memanto por Utopia.**

Utopia debe entrar como **candidato serio para la futura Knowledge Core / Business Knowledge Layer**, especialmente por bitemporalidad, ontología, governance, permisos y auditoría.

La hipótesis más interesante es:

`Graphify para código y relaciones rápidas + Memanto para memoria episódica + Utopia para conocimiento empresarial temporal/gobernado`.

Pero si Utopia demuestra suficiente cobertura de retrieval/grafo, podría absorber parte del rol que hoy asignamos a LightRAG y a algunos componentes propios del Knowledge Vault.

## Principio aprendido

> Un knowledge graph no sólo debe saber qué es verdad ahora. Para operar negocios y agentes a largo plazo también importa saber qué era verdad, cuándo lo aprendimos y por qué cambió.

Última actualización: 2026-09-15.
