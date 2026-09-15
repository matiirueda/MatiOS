# Agent Runtime Comparison — Hermes vs ZeroClaw vs nanobot vs IronClaw vs PicoClaw

> Fecha: 2026-09-15  
> Objetivo: elegir runtimes por caso de uso, no por hype. Basado en repos/documentación primaria consultados en esta fecha.

## Resumen

No hay un ganador universal. Para MatiOS/Agentis conviene separar dos necesidades:

1. **runtime de referencia para diseñar empleados durables y distribuibles**;
2. **runtime de producción por cliente/entorno**, que puede variar según costo, seguridad, hardware y mantenibilidad.

Hoy, Hermes es el candidato más interesante como **laboratorio de diseño de empleados** por su combinación de memoria, skills, cron, perfiles distribuibles, MCP y delegación. ZeroClaw e IronClaw son especialmente interesantes para estudiar **enforcement de seguridad**. nanobot es atractivo como runtime Python legible e integrable. PicoClaw tiene valor para edge/hardware limitado.

## Matriz resumida

| Runtime | Lenguaje | Fortalezas verificadas | Riesgo/limitación para nosotros | Decisión |
|---|---|---|---|---|
| Hermes Agent | Python (+ componentes Node) | skills estándar, cron durable, perfiles distribuibles, MCP, memoria, delegación, múltiples sandboxes/canales | superficie amplia; hay que auditar permisos y madurez antes de producción cliente | TEST P0 |
| ZeroClaw | Rust | runtime pequeño, autonomía ReadOnly/Supervised/Full, allowlists, path isolation, rate/cost limits, MCP/channels | ecosistema más joven; no asumir claims de footprint sin medir | STUDY/TEST P1 |
| nanobot | Python | core legible, SDK Python, OpenAI-compatible API, memory, MCP, routing, delegation, cron, Langfuse | menos enfocado a packaging de profiles que Hermes | TEST P1 |
| IronClaw | Rust + WASM | sandbox WASM capability-based, credential injection host-side, endpoint allowlisting, leak detection, resource limits, prompt-injection defenses | más complejidad operacional; algunos issues muestran edge cases reales en credential injection | STUDY SECURITY P1 |
| PicoClaw | Go | <10MB target, edge, MCP, skills, cron, routing, hooks/approvals, async/subagents | no necesitamos edge hoy | WATCH P2 |

## Hermes — por qué encaja con Employee Pack

Capacidades primarias verificadas:

- skills compatibles con agentskills.io;
- cron con skills/model/workdir/toolsets;
- profile distributions;
- separación distribution-owned vs user-owned;
- MCP nativo;
- subagentes aislados;
- múltiples canales;
- context files (`AGENTS.md`, `CLAUDE.md`, `SOUL.md`, etc.);
- sandboxes/local/Docker/SSH/Daytona/Modal/etc.

Lo más valioso para MatiOS no es usar Hermes para siempre, sino copiar su **modelo de packaging**.

## ZeroClaw — seguridad pragmática

Documentación primaria declara perfiles de autonomía:

- ReadOnly;
- Supervised (default);
- Full.

Y capas como:

- aislamiento de workspace;
- bloqueo de path traversal;
- allowlist de comandos;
- paths prohibidos;
- rate limiting;
- costo máximo por día;
- perfiles de runtime/riesgo;
- tool receipts con evidencia HMAC.

### Idea a copiar

Un Employee Pack debería declarar un `risk_profile`, y la plataforma debería imponer capacidades reales derivadas de ese perfil.

Ejemplo:

```yaml
risk_profile: supervised
filesystem:
  roots: ["/workspace/customer-123"]
shell:
  allowed: false
network:
  hosts: ["api.agentis.internal"]
limits:
  actions_per_hour: 100
  daily_llm_usd: 3.00
```

## nanobot — candidato fuerte para integración Python

Repo oficial confirma:

- framework Python self-hosted;
- tools, memory, MCP;
- model routing;
- multi-agent delegation;
- scheduled automation;
- WebUI/chat channels;
- SDK Python;
- API compatible con OpenAI;
- observabilidad vía Langfuse configurable.

### Por qué nos interesa

Para Agentis escrito mayormente en Python, poder ejecutar el mismo runtime como librería puede simplificar testing/evals mucho más que operar siempre un gateway externo.

Posible uso:

```python
Agentis backend
  -> nanobot SDK
  -> structured run result
  -> our Tool Gateway
```

Testearlo contra Hermes con tareas idénticas.

## IronClaw — fuente de ideas de enforcement

El repo oficial documenta:

- tools no confiables dentro de WASM;
- permissions por capacidad;
- endpoint allowlist;
- credenciales inyectadas en host boundary;
- leak detection request/response;
- rate/resource limits;
- políticas de prompt injection;
- sandbox Docker por job;
- orchestrator/worker.

### Idea a copiar

**Secret injection at execution boundary.**

El agente/tool no recibe la key real; pide una capability y el host completa la autenticación al ejecutar.

Eso debería influir directamente en Agentis Tool Gateway.

### Nota importante

Encontramos issues públicos donde credential injection falló en un entorno TEE específico. Eso es útil: incluso una arquitectura segura en diseño necesita tests de integración, observabilidad y fail-closed. No confiar en la promesa del framework.

## PicoClaw — edge y hooks

Repo oficial confirma:

- Go;
- MCP;
- skills;
- cron;
- routing/model lists;
- async/spawn/subagent;
- hooks/interceptors/approval hooks;
- targeting de hardware muy barato y baja memoria.

Hoy no es core para Agentis, pero puede ser relevante a futuro si hacemos:

- cajas locales en comercios;
- kioscos;
- edge/offline;
- sensores/IoT;
- pequeñas appliances Agentis.

## Benchmark que deberíamos construir

No comparar por stars/RAM declarada. Ejecutar exactamente el mismo set:

### Tasks
1. leer 5 docs y responder con evidencia;
2. actualizar un repo pequeño;
3. ejecutar tool permitida;
4. intentar tool prohibida;
5. prompt injection dentro de contenido web;
6. schedule recurrente;
7. crash/restart y continuar;
8. delegar 3 subtareas;
9. costo/token tracking;
10. cambiar modelo sin perder employee state.

### Medidas

- task success;
- policy violations;
- setup time;
- RAM idle/load;
- cold start;
- tokens/task;
- latency;
- recovery after failure;
- observability quality;
- code complexity to extend;
- portability of skills;
- operational burden.

## Decisión actual

**Hermes = primer runtime a probar.**

No porque sea “el mejor”, sino porque nos permite aprender rápidamente sobre las piezas que queremos definir en Employee Pack.

En paralelo:

- estudiar ZeroClaw para risk profiles/tool receipts;
- estudiar IronClaw para sandbox/credential boundary;
- probar nanobot como opción Python embebible;
- dejar PicoClaw para edge.

La arquitectura de Agentis debe mantener adapters para que esta decisión sea reversible.

## Fuentes primarias

- `https://github.com/NousResearch/hermes-agent`
- `https://github.com/zeroclaw-labs/zeroclaw`
- `https://github.com/HKUDS/nanobot`
- `https://github.com/nearai/ironclaw`
- `https://github.com/sipeed/picoclaw`
