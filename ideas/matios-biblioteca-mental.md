---
title: "MatiOS — Biblioteca mental y capa visual"
type: idea
status: accepted
created: 2026-08-09
tags:
  - matios
  - knowledge-management
  - obsidian
  - git
  - postgresql
  - pgvector
  - rag
  - notebooklm
  - n8n
---

# MatiOS — Biblioteca mental y capa visual

## Visión

MatiOS debe convertirse progresivamente en una biblioteca mental personal, portable y durable: conocimiento acumulado de estudios, proyectos, experiencia, conversaciones e ideas que pueda ser navegado por Mati y reutilizado por agentes.

La arquitectura separa deliberadamente las responsabilidades. No buscamos que una única herramienta haga todo ni crear múltiples fuentes de verdad contradictorias.

## Capas y responsabilidades

### Git — conocimiento curado y versionado

Git es la fuente de verdad del conocimiento ya procesado que merece persistir a largo plazo.

Contiene principalmente Markdown/YAML y artefactos livianos:
- conceptos;
- resúmenes;
- decisiones;
- aprendizajes;
- documentación de proyectos;
- recetas y procedimientos;
- prompts, skills y reglas;
- relaciones y metadata entre piezas de conocimiento.

Ventajas buscadas: portabilidad, historial, diff, branches, PR, revisión humana y ausencia de lock-in.

### Google Drive — biblioteca de archivos originales

Drive funciona como biblioteca documental y fuente de archivos pesados/originales:
- PDFs;
- presentaciones;
- apuntes;
- material académico;
- documentos de referencia;
- imágenes u otros archivos que no conviene duplicar dentro de Git.

Git puede guardar referencias, metadata, resúmenes y enlaces hacia estos originales.

### NotebookLM — conversación y exploración sobre fuentes

NotebookLM es una capa de explotación del material documental. Sirve para conversar con las fuentes, estudiar, cruzar documentos, generar ideas y producir borradores/resúmenes.

Lo valioso que emerge de esas conversaciones no queda aislado: puede guardarse como material/original en Drive y, cuando se convierte en conocimiento durable, resumirse y curarse hacia Git.

### PostgreSQL — estado vivo e histórico

PostgreSQL almacena el estado estructurado y cambiante del sistema:
- entidades;
- eventos;
- históricos;
- estados de proyectos;
- relaciones operativas;
- ejecuciones de agentes/workflows;
- metadata que necesite consultas y actualización frecuente.

No reemplaza a Git para conocimiento curado: cumple otra función.

### pgvector / RAG — recuperación semántica

El índice vectorial es derivado, reconstruible y orientado a recuperación. Puede indexar conocimiento de Git y, cuando corresponda, información seleccionada de otras fuentes.

Principio: el vector store no es la fuente de verdad. Si desaparece, debe poder reconstruirse desde las fuentes canónicas.

### Obsidian — capa humana de explotación visual

Obsidian funciona principalmente como interfaz humana sobre la biblioteca Markdown de Git.

Objetivos:
- leer documentos fácilmente;
- navegar backlinks;
- recorrer conceptos relacionados;
- usar Graph View como mapa de conocimiento;
- explorar metadata/frontmatter;
- descubrir conexiones que no son evidentes mirando carpetas;
- editar manualmente cuando tenga sentido.

Obsidian NO necesita convertirse en una nueva fuente de verdad. Idealmente abre como vault una parte compatible del repositorio o una vista sincronizada de sus Markdown.

Así Mati puede acceder al mismo conocimiento de dos formas complementarias:
1. mediante agentes/ChatGPT/RAG para preguntar y operar;
2. mediante Obsidian para mirar, navegar y pensar visualmente.

### Agentes / skills — capa de inteligencia

Los agentes consumen las fuentes anteriores según la tarea. Deben distinguir entre:
- leer conocimiento;
- consultar estado vivo;
- recuperar contexto semánticamente;
- proponer nuevo conocimiento;
- modificar conocimiento existente.

Para cambios importantes sobre Git, el patrón preferido será branch -> propuesta -> diff/PR -> aprobación humana -> merge. Esto permite que MatiOS aprenda sin perder control ni trazabilidad.

