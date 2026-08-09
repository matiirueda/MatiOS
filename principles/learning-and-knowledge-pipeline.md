# Learning & Knowledge Pipeline

## Premisa
Estudiar no significa consumir todo el material linealmente. MatiOS debe ayudar a transformar material bruto en comprensión útil y conocimiento durable, manteniendo siempre acceso a la fuente original.

## Capas de información
1. **Fuente original:** PDF, diapositivas, video/audio de clase, bibliografía u otro material entregado por la institución.
2. **Transcripción / extracción:** representación textual del material cuando corresponda.
3. **Artefactos de estudio:** resumen, mapa/árbol conceptual, preguntas, ejemplos, flashcards o ejercicios.
4. **Conocimiento destilado:** conceptos y aprendizajes que vale la pena incorporar a la biblioteca mental de MatiOS.
5. **Índice vectorial:** chunks/embeddings derivados para recuperar fuente y conocimiento; nunca única copia.

## Almacenamiento
### Drive / object storage
Fuente pesada/original: videos, audios, PDFs, presentaciones y transcripciones extensas. Git no debe convertirse en depósito de archivos pesados.

### Git
Conocimiento curado y versionable: notas conceptuales, resúmenes finales, mapas en Markdown/Mermaid, decisiones, aprendizajes reutilizables y referencias a las fuentes originales.

### PostgreSQL
Estado vivo: curso, materia, clase, fecha, progreso, tareas, entregas, sesiones de estudio y relación entre artefactos.

### pgvector
Índice semántico derivado sobre conocimiento y, cuando sea útil, transcripciones/materiales procesados.

## Flujo de una clase/material
material -> registrar fuente -> extraer/transcribir -> IA genera primera síntesis -> Mati interactúa/pregunta/aprende -> producir árbol/modelo mental -> verificar contra fuente -> destilar conocimiento -> Memory Curator propone persistencia -> PR/review -> Git -> indexar

## NotebookLM y herramientas externas
Herramientas como NotebookLM pueden funcionar como una mesa de estudio temporal sobre las fuentes: preguntas, exploración, síntesis y contraste. No deben ser la única memoria durable del sistema. Los aprendizajes valiosos se exportan/destilan a MatiOS y se conserva una referencia a la fuente original.

## Regla de trazabilidad
Todo conocimiento académico importante debería poder responder: ¿de qué curso/materia/clase/fuente salió? Los resúmenes no deben romper el vínculo con la fuente.

## Regla de compresión
No guardar automáticamente todas las transcripciones en Git ni vectorizar indiscriminadamente todo. Conservar originales baratos fuera de Git, destilar lo valioso y ampliar hacia la fuente cuando una consulta necesite detalle.

## Aprendizaje activo
La IA puede reducir lectura mecánica, pero el objetivo no es saltear comprensión. Teacher Skill debe favorecer preguntas, explicación con palabras propias, ejemplos y aplicación. Para evaluaciones/entregas, Mati debe poder defender lo producido.

## Pipeline futuro por clase
- INGEST: registrar material y metadata.
- EXTRACT: texto/transcripción.
- SUMMARIZE: resumen estructurado.
- MAP: árbol/mapa conceptual.
- TEACH: sesión interactiva con Teacher Skill.
- DISTILL: candidatos de conocimiento durable.
- REVIEW: Mati aprueba.
- INDEX: actualizar recuperación semántica.

## Reutilización
El conocimiento aprendido en la especialización puede alimentar proyectos reales de MatiOS/Agentis. A su vez, la experiencia práctica puede enlazarse a conceptos académicos. La biblioteca mental debe permitir navegar en ambos sentidos: teoría -> experiencia y experiencia -> teoría.