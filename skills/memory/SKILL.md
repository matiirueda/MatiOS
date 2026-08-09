# Memory Curator Skill

## Propósito
Analizar cada conversación reciente y decidir qué merece convertirse en memoria persistente de MatiOS.

Esta skill es crítica: las conversaciones son efímeras; Git y la base de datos son la memoria durable.

## Flujo al finalizar una conversación
1. Recibir la conversación nueva o el delta desde la última revisión.
2. Extraer candidatos de memoria.
3. Clasificar cada candidato.
4. Comparar contra conocimiento existente para evitar duplicados.
5. Decidir: IGNORE, EVENT, UPDATE_KNOWLEDGE, NEW_KNOWLEDGE, TASK o NEEDS_CONFIRMATION.
6. Proponer el destino exacto.
7. Escribir automáticamente solo cuando la política de confianza lo permita; en datos sensibles/ambiguos pedir confirmación.
8. Reindexar los archivos modificados en pgvector.
9. Registrar auditoría de qué cambió, cuándo y por qué.

## Qué guardar en Git
Conocimiento relativamente estable y curado:
- preferencias
- objetivos
- reglas personales
- rutinas vigentes
- recetas probadas
- decisiones de arquitectura
- instrucciones de skills
- aprendizajes que deberían afectar respuestas futuras

No guardar transcripciones enteras como conocimiento.

## Qué guardar en PostgreSQL
Eventos e históricos:
- comidas realizadas
- peso/mediciones
- entrenamientos
- hábitos completados
- sueño
- síntomas o sensaciones registradas cuando corresponda
- tareas/recordatorios y sus estados

## Qué ignorar
- charla casual sin valor futuro
- repeticiones de conocimiento existente
- hipótesis que el usuario no confirmó
- detalles pasajeros que no afectarán decisiones futuras

## Regla de actualización
Preferir actualizar una ficha existente antes que crear otra casi idéntica. Mantener una única fuente de verdad por concepto.

## Confianza
- Alta: hecho explícitamente confirmado y destino evidente -> puede proponerse/escribirse según configuración.
- Media: probablemente útil pero puede cambiar significado -> pedir confirmación o dejar pendiente.
- Baja: no persistir.

## Ejemplo
“Probé el yogur con 25 g de whey y quedó perfecto” -> UPDATE_KNOWLEDGE de la receta.
“Hoy almorcé bondiola” -> EVENT en DB.
“Quizás algún día haga natación” -> IGNORE.

## Salida estructurada sugerida
Por candidato devolver: action, category, destination, summary, confidence, reason y source_timestamp.

## Principio
La memoria debe volverse más pequeña, precisa y útil con el tiempo; no más grande por acumulación indiscriminada.