### n8n — orquestación

n8n conecta procesos y automatizaciones: ingestión, sincronización, extracción de metadata, disparo de agentes, indexación, notificaciones y otros workflows.

Debe orquestar, no convertirse en repositorio de conocimiento.

## Flujo conceptual de conocimiento

Un flujo deseado es:

`Fuente original -> material/clase/proyecto -> extracción o conversación -> resumen -> concepto/aprendizaje -> Git -> indexación RAG -> reutilización por agentes`

Cada pieza curada debería poder mantener trazabilidad hacia su origen cuando sea relevante.

Ejemplo:

`PDF en Drive -> NotebookLM -> resumen de clase -> concepto Markdown en Git -> backlinks en Obsidian -> embedding en pgvector -> agente lo recupera meses después`

## Metadata y trazabilidad

Los Markdown importantes deberían evolucionar hacia frontmatter consistente. Campos posibles:

```yaml
title: "..."
type: concept | summary | project | decision | recipe | note
status: draft | accepted | archived
source_type: drive | conversation | course | project | personal
source_ref: "..."
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
related: []
```

No es necesario imponer todo desde el primer día. El esquema debe crecer cuando aparezca una necesidad real.

## Regla de oro

Separar claramente:

- **Originales / archivos:** Drive.
- **Conocimiento curado y durable:** Git.
- **Estado vivo / histórico estructurado:** PostgreSQL.
- **Recuperación semántica derivada:** pgvector/RAG.
- **Exploración documental:** NotebookLM.
- **Exploración visual del conocimiento:** Obsidian.
- **Inteligencia y acciones:** agentes/skills.
- **Automatización:** n8n.

## Riesgos a evitar

- duplicar el mismo conocimiento manualmente en Git, Drive, Obsidian y PostgreSQL;
- tratar embeddings como datos canónicos;
- permitir que agentes reescriban conocimiento crítico sin revisión;
- meter archivos pesados innecesarios en Git;
- crear una taxonomía gigante antes de tener contenido real;
- automatizar demasiado antes de validar el flujo humano;
- perder la referencia entre un conocimiento resumido y su fuente original.

## MVP incremental

### Fase 1 — Biblioteca visible

1. Mantener Git como núcleo Markdown.
2. Instalar/configurar Obsidian.
3. Abrir el conocimiento compatible de MatiOS como vault.
4. Definir frontmatter mínimo.
5. Empezar a usar backlinks y enlaces entre conceptos.
6. Mantener Drive como biblioteca de originales.

Resultado: Mati puede navegar visualmente su cerebro sin cambiar la arquitectura base.

### Fase 2 — Ingesta y trazabilidad

1. Definir convención para referencias a Drive.
2. Crear flujo fuente -> resumen -> concepto.
3. Incorporar NotebookLM como herramienta de estudio/exploración.
4. Guardar en Git sólo los resultados que realmente merecen persistir.

### Fase 3 — Memoria operativa

1. Levantar/afianzar PostgreSQL.
2. Modelar entidades, eventos e históricos.
3. Conectar conocimiento Git con estado operativo mediante IDs/metadata cuando aporte valor.

### Fase 4 — RAG

1. Chunking de Markdown curado.
2. Embeddings.
3. pgvector.
4. Metadata suficiente para devolver no sólo texto, sino también la fuente exacta.
5. Reindexación reproducible.

### Fase 5 — Agentes que aprenden con control

1. Agentes leen Git + PostgreSQL + RAG según necesidad.
2. Nuevos aprendizajes se generan como propuestas.
3. Cambios importantes se escriben en branches.
4. Mati revisa diff/PR.
5. Merge convierte la propuesta en conocimiento aceptado.
6. El pipeline reindexa automáticamente.

## Próximo paso

Comenzar la implementación incremental de este plan, priorizando primero la experiencia humana: estructura Markdown + Obsidian + enlaces + metadata mínima. Luego sumar automatización y RAG sobre una biblioteca que ya resulte útil manualmente.

La meta no es construir infraestructura por construirla. La meta es que cada semana MatiOS recuerde más, conecte mejor el conocimiento acumulado y permita reutilizarlo con menos fricción.
