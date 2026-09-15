# Agentis — Model Router

## Objetivo

Diseñar una capa de routing de modelos que seleccione el modelo/proveedor más adecuado para cada tarea según complejidad, modalidad, privacidad, calidad mínima, latencia y costo.

Principio:

> No usar el modelo más potente por defecto. Usar el modelo más chico/barato que supere la calidad mínima y escalar sólo cuando haga falta.

## Repo investigado — `ulab-uiuc/LLMRouter`

Repo: `ulab-uiuc/LLMRouter`
Licencia: MIT.
Lenguaje principal: Python.
Estado observado: activo, con releases y cambios recientes durante 2026.

LLMRouter es una librería open source dedicada específicamente a routing de LLMs. No es sólo un proxy simple por reglas: incluye más de 16 estrategias de routing agrupadas en single-round, multi-round, multimodal, personalized y agentic routers.

Entre las estrategias soportadas hay KNN, SVM, MLP, matrix factorization, Elo, graph-based routing, hybrid routing, AutoMix y routers basados en LLM. También incluye CLI unificado, UI con Gradio, generación de datasets para entrenamiento/evaluación y plugins para routers custom.

La versión actual también incorpora:
- routing multimodal;
- perfiles/personalización de usuarios;
- routing multi-turn;
- routers agentic;
- server OpenAI-compatible;
- streaming;
- memoria de routing;
- benchmark propio xRouteBench;
- interfaz visual mediante ComfyUI para construir/evaluar pipelines de routing.

## Encaje con Agentis

Este repo valida directamente la arquitectura que venimos definiendo para el Agentis Model Router.

Agentis necesita resolver algo como:

```text
task_type
+ complexity
+ modality
+ privacy_class
+ latency_need
+ quality_threshold
+ budget
+ user/client profile
+ historical performance
        ↓
Model Router
        ↓
local small | local medium | Claude | GPT | Gemini | specialized model
```

LLMRouter puede funcionar como:
1. referencia académica/técnica para no inventar routing desde cero;
2. benchmark framework;
3. laboratorio para probar algoritmos de routing;
4. posible componente interno si sus contratos encajan con nuestra infraestructura.

No adoptarlo ciegamente como core productivo todavía. Primero evaluar si cubre bien nuestra combinación local + cloud + privacidad + herramientas/agentes.

## Diferencia con un router simple por reglas

MVP Agentis puede empezar con reglas determinísticas:

```text
clasificación/extracción simple → modelo local pequeño
RAG factual → local medium
arquitectura/código complejo → Claude/Codex fuerte
imagen → modelo visual
baja confianza → fallback
local-only → prohibir cloud
```

Pero a medida que guardamos ejecuciones podemos pasar a routing aprendido:

```text
logs históricos
+ task features
+ modelo elegido
+ costo
+ latencia
+ eval/feedback
+ business outcome
        ↓
training/evaluation dataset
        ↓
router aprendido
```

LLMRouter es especialmente interesante para esta segunda etapa.

## Routing por tarea vs routing por consulta

No limitar routing a “qué tan difícil parece el prompt”.

Agentis debería incluir contexto estructurado de la tarea:
- rol/agente que solicita;
- tipo de tarea;
- output esperado;
- modalidad;
- criticidad;
- privacy class;
- SLA/latencia;
- presupuesto;
- tamaño de contexto;
- necesidad de tool calling;
- necesidad de structured output;
- histórico de performance por modelo;
- vertical/cliente cuando sea útil.

Esto evita usar un clasificador genérico de complejidad cuando ya sabemos semánticamente qué está haciendo el sistema.

## Router jerárquico recomendado

Primero aplicar constraints determinísticos y recién después optimización dinámica.

```text
1. Policy Gate
   - privacidad
   - permisos
   - modalidad
   - modelos disponibles
   - context window
   - features obligatorias

2. Candidate Filter
   - elimina modelos incompatibles

3. Router
   - costo/calidad/latencia/histórico

4. Execution

5. Eval + outcome

6. Learning loop
```

Ejemplo: un documento marcado `local-only` nunca debe llegar al router como candidato para Claude/GPT/Gemini.

## Integración con modelos locales

Arquitectura:

```text
Hugging Face → descubrimiento
Ollama / llama.cpp / LocalAI → ejecución local
Cloud providers → ejecución remota
        ↓
Unified Model Adapter
        ↓
Model Router
```

El router no debería depender de nombres concretos de proveedores. Debe trabajar sobre capacidades y métricas.

## Routing multi-turn y agentes

Una parte particularmente interesante de LLMRouter es que no se limita a queries independientes: incluye routers multi-round, personalized y agentic.

Esto puede ser útil para Agentis porque en una misma tarea puede convenir cambiar de modelo entre pasos.

Ejemplo:

```text
Lead Agent
→ extracción: modelo chico
→ clasificación: modelo chico
→ caso ambiguo: modelo medio
→ estrategia comercial excepcional: modelo fuerte
→ resumen final: modelo chico
```

O en desarrollo:

```text
Project Lead → modelo fuerte
implementación rutinaria → modelo coding más económico
review crítico → modelo fuerte/diferente
Docs → modelo chico
```

El routing debería existir por operación, no obligatoriamente por agente completo.

## Personalización

LLMRouter incluye investigación sobre personalized routing y perfiles.

Esto encaja con una posible evolución de Agentis:
- un modelo funciona mejor para código Python;
- otro para copy en español;
- otro para un vertical particular;
- un cliente requiere máxima privacidad;
- otro prioriza velocidad;
- Mati prefiere cierto estilo/resultado.

El router puede aprender perfiles por tarea/cliente/agente, siempre que no dupliquemos conocimiento innecesario ni introduzcamos sesgos no medidos.

## Datos y observabilidad obligatoria

Guardar por ejecución:
- router_version;
- task_type;
- features usadas por el router;
- candidate_models;
- modelo seleccionado;
- razón/score de selección cuando sea explicable;
- fallback chain;
- input/context size;
- output tokens;
- latency;
- costo;
- error/retry;
- eval score;
- human feedback;
- business outcome si existe;
- privacy class;
- local/cloud.

Sin estos datos no hay routing inteligente: sólo heurísticas difíciles de mejorar.

## Métrica objetivo

No optimizar únicamente costo o benchmark académico.

Función conceptual:

```text
utility = quality
          - cost_penalty
          - latency_penalty
          - error_penalty
          - privacy/risk penalty
```

Los pesos dependen de la tarea.

Ejemplos:
- campaña publicitaria: calidad/business outcome pesa mucho;
- clasificación masiva: costo/latencia pesan más;
- conocimiento sensible: privacidad es constraint, no penalización;
- voice realtime: latencia tiene peso muy alto.

## Estrategia de implementación

### Fase 0 — routing manual/config

`task_type → model_profile`

Usar config versionada y logs desde el primer día.

### Fase 1 — reglas + fallbacks

Agregar dificultad, contexto, modalidad, privacidad, errores y confidence.

### Fase 2 — benchmark offline

Usar dataset real de Agentis y comparar estrategias simples contra LLMRouter u otros routers.

### Fase 3 — routing aprendido

Entrenar/evaluar routers con historial real cuando haya suficiente volumen de ejecuciones y etiquetas/evals confiables.

### Fase 4 — online adaptation controlada

Sólo si demuestra mejoras y con rollback/versionado.

## Experimento recomendado

Construir dataset inicial de tareas reales:
- clasificación;
- extracción;
- RAG;
- coding;
- review;
- copy;
- estrategia;
- documentos;
- visión;
- voz.

Ejecutar los mismos casos contra varios modelos locales/cloud y guardar:
`quality + cost + latency + errors`.

Comparar:
1. un único modelo fuerte;
2. reglas manuales;
3. router por complejidad;
4. una o más estrategias de LLMRouter.

El router sólo entra a producción si mejora el costo por resultado útil sin degradar calidad más allá del threshold acordado.

## Decisión Agentis

**Guardar `ulab-uiuc/LLMRouter` como referencia prioritaria y candidato de laboratorio para el Model Router.**

No reemplaza Ollama, llama.cpp ni proveedores cloud: decide entre ellos.
No reemplaza el Agentis Orchestrator: decide capacidad/modelo para una operación concreta.
No reemplaza los evals: depende de ellos para aprender.

Principio final:

> El Orchestrator decide qué trabajo hay que hacer; el Model Router decide con qué modelo conviene hacerlo.

Última actualización: 2026-09-15.
