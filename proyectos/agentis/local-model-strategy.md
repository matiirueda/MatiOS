# Agentis / MatiOS — Local Model Strategy

## Objetivo

Definir cómo descubrir, ejecutar, comparar y rutear modelos locales para reducir costo, mejorar privacidad y reservar modelos cloud más potentes para las tareas que realmente los necesiten.

## Decisión principal

Usar **Hugging Face como catálogo principal de descubrimiento y comparación de modelos open-weight/locales**, pero no como runtime obligatorio.

Separación de responsabilidades:

- **Hugging Face** = catálogo de modelos, model cards, licencias, benchmarks, tamaños, context windows, variantes y quantizations.
- **Ollama / LM Studio / llama.cpp u otro runtime local** = ejecución en la PC o infraestructura propia.
- **Agentis Model Router** = decide qué modelo usar según tarea, costo, privacidad, latencia y calidad mínima.

## No buscar un único modelo para todo

Mantener perfiles por función:

```text
modelo pequeño      → clasificación / tagging / extracción
embedding model     → búsqueda semántica
modelo medio        → chat con Obsidian / Graphify / Memanto
modelo grande       → síntesis o razonamiento local cuando el hardware alcance
vision model        → imágenes / documentos visuales
```

El objetivo no es usar siempre el modelo más grande, sino el **modelo más chico/barato que cumpla la calidad mínima** para cada tipo de tarea.

## Quantization y formatos

Para uso local prestar especial atención a variantes **GGUF** y quantizations como `Q4`, `Q5`, `Q8` cuando tengan sentido.

La quantization puede reducir mucho RAM/VRAM y hacer viable un modelo más grande, pero puede cambiar calidad y velocidad. No asumir que una quantization concreta es siempre mejor: medir sobre nuestras tareas reales.

## Benchmark propio

Antes de fijar un modelo por rol, comparar aproximadamente 5–10 candidatos usando el mismo set de 30–50 preguntas/tareas reales de MatiOS.

Medir:
- calidad percibida;
- groundedness / uso correcto de fuentes;
- precisión / recall según la tarea;
- tokens por segundo;
- latencia total;
- RAM/VRAM usada;
- tamaño del modelo;
- context window realmente utilizable;
- estabilidad;
- tasa de fallback a cloud;
- costo operativo si se vuelve relevante;
- privacidad/exposición de datos.

Patrón:

`task → candidate pool → benchmark → smallest/cheapest passing model → fallback si falla`

El benchmark debe repetirse cuando aparezca una mejora tecnológica clara o cambie el hardware, pero sin perseguir cada nuevo release por moda.

## Integración con Knowledge Vault

Arquitectura esperada:

```text
Obsidian / GitHub / docs
        ↓
Graphify / Memanto / retrieval
        ↓
Context Router
        ↓
Model Router
        ├── local small model
        ├── local medium model
        ├── local vision model
        └── cloud fallback
```

Ejemplos de routing:

```text
clasificar nota              → local small
embeddings                   → local embedding model
resumir una nota             → local small/medium
consulta factual simple      → local medium
cruzar decisiones + proyecto → local medium → cloud fallback
estrategia compleja          → cloud frontier
imagen/documento visual      → modelo multimodal especializado
```

## Privacidad

El router debe considerar privacidad además de costo y calidad.

Clases sugeridas:
- `local-only`
- `cloud-allowed`
- `cloud-with-redaction`
- `restricted`

Principio:

> El contexto sensible no sale de la máquina sólo porque un modelo cloud sea mejor.

## Métricas

Registrar por ejecución:
- task type;
- modelo/provider;
- local vs cloud;
- tamaño/quantization;
- latency;
- tokens/context size;
- RAM/VRAM cuando sea posible;
- eval/quality score;
- fallback reason;
- feedback de Mati;
- error/hallucination detectada;
- costo por respuesta útil.

Objetivo futuro: poder afirmar con evidencia qué porcentaje de las tareas de MatiOS se resuelve localmente con calidad suficiente y cuánto costo/token/contexto ahorra.

## Principio operativo

> Hugging Face descubre candidatos; el runtime local los ejecuta; MatiOS decide con benchmarks y routing cuál conviene usar.

> No optimizar por costo por llamada: optimizar por costo, calidad, privacidad y resultado útil.

Última actualización: 2026-09-13.
