# Flujo n8n — Memory Curator

## Objetivo
Después de una interacción, convertir únicamente los aprendizajes útiles en memoria durable.

## Pipeline propuesto
1. Trigger: conversación terminada o ventana de inactividad.
2. Obtener mensajes desde `last_memory_checkpoint`.
3. Llamar al agente Memory Curator con `skills/memory/SKILL.md`.
4. Recibir JSON de candidatos.
5. Para cada candidato:
   - IGNORE -> terminar.
   - EVENT -> insertar/upsert en PostgreSQL.
   - UPDATE_KNOWLEDGE -> leer archivo Git existente, aplicar cambio y commit.
   - NEW_KNOWLEDGE -> crear ficha en ubicación canónica.
   - TASK -> crear/actualizar tarea y programar trigger si corresponde.
   - NEEDS_CONFIRMATION -> poner en cola y preguntar a Mati.
6. Ejecutar deduplicación/validación antes de cada escritura.
7. Reindexar en pgvector los documentos modificados.
8. Guardar `memory_checkpoint` y audit log.

## JSON sugerido
```json
{
  "candidates": [
    {
      "action": "UPDATE_KNOWLEDGE",
      "category": "recipe",
      "destination": "recetas/...",
      "summary": "La versión probada usa 25 g de whey",
      "confidence": 0.97,
      "reason": "Mati confirmó el resultado después de probarla"
    }
  ]
}
```

## Protecciones
- Idempotencia: procesar cada rango de mensajes una sola vez.
- Nunca sobrescribir conocimiento contradictorio silenciosamente.
- Conservar historial mediante commits de Git.
- Datos ambiguos o sensibles -> confirmación.
- No mandar cada frase a memoria.

## Evolución
Primera versión: revisión humana para escrituras Git.
Segunda versión: auto-commit para categorías de alta confianza.
Tercera versión: evaluación periódica que detecte conocimiento obsoleto y proponga consolidaciones.