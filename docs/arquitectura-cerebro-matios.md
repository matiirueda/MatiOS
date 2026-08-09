# Arquitectura del cerebro MatiOS

## Norte
MatiOS debe poder conocer a Mati sin depender de la memoria limitada de una conversación o de un proveedor/modelo concreto.

## Premisa central — conocimiento acumulativo
MatiOS no debe recordar solamente información sobre Mati. También debe conservar y destilar el conocimiento adquirido mientras Mati hace proyectos, investiga, aprende, prueba herramientas y resuelve problemas.

El objetivo es que cada tarea o proyecto nuevo pueda comenzar desde el conocimiento acumulado anteriormente, evitando pagar repetidamente el costo cognitivo de investigar, decidir y aprender lo mismo.

### Tres memorias conceptuales
1. **Memoria personal:** preferencias, criterios, rutinas, objetivos de largo plazo y formas de trabajar.
2. **Memoria de conocimiento:** conceptos, patrones, arquitecturas, técnicas, recursos y procedimientos aprendidos (por ejemplo RAG, n8n, agentes, APIs, Power BI, ventas o nutrición).
3. **Memoria de experiencia:** qué se hizo realmente, qué decisiones se tomaron, qué falló, qué funcionó y qué aprendizajes dejó cada proyecto.

### Loop de aprendizaje
hacer -> observar -> documentar -> destilar -> indexar -> reutilizar -> hacer mejor -> volver a aprender

### Regla de reutilización
Antes de investigar o diseñar una solución desde cero, MatiOS debe buscar si existe conocimiento o experiencia previa relevante. El objetivo es acelerar cualquier tarea o proyecto futuro con lo aprendido anteriormente.

El código por sí solo no alcanza: cuando un proyecto produce un patrón reutilizable, también deben quedar documentados el contexto, la decisión, los trade-offs, errores, solución final y cuándo conviene reutilizarla.

## Capas

### 1. Git — fuente de verdad curada
Guarda conocimiento estable: preferencias, rutinas, recetas, decisiones, principios, conocimiento técnico destilado, aprendizajes reutilizables y skills. Los objetivos/proyectos/tareas con estado y fechas viven principalmente en PostgreSQL; Git conserva sus reglas y conocimiento durable asociado.

### 2. PostgreSQL — memoria episódica / histórica y estado vivo
Guarda eventos y objetos con tiempo/estado: objetivos activos, proyectos, tareas, comidas, entrenamientos, hábitos, sueño, mediciones, sesiones de foco y recordatorios. Los elementos completados pasan a histórico en lugar de desaparecer necesariamente.

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

Memory Curator debe evaluar no solo si una conversación contiene información personal nueva, sino también si produjo conocimiento o experiencia reutilizable.

## Separación fundamental
- Git responde “qué sabemos / qué reglas están vigentes / qué aprendimos de forma durable”.
- DB responde “qué está pasando, qué pasó y cuándo”.
- Vector responde “dónde puede estar lo relevante”.
- Skill responde “cómo resolver esta clase de problema”.
- Agente responde “quién coordina el razonamiento”.
- n8n responde “cuándo y con qué sistemas se ejecuta”.

## Principios de diseño
- No crear un agente por cada carpeta. Mantener pocos agentes coordinadores y muchas skills pequeñas, legibles y versionables.
- No guardar por guardar: persistir aquello que mejore decisiones o acelere trabajo futuro.
- Cada proyecto debería hacer que el siguiente proyecto relacionado sea más fácil.
- MatiOS debe ser portable entre modelos e interfaces: el conocimiento y las reglas pertenecen a MatiOS, no al proveedor de IA.