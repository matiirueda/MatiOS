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
  - Track de AI Video Ads / UGC.
  - Investigar especialmente character consistency: prompt fijo, reference image y LoRA.

- Open AI UGC — https://github.com/siriokun/ugc
  - Alternativa open-source para generar UGC.
  - Revisar arquitectura, proveedores/modelos y posibilidad de reutilizar código.

- UGC Factory — https://github.com/charlesdove977/UGC-Factory
  - Pipeline/skills para UGC con Claude Code.
  - Revisar character creation, ad structure, style routing, B-roll y stitching con ffmpeg.

- Atlas Marketing Studio — https://github.com/AtlasCloudAI/atlas-marketing-studio
  - Revisar workflows de UGC Product Ad, remake de anuncios, AI Drama y anuncios de dos personas.

- Lazynext — https://github.com/Lazynext-Platform/Lazynext
  - Evaluar arquitectura self-hosted y componentes reutilizables.

- Consistent AI Character Prompts — https://github.com/metrosir/consistent-ai-character-prompts
  - Biblioteca/referencia para consistencia de personajes y uso de LoRA.

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
- Kling / Higgsfield para movimiento o lipsync según caso
- CapCut para prototipo manual
- ffmpeg para automatización

### Orquestación
- n8n primero
- APIs pay-per-use / agregadores cuando convenga
- luego portar los componentes estables a código

## Formación a revisar antes de pagar AvatarHype

1. AI Creator Academy (gratis/open source).
2. AI Creators Lab y tutoriales gratuitos de UGC/character consistency.
3. Cursos Udemy de AI influencer / personajes consistentes / AI UGC. Matías tiene acceso a Udemy mediante el trabajo, por lo que revisar primero si están incluidos en su catálogo corporativo.
4. Recién después evaluar AvatarHype (€75 aprox.) como benchmark/reverse engineering si siguen existiendo huecos concretos.

## Qué queremos extraer de cualquier curso

No mirar pasivamente. Documentar:

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

Para el mismo brief/producto comparar cada workflow por:

- calidad visual;
- realismo humano;
- consistencia del personaje;
- consistencia del producto;
- calidad de voz/lipsync;
- calidad publicitaria del hook/guion;
- tiempo total;
- minutos de intervención humana;
- costo API total;
- facilidad de automatización;
- capacidad de generar variantes.

## Regla de decisión

Si el stack gratuito/open-source llega a ~90% del resultado objetivo con costo y tiempo razonables, no comprar AvatarHype.

Si aparecen huecos específicos difíciles de reproducir (por ejemplo microgestos, identidad consistente, acceso barato a modelos o prompts/workflows particularmente buenos), usar AvatarHype como benchmark pago y extraer únicamente el conocimiento que falte.

## Encaje con MatiOS

Este experimento forma parte del proyecto Content Factory. El objetivo final no es solo generar avatares: es construir infraestructura reutilizable para UGC de terceros, Agentis, cuadros, página tech y futuros negocios.

Arquitectura objetivo de agentes: Research Agent → Creative Strategist → Hook Agent → Script Writer → Production Director → Video/Editing Agent → Repurposing Agent → Publishing Agent → Performance Agent, siempre con human-in-the-loop.
