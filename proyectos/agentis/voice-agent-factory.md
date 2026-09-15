# Agentis — Voice Agent Factory

## Objetivo

Formalizar la arquitectura de agentes de voz para Agentis y evitar pensar que “el voice agent” es una sola caja. Voz en producción es una cadena de capas con latencia, fallos y métricas propias.

Principio:

> Un agente de voz no falla sólo por el LLM. Puede fallar antes de que el modelo vea un token.

## Arquitectura base

```text
Usuario
  ↓
Telephony/WebRTC/WebSocket transport
  ↓
Audio chunking + jitter/buffering
  ↓
VAD / turn detection
  ↓
STT
  ↓
Agent Runtime
  ├── Retrieval
  ├── Tool Calling
  ├── Memory
  ├── Business Rules / Guardrails
  └── Human Handoff
  ↓
LLM / Realtime model
  ↓
TTS
  ↓
Audio output
```

Infra transversal:

```text
Auth/AuthZ
Session Store
Queue/Stream/Event Bus cuando haga falta
Observability/Tracing/Metrics
Monitoring/Alerts
Retries/Fallbacks
Rate limits
CI/CD/Deploy
Secrets
Audit logs
```

## VAD y turn detection son producto, no detalle

El VAD/turn detector decide cuándo el usuario realmente terminó de hablar.

Si corta temprano:
- interrumpe frases;
- genera falsas intenciones;
- llama tools antes de tiempo.

Si espera demasiado:
- aumenta latencia percibida;
- la conversación se siente como IVR viejo;
- baja naturalidad.

Por eso medir explícitamente:
- speech_end_detection_ms;
- false cut rate;
- interruption/barge-in success;
- silence timeout;
- end-of-turn latency.

No usar una configuración única para todos los verticales sin medir. Un turno en reservas puede ser corto; una explicación médica/comercial puede requerir más tolerancia de silencio.

## Repos/frameworks investigados

### LiveKit Agents — prioridad muy alta

Repos: `livekit/livekit` + `livekit/agents`

Aporta infraestructura realtime/WebRTC y un framework code-first para voice agents en Python/Node. Ya separa STT, LLM, TTS, turn handling, tools, telephony, MCP, telemetry y fallback.

Tiene ejemplos de:
- voice agents básicos;
- RAG;
- MCP;
- OpenTelemetry;
- métricas;
- modelos realtime;
- turn detection.

Decisión Agentis: **benchmark prioritario**. Muy alineado con una arquitectura seria y modular.

### Pipecat — prioridad muy alta

Repo: `pipecat-ai/pipecat`

Framework open source Python para voice/multimodal realtime basado en pipelines/frames. Soporta transports, múltiples STT/LLM/TTS, function calling, realtime APIs, persistent context y multi-agent/subagents.

Su repo incluye behavioral evals y ejemplos para distintos transports/proveedores.

Decisión Agentis: **benchmark prioritario junto a LiveKit**. Puede encajar especialmente bien con nuestra preferencia por piezas pequeñas, pipelines y adapters.

### Pipecat MCP/skills — radar alto

Repo: `pipecat-ai/pipecat-mcp-server` y ecosistema de skills.

Interesante porque permite conversar por voz con agentes de desarrollo y controlar acciones con confirmaciones verbales. No es el core de nuestro customer-facing voice stack, pero sirve como referencia de voice + MCP + permissions/HITL.

### Silero VAD — prioridad alta como componente local

Repo: `snakers4/silero-vad`

VAD preentrenado disponible vía ONNX/PyTorch y adecuado para realtime.

Decisión Agentis: **benchmarkear como detector local**. Compararlo con turn detection del framework/proveedor; no asumir que VAD puro resuelve semántica de fin de turno.

### whisper.cpp — prioridad alta para STT local

Repo: `ggml-org/whisper.cpp`

STT local/offline con soporte CPU/GPU/Apple Silicon, quantization y VAD.

Decisión Agentis: benchmark en español rioplatense con audios reales y ruido/telefonía. Útil para privacidad/costo, pero producción depende de calidad + streaming latency.

## Retell y proveedores administrados

Retell sigue siendo un adapter prioritario por demanda de mercado y velocidad de salida.

