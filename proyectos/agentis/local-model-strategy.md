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

## Repos locales — evaluación 2026-09-15

### Ollama — prioridad muy alta

Repo: `ollama/ollama`

Rol recomendado: **runtime principal simple para empezar**.

Por qué sirve:
- instalación sencilla;
- REST API local;
- SDKs Python/JavaScript;
- integración con modelos open-weight y distintos harnesses/agentes;
- buena base para exponer modelos locales al Model Router.

Decisión Agentis: **sí, core candidato para MVP local**. Priorizar simplicidad sobre exprimir cada % de performance al principio.

### llama.cpp — prioridad muy alta como engine/runtime de bajo nivel

Repo: `ggml-org/llama.cpp`

Rol recomendado: **engine eficiente y portable**, especialmente para GGUF/quantized models y control fino de CPU/GPU.

Decisión Agentis: **sí, referencia/runtime estratégico**, aunque Ollama puede abstraerlo en primeras pruebas. Usarlo directo cuando necesitemos control de performance, hardware, serving o integración embebida.

### LocalAI — prioridad media/alta

Repo: `mudler/LocalAI`

Rol recomendado: **servidor self-hosted compatible con APIs estilo OpenAI** para unificar LLM, visión, voz, imagen y otros modelos locales.

Decisión Agentis: **muy interesante para infraestructura futura**, especialmente si queremos que varios servicios/agents consuman modelos locales mediante un contrato común. No hace falta sumarlo al MVP si Ollama alcanza.

### Jan — prioridad media como cliente de escritorio

Repo: `janhq/jan` / histórico `menloresearch/jan`

Rol recomendado: **desktop UI para experimentar y comparar modelos localmente**.

Decisión Agentis: útil para exploración humana, pero no es una dependencia del backend de Agentis.

### GPT4All — prioridad baja/media

Repo: `nomic-ai/gpt4all`

Rol recomendado: desktop/local inference accesible para equipos comunes.

Decisión Agentis: guardar como alternativa y benchmark, pero hoy Ollama/llama.cpp encajan mejor con una arquitectura programática de agentes.

### text-generation-webui / textgen — prioridad media como laboratorio

Repo actual: `oobabooga/textgen`

Rol recomendado: laboratorio/UI muy configurable para probar modelos, visión, tool-calling y APIs compatibles.

Decisión Agentis: útil para experimentación avanzada, no core productivo salvo que aporte una feature concreta que Ollama/LocalAI no cubran.

### exo — radar estratégico

Repo: `exo-explore/exo`

Rol recomendado: **agrupar varios dispositivos en un cluster para ejecutar modelos mayores localmente**.

Decisión Agentis: guardar. No usar ahora. Se vuelve interesante si en el futuro queremos repartir inferencia entre varias PCs/Macs/GPU sin depender de cloud.

### MLX-LM — prioridad alta si usamos Apple Silicon

Repo: `ml-explore/mlx-lm`

Rol recomendado: inferencia/fine-tuning eficiente sobre Mac con Apple Silicon.

Decisión Agentis: **condicional al hardware**. Si parte del stack local corre en Mac Apple Silicon, benchmarkearlo contra llama.cpp/Ollama.

### ComfyUI — prioridad alta, pero para media/image factory

Repo: `Comfy-Org/ComfyUI`

Rol recomendado: workflow engine por nodos para generación de imagen/video y pipelines visuales locales.

Decisión Agentis: **sí para Content Factory / visual generation**, no como runtime de LLM general. Mantenerlo separado del core textual para evitar mezclar responsabilidades.

### whisper.cpp — prioridad alta para Voice Factory/local STT

Repo: `ggml-org/whisper.cpp`

Rol recomendado: **speech-to-text local/offline**, CPU/GPU/Apple Silicon, con quantization y soporte de VAD.

Decisión Agentis: **sí, candidato prioritario para benchmark de STT local**. Comparar latencia/calidad en español rioplatense contra proveedores cloud antes de usarlo en producción.

## Regla de selección de runtime

No instalar todo.

Orden de prueba sugerido:

```text
Ollama primero
→ llama.cpp directo si necesitamos más control
→ LocalAI si necesitamos un gateway OpenAI-compatible multi-modal
→ MLX-LM si Apple Silicon demuestra ventaja
→ exo sólo si necesitamos clustering local
```

UI/laboratorios como Jan, GPT4All y textgen son herramientas de exploración, no parte obligatoria de la arquitectura productiva.

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
- runtime usado;
- latency;
- tokens/context size;
- RAM/VRAM cuando sea posible;
- tokens/s;
- eval/quality score;
- fallback reason;
- feedback de Mati;
- error/hallucination detectada;
- costo por respuesta útil.

Objetivo futuro: poder afirmar con evidencia qué porcentaje de las tareas de MatiOS se resuelve localmente con calidad suficiente y cuánto costo/token/contexto ahorra.

## Principio operativo

> Hugging Face descubre candidatos; el runtime local los ejecuta; MatiOS decide con benchmarks y routing cuál conviene usar.

> No optimizar por costo por llamada: optimizar por costo, calidad, privacidad y resultado útil.

> Local stack modular: engine, serving, UI y media pipelines son capas distintas; no elegir una herramienta para resolver todo.

Última actualización: 2026-09-15.
