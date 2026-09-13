# Content Factory — AvatarHype Benchmark

Fecha: 2026-09-13

## Objetivo

No comprar formación/herramientas cerradas antes de comprobar cuánto del workflow podemos reproducir con recursos gratuitos, open source y herramientas ya disponibles.

Primer challenge: reproducir un anuncio UGC del nivel de AvatarHype y medir calidad, consistencia, tiempo de producción y costo real por anuncio.

## Benchmark

Pipeline a probar:

producto/brief → research → ángulos → hooks → guion → character sheet → personaje consistente → escenas → voz/lipsync → B-roll/producto → edición → variantes → publicación → métricas → aprendizaje

### Recursos / repos para estudiar

- AI Creator Academy — https://github.com/Anil-matcha/ai-creator-academy
- Open AI UGC — https://github.com/siriokun/ugc
- UGC Factory — https://github.com/charlesdove977/UGC-Factory
- Atlas Marketing Studio — https://github.com/AtlasCloudAI/atlas-marketing-studio
- Lazynext — https://github.com/Lazynext-Platform/Lazynext
- Consistent AI Character Prompts — https://github.com/metrosir/consistent-ai-character-prompts

## Herramientas/modelos a comparar

### Imagen / identidad
- Gemini / Nano Banana
- Seedream
- Flux / Stable Diffusion + LoRA
- ComfyUI
- Higgsfield

### Video
- Seedance
- Kling
- Veo
- Sora
- Wan

### Voz / lipsync / edición
- ElevenLabs
- Kling / Higgsfield
- CapCut para prototipo manual
- ffmpeg / Remotion para automatización

### Orquestación
- n8n primero
- APIs pay-per-use / agregadores cuando convenga
- luego portar componentes estables a código

## Formación antes de pagar AvatarHype

1. AI Creator Academy.
2. AI Creators Lab y tutoriales gratuitos.
3. Cursos Udemy de AI influencer / personajes consistentes / AI UGC disponibles mediante el trabajo.
4. Recién después evaluar AvatarHype si quedan huecos concretos.

## Selfhost-AI como MatiOS Runtime — CANDIDATO / TEST ALTA PRIORIDAD

Repo: https://github.com/kossakovsky/selfhost-ai

Idea: dejar de pensar MatiOS únicamente como repositorio y separar **cerebro** de **runtime**.

### Arquitectura conceptual

- **MatiOS Core:** GitHub + conocimiento + principios + proyectos + skills/agentes.
- **MatiOS Runtime:** Selfhost-AI como base candidata de infraestructura local/self-hosted.
- **Orquestación:** n8n.
- **Inteligencia local:** Ollama.
- **Research:** Crawl4AI; evaluar SearXNG cuando exista caso concreto.
- **Generación visual:** ComfyUI.
- **Datos:** Postgres inicialmente.
- **Video:** Remotion + ffmpeg + modelos generativos externos/locales.
- **Integraciones:** WhatsApp, GHL, APIs, modelos frontier y servicios externos.

### MatiOS AI Lab v1

No desplegar todos los servicios disponibles. Primer stack mínimo:

Caddy / infraestructura → n8n → Ollama + Crawl4AI + ComfyUI → Postgres/Redis donde sean necesarios.

Agregar Remotion como capa de composición de video.

Qdrant, Supabase, Grafana, Flowise, SearXNG, etc. solo cuando un caso real los justifique.

### Primer experimento end-to-end

**Content Factory v0.1 / AvatarHype Challenge**

URL/producto → Crawl4AI → Research Agent → ángulos/hooks/guion → ComfyUI/assets → modelo de video → Remotion → anuncio UGC final.

Después extender:

publicación → métricas → Performance Agent → aprendizaje → nueva iteración.

### Segundo caso transversal: Agentis

WhatsApp/audio → n8n → STT → agente → Postgres/inventario → detección stock mínimo → propuesta de pedido → human-in-the-loop → WhatsApp proveedor.

Usar Ollama para tareas locales/baratas cuando tenga calidad suficiente y modelos frontier cuando aporten valor real.

### Principios de adopción

- ADOPT como base candidata de laboratorio; NO adoptar todavía para producción.
- No instalar servicios por disponibilidad: cada servicio necesita caso real.
- Mantener personalizaciones mediante configuración/overrides para facilitar upgrades.
- Revisar seguridad, puertos, secretos, autenticación y exposición pública antes de producción.
- Priorizar componentes reutilizables entre Content Factory, Agentis, cuadros, página tech y futuros negocios.
- Diseñar para que Codex y Claude Code puedan trabajar sobre GitHub/n8n/infraestructura y reutilizar skills/patrones.

### Criterio de éxito del spike

Si logramos `URL → Crawl4AI → Research Agent → guion → ComfyUI → assets`, ya validamos una parte sustancial de Content Factory sobre la infraestructura.

El siguiente milestone es agregar Remotion/modelo de video y conseguir `URL → research → creativo → assets → video final` con métricas de costo, tiempo, calidad e intervención humana.

## Qué queremos extraer de cualquier curso/workflow

- modelo/proveedor usado en cada etapa;
- prompt completo o estructura de prompt;
- character sheet / identidad multiángulo;
- seeds, referencias, LoRA u otra técnica de consistencia;
- dirección de microgestos y naturalidad UGC;
- lipsync;
- generación de B-roll/product shots;
- edición/stitching;
- costo por clip y por anuncio;
- tiempo humano requerido;
- qué partes pueden convertirse en agentes/skills;
- qué partes pueden automatizarse con n8n;
- qué vale la pena portar a código.

## Métricas del AvatarHype Challenge

Para el mismo brief/producto comparar cada workflow por calidad visual, realismo humano, consistencia del personaje/producto, voz/lipsync, hook/guion, tiempo total, intervención humana, costo API, facilidad de automatización y capacidad de generar variantes.

## Regla de decisión

Si el stack gratuito/open-source llega a ~90% del resultado objetivo con costo y tiempo razonables, no comprar AvatarHype. Si aparecen huecos específicos difíciles de reproducir, usar AvatarHype como benchmark pago y extraer únicamente el conocimiento que falte.

## Encaje con MatiOS

Content Factory debe ser infraestructura reutilizable para UGC de terceros, Agentis, cuadros, página tech y futuros negocios.

Arquitectura objetivo de agentes: Research Agent → Creative Strategist → Hook Agent → Script Writer → Production Director → Video/Editing Agent → Repurposing Agent → Publishing Agent → Performance Agent, siempre con human-in-the-loop.
