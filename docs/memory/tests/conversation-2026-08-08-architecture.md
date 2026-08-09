# Memory Curator — prueba real 2026-08-08

## Objetivo
Usar la conversación de diseño de MatiOS como primer caso manual del futuro Memory Curator y evaluar qué debería persistir.

## Resultado de curación

### 1. UPDATE_KNOWLEDGE — convención “anotá”
- **Destino:** `skills/memory/SKILL.md`
- **Resumen:** cuando Mati dice “anotá/guardá”, espera persistencia real en Git si es conocimiento durable; no una promesa conversacional.
- **future_utility:** 1.00
- **stability:** 0.98
- **decision_impact:** 0.95
- **evidence_confidence:** 1.00
- **Motivo:** instrucción explícita que cambia el comportamiento futuro de MatiOS.

### 2. UPDATE_KNOWLEDGE — arquitectura del asistente
- **Destino:** `docs/arquitectura-cerebro-matios.md`
- **Resumen:** MatiOS Core es la interfaz principal; Router compone skills; pocos agentes especializados; Memory Curator corre como función/agente dedicado; n8n orquesta triggers y tiempos.
- **future_utility:** 1.00
- **stability:** 0.90
- **decision_impact:** 1.00
- **evidence_confidence:** 0.98
- **Motivo:** decisión arquitectónica explícitamente aceptada.

### 3. UPDATE_KNOWLEDGE — conocimiento acumulativo
- **Destino:** `docs/arquitectura-cerebro-matios.md`
- **Resumen:** MatiOS debe conservar memoria personal, conocimiento aprendido y experiencia de proyectos para que cada tarea futura empiece desde lo ya aprendido.
- **future_utility:** 1.00
- **stability:** 0.97
- **decision_impact:** 1.00
- **evidence_confidence:** 1.00
- **Motivo:** premisa central confirmada.

### 4. UPDATE_KNOWLEDGE — Focus Coach
- **Destino:** `skills/focus/SKILL.md` + `docs/flows/focus-session.md`
- **Resumen:** ante una tarea grande, dividir en pasos pequeños, mostrar una acción por vez, aceptar “terminé”, permitir pausas y volver mediante recordatorio n8n.
- **future_utility:** 0.99
- **stability:** 0.92
- **decision_impact:** 0.95
- **evidence_confidence:** 1.00
- **Motivo:** comportamiento deseado explícitamente confirmado.

### 5. UPDATE_KNOWLEDGE — lentes del Memory Curator
- **Destino:** `skills/memory/SKILL.md`, `skills/coach/`, `skills/mentor/`, `skills/teacher/`
- **Resumen:** el curador debe usar criterio de coach, mentor y maestro para priorizar memoria por utilidad futura y no guardar indiscriminadamente.
- **future_utility:** 0.98
- **stability:** 0.90
- **decision_impact:** 0.95
- **evidence_confidence:** 1.00

### 6. EVENT / GOAL STATE — especialización IA, Agentis y bloques horarios
- **Destino futuro:** PostgreSQL
- **Resumen:** especialización IA y Agentis son objetivos activos; se propusieron bloques 09–10 para especialización y 17–18 para Agentis, subordinados a obligaciones laborales.
- **future_utility:** 0.95
- **stability:** 0.60
- **decision_impact:** 0.90
- **evidence_confidence:** 0.98
- **Decisión:** no tratarlos como conocimiento Git definitivo con estado/fechas. Migrarlos a DB cuando exista el modelo de goals/tasks.

### 7. IGNORE — entusiasmo/conversación redundante
- Confirmaciones como “sí, perfecto”, bromas y reformulaciones sin información nueva no requieren memoria persistente.

## Observaciones para tunear el Curator
1. Una instrucción explícita de comportamiento debe pesar más que una preferencia inferida.
2. Debe distinguir `knowledge` de `state`: algo puede ser muy importante y aun así pertenecer a DB, no Git.
3. Debe detectar cuando una conversación ya produjo commits y evitar crear una segunda ficha redundante.
4. Debe conservar la razón de una decisión, no solo el resultado, cuando esa razón ayuda a reutilizarla.
5. Debe poder producir un `dry-run` antes de auto-commit para probar scoring y destinos.
6. No debe persistir cada confirmación positiva como un dato independiente.

## Estado
Primera ejecución manual exitosa. Próximo paso técnico: implementar este análisis como salida estructurada automática y compararla contra las decisiones humanas tomadas en conversaciones reales.