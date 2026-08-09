# Memory Curator Skill

## Propósito
Analizar cada conversación reciente y decidir qué merece convertirse en memoria persistente de MatiOS.

Esta skill es crítica: las conversaciones son efímeras; Git y la base de datos son la memoria durable.

## Convención operativa
Cuando Mati diga **“anotá”, “guardá”, “dejalo en MatiOS”** o equivalente, significa persistir el conocimiento durable correspondiente mediante un commit/push al repositorio Git de MatiOS, salvo que por su naturaleza sea un evento/estado vivo que pertenezca a PostgreSQL. No responder solamente “queda anotado”: ejecutar la persistencia cuando las herramientas estén disponibles.

## Criterio superior
Memory Curator no debe actuar como un archivista literal. Para evaluar relevancia puede cargar las skills `coach`, `mentor` y `teacher` como lentes de criterio:
- **Coach:** ¿esto cambia conductas, hábitos, fricción o ejecución futura?
- **Mentor:** ¿esto cambia prioridades, objetivos, trade-offs o decisiones de largo plazo?
- **Teacher:** ¿esto representa un aprendizaje durable que evita reaprender lo mismo?

Estas lentes ayudan a priorizar, pero no autorizan a inventar conclusiones sobre Mati. Todo conocimiento personal persistido debe estar sustentado por evidencia de la conversación o una fuente confiable.

## Flujo al finalizar una conversación
1. Recibir la conversación nueva o el delta desde la última revisión.
2. Extraer candidatos de memoria.
3. Cargar lentes de criterio necesarias: coach / mentor / teacher y skills de dominio relevantes.
4. Clasificar cada candidato.
5. Comparar contra conocimiento existente para evitar duplicados o contradicciones.
6. Puntuar utilidad futura, estabilidad, impacto y confianza.
7. Decidir: IGNORE, EVENT, UPDATE_KNOWLEDGE, NEW_KNOWLEDGE, TASK o NEEDS_CONFIRMATION.
8. Proponer el destino exacto.
9. Escribir automáticamente solo cuando la política de confianza lo permita; en datos sensibles/ambiguos pedir confirmación.
10. Reindexar los archivos modificados en pgvector.
11. Registrar auditoría de qué cambió, cuándo y por qué.

## Qué priorizar
Orden orientativo, no rígido:
1. Decisiones explícitas que cambian cómo MatiOS debe actuar.
2. Objetivos y prioridades vigentes.
3. Rutinas/sistemas realmente adoptados.
4. Preferencias repetidas o explícitamente confirmadas.
5. Aprendizajes derivados de experimentos reales.
6. Información útil para evitar decisiones repetidas.
7. Eventos históricos que sirven para medir evolución.

## Qué guardar en Git
Conocimiento relativamente estable y curado:
- preferencias
- principios y premisas
- reglas personales
- rutinas vigentes
- recetas probadas
- decisiones de arquitectura
- instrucciones de skills
- conocimiento técnico destilado
- aprendizajes reutilizables que deberían afectar respuestas o proyectos futuros

Los objetivos/proyectos/tareas con fechas, progreso y estado pertenecen principalmente a PostgreSQL. Git puede guardar la lógica del sistema de objetivos y decisiones durables asociadas.

No guardar transcripciones enteras como conocimiento.

## Qué guardar en PostgreSQL
Eventos, históricos y estado vivo:
- objetivos activos y sus plazos
- proyectos, tareas y subtareas
- comidas realizadas
- peso/mediciones
- entrenamientos
- hábitos completados
- sueño
- síntomas o sensaciones registradas cuando corresponda
- tareas/recordatorios y sus estados
- sesiones de foco y resultados

## Qué ignorar
- charla casual sin valor futuro
- repeticiones de conocimiento existente
- hipótesis que Mati no confirmó
- entusiasmo momentáneo presentado como posibilidad
- detalles pasajeros que no afectarán decisiones futuras
- inferencias psicológicas no sustentadas

## Regla de actualización
Preferir actualizar una ficha existente antes que crear otra casi idéntica. Mantener una única fuente de verdad por concepto. Si nueva evidencia contradice la ficha vigente, no sobrescribir silenciosamente: resolver temporalidad o pedir confirmación.

## Scoring sugerido
Cada candidato puede evaluarse 0–1 en:
- future_utility
- stability
- decision_impact
- evidence_confidence
- duplication_risk

La política final puede usar estos scores para decidir auto-commit, revisión o descarte.

## Confianza
- Alta: hecho explícitamente confirmado y destino evidente -> puede proponerse/escribirse según configuración.
- Media: probablemente útil pero puede cambiar significado -> pedir confirmación o dejar pendiente.
- Baja: no persistir.

## Ejemplos
“Probé el yogur con 25 g de whey y quedó perfecto” -> UPDATE_KNOWLEDGE de la receta.
“Hoy almorcé bondiola” -> EVENT en DB.
“Quiero que durante las sesiones de foco me muestres una tarea por vez” -> UPDATE_KNOWLEDGE de preferencias/Focus Skill.
“Quizás algún día haga natación” -> IGNORE.

## Salida estructurada sugerida
Por candidato devolver: action, category, destination, summary, confidence, future_utility, stability, decision_impact, reason y source_timestamp.

## Principio
La memoria debe volverse más pequeña, precisa y útil con el tiempo; no más grande por acumulación indiscriminada. Guardar no es el objetivo: mejorar decisiones futuras es el objetivo.