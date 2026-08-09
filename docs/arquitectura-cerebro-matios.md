# Arquitectura del cerebro MatiOS

## Norte
MatiOS debe poder conocer a Mati sin depender de la memoria limitada de una conversación o de un proveedor/modelo concreto.

## Capas

### 1. Git — fuente de verdad curada
Guarda conocimiento estable: objetivos, preferencias, rutinas, recetas, decisiones, proyectos y skills.

### 2. PostgreSQL — memoria episódica / histórica
Guarda eventos con tiempo y estado: comidas, entrenamientos, hábitos, sueño, mediciones, tareas y recordatorios.

### 3. pgvector — índice semántico derivado
Indexa Git y/o eventos seleccionados para recuperación. Es reconstruible y no debe ser la única copia de información importante.

### 4. Skills — procedimientos
Definen cómo razonar y qué fuentes consultar para cada dominio. No son necesariamente agentes independientes.

### 5. Agentes
Configuración inicial recomendada:
- MatiOS Core: router/coordinador.
- Health Coach: nutrition + training + mobility + habits + skincare.
- Agentis Coach: proyecto, aprendizaje, producto y ventas.
- Life Admin: agenda, tareas y recordatorios.
- Memory Curator: analiza conversaciones y mantiene la memoria durable.

### 6. n8n — orquestación
Dispara flujos por horario/evento, llama agentes, consulta servicios y envía mensajes/recordatorios.

## Flujo de una consulta
mensaje -> MatiOS Core -> Router Skill -> skills relevantes -> Git/DB/RAG -> respuesta/acción -> Memory Curator

## Flujo crítico de memoria
conversación nueva -> Memory Curator -> extracción -> deduplicación -> clasificación -> Git/DB/ignore -> reindexación -> auditoría

## Separación fundamental
- Git responde “qué sabemos / qué reglas están vigentes”.
- DB responde “qué pasó y cuándo”.
- Vector responde “dónde puede estar lo relevante”.
- Skill responde “cómo resolver esta clase de problema”.
- Agente responde “quién coordina el razonamiento”.
- n8n responde “cuándo y con qué sistemas se ejecuta”.

## Principio de diseño
No crear un agente por cada carpeta. Mantener pocos agentes coordinadores y muchas skills pequeñas, legibles y versionables.