La Voice Factory no debe casarse con un proveedor:

```text
Voice Core
  ├── Retell Adapter
  ├── LiveKit Adapter
  ├── Pipecat Adapter
  ├── STT Adapter
  ├── TTS Adapter
  └── Telephony Adapter
```

Estrategia:
- usar Retell para llegar rápido al mercado cuando resuelva el caso;
- aprender la arquitectura interna con LiveKit/Pipecat;
- extraer componentes propios sólo cuando exista una ventaja medible.

## Pipeline STT + LLM + TTS vs speech-to-speech realtime

Mantener ambas rutas como capacidades distintas.

### Pipeline modular

`audio → VAD → STT → agent/tools/RAG → LLM → TTS`

Ventajas:
- máxima observabilidad;
- proveedores reemplazables;
- texto intermedio útil para logs, CRM y compliance;
- fácil integrar knowledge/tools.

Costo:
- más etapas;
- más puntos de latencia/fallo.

### Realtime speech-to-speech

`audio → realtime multimodal model → audio`

Ventajas:
- potencialmente menor latencia y mayor naturalidad.

Costo:
- menos control según proveedor;
- tool/retrieval/memory siguen existiendo aunque no se vean;
- observabilidad y portability pueden ser peores.

No elegir por moda: benchmark por caso.

## Métricas obligatorias por turno

Registrar cuando sea posible:
- call/session ID;
- transport/provider;
- VAD/turn model/version;
- STT provider/model + confidence;
- transcription latency;
- retrieval latency;
- tool call latency + success;
- memory lookup latency;
- LLM/model + TTFT;
- TTS provider/model + time-to-first-audio;
- end-to-end response latency;
- interruptions/barge-ins;
- retries/fallbacks;
- handoff humano;
- hangup/drop reason;
- token/API/voice cost;
- business outcome: booking, lead qualified, resolution, sale, etc.

Principio:

> Optimizar por conversación útil y resultado de negocio, no sólo por latencia del LLM.

## Fallbacks

Ejemplos:
- STT falla → retry/secondary STT;
- retrieval lento → responder sin retrieval sólo si la política lo permite;
- tool crítica falla → no inventar éxito; informar y/o handoff;
- TTS falla → secondary TTS;
- LLM timeout → fallback model;
- confidence baja → repreguntar;
- múltiples errores → human handoff.

## Benchmark recomendado

Crear un set de conversaciones reales/simuladas en español argentino:
- reserva simple;
- interrupción mientras el agente habla;
- usuario habla lento con pausas;
- ruido de calle;
- número/documento/nombre propio;
- pregunta que requiere knowledge;
- tool call de calendario;
- tool falla;
- cambio de intención a mitad de turno;
- pedido de humano.

Comparar al menos:

```text
Retell
LiveKit Agents
Pipecat
```

Y componentes locales cuando aplique:

```text
Silero VAD / turn detection
whisper.cpp / cloud STT
local LLM / cloud LLM
local/cloud TTS
```

Medir latencia por capa, calidad de transcripción, turn accuracy, tool success, naturalidad, costo y resultado de negocio.

## Roadmap

No construir telecom/realtime infra propia desde cero al inicio.

1. Primer voice template con Retell + n8n/GHL/Calendar.
2. Instrumentar métricas por capa y fallos.
3. Reproducir el mismo caso con LiveKit y Pipecat como laboratorio.
4. Comparar costo/calidad/latencia/control.
5. Introducir STT/VAD/LLM local sólo donde el benchmark muestre valor.
6. Convertir Voice Core en adapters reutilizables por vertical.

## Principios

1. Voice Agent = pipeline de capas, no un prompt.
2. VAD/turn detection es una decisión de UX/producto.
3. Retrieval, tools y memory son capas separadas.
4. Infra/observability es parte del producto.
5. Adapter/proveedor intercambiable > lock-in.
6. Local no significa automáticamente mejor ni más barato: medir end-to-end.
7. Human handoff es una feature central, no un parche.
8. Cada capa debe tener métricas y fallback.
9. Benchmark con español/telefonía/casos reales del vertical.
10. Optimizar por resultado útil de negocio.

Última actualización: 2026-09-15.
