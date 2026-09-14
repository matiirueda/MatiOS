# Agentis — Prompting Patterns

## Objetivo

Definir un formato base reusable para prompts de agentes, workflows y tareas de generación dentro de Agentis/MatiOS. El objetivo no es convertir todos los prompts en formularios rígidos, sino reducir ambigüedad, mejorar consistencia y hacer más fácil testear, comparar y versionar prompts.

## Patrón base

Un prompt útil puede estructurarse en seis bloques:

1. **Rol** — qué perspectiva/capacidad debe asumir el agente.
2. **Tarea** — qué debe producir o resolver.
3. **Contexto** — información relevante, restricciones, audiencia, negocio y datos disponibles.
4. **Criterios de decisión / verificación** — qué debe revisar antes de responder y qué trade-offs/principios debe respetar.
5. **Formato de salida** — estructura exacta esperada del resultado.
6. **Condiciones de finalización** — qué requisitos deben cumplirse para considerar la tarea terminada.

Patrón:

```text
ROL
[Tono/capacidad/especialidad necesaria]

TAREA
[Qué hacer, con objetivo observable]

CONTEXTO
[Datos relevantes + restricciones + audiencia + ejemplos]

CRITERIOS / VERIFICACIONES
[Qué comprobar, priorizar y evitar]

FORMATO DE SALIDA
[JSON / Markdown / tabla / schema / campos obligatorios]

DEFINITION OF DONE
[Condiciones medibles de finalización]
```

## Por qué sirve

Este patrón ayuda especialmente cuando:
- el prompt se reutiliza muchas veces;
- distintos modelos deben ejecutar la misma tarea;
- el resultado entra a otro agente/workflow;
- necesitamos comparar versiones de prompt;
- hay restricciones claras o criterios de negocio;
- queremos medir calidad automáticamente.

## Corrección importante: no pedir “razonamiento” interno

No hace falta pedir al modelo que exponga razonamiento paso a paso. Para Agentis es mejor convertir ese bloque en **criterios de decisión, checklist o verificaciones observables**.

Ejemplo:

En vez de:
`Razoná paso a paso por qué este lead es bueno.`

Preferir:
`Evalúa fit, urgencia, presupuesto y autoridad. Devuelve score + señales observadas + incertidumbres.`

Así obtenemos trazabilidad útil sin depender de cadenas de pensamiento internas.

## Separar instrucciones estables de variables

No copiar un prompt entero por cliente o vertical.

Preferir:

`Prompt Template + Client Config + Runtime Context`

Ejemplo:

```text
Prompt estable:
- objetivo
- reglas
- formato
- definition of done

Client Config:
- vertical
- tono
- oferta
- thresholds
- restricciones

Runtime Context:
- lead actual
- historial
- CRM data
- campaign source
```

Esto permite versionar el prompt una vez y reutilizarlo en múltiples clientes.

## Outputs estructurados

Cuando otro sistema consume la respuesta, preferir schemas explícitos.

Ejemplo:

```json
{
  "score": 0,
  "segment": "hot|warm|cold",
  "signals": [],
  "missing_information": [],
  "recommended_action": "",
  "confidence": 0.0
}
```

El modelo debe producir lo mínimo necesario para la siguiente etapa, no texto decorativo.

## Definition of Done

La condición de finalización es especialmente valiosa para tareas largas o agentes con tools.

Ejemplos:
- no terminar hasta validar que todos los campos obligatorios estén presentes;
- no publicar hasta que la campaña esté en draft y pase safety checks;
- no cerrar una tarea de código hasta que tests y lint pasen;
- no generar calendario hasta completar los 30 días sin duplicados;
- no responder una consulta documental sin citar fuentes suficientes.

Esto conecta directamente con la filosofía Agentis de trabajo medible.

## Ejemplos por Factory

### Lead Agent

`Rol → sales qualification specialist`
`Tarea → clasificar lead y recomendar siguiente acción`
`Contexto → CRM + conversación + Client Config`
`Criterios → fit/urgencia/presupuesto/autoridad + política HITL`
`Salida → schema estructurado`
`Done → score + evidencia + siguiente acción + confidence`

### Content Factory

`Rol → creative strategist`
`Tarea → generar variantes para una hipótesis concreta`
`Contexto → producto + audiencia + research + campaña`
`Criterios → diferenciación, brand voice, hook, no claims no sustentados`
`Salida → hooks/copies/scripts/assets specs`
`Done → número mínimo de variantes + trazabilidad a hipótesis`

### Ads Factory

`Rol → campaign strategist`
`Tarea → transformar objetivo de negocio en Campaign Spec`
`Contexto → oferta + CRM + budget + channel constraints`
`Criterios → objetivo de negocio, atribución, guardrails, test aislable`
`Salida → Campaign Spec estructurada`
`Done → hipótesis + audiencia + creatives + presupuesto + tracking + approval state`

### Backend / Coding Agent

`Rol → backend engineer/reviewer`
`Tarea → implementar cambio`
`Contexto → issue + AGENTS.md + arquitectura + Graphify`
`Criterios → compatibilidad + seguridad + simplicidad + tests`
`Salida → cambios + tests + resumen`
`Done → tests/lint/type checks/documentación relevante actualizada`

## Versionado y observabilidad

Todo prompt importante debería tener:
- `prompt_id`;
- `prompt_version`;
- modelo/proveedor usado;
- Client Config/version;
- output schema/version;
- latency;
- tokens/costo;
- eval score;
- business outcome cuando exista.

Esto permite A/B tests reales entre prompts y modelos.

## Regla Agentis

> Un buen prompt no es sólo texto bien escrito: es un contrato entre contexto, criterios, salida y Definition of Done que podamos versionar, medir y reutilizar.

Última actualización: 2026-09-14.
