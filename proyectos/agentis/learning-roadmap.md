# Agentis — AI Engineering Learning Roadmap

## Objetivo

Aprender IA aplicada y agentes de producción construyendo proyectos reales, primero de la forma más rápida posible y luego reimplementando las partes importantes en código.

La meta no es ser "especialista en n8n" ni "especialista en un framework". La meta es poder recibir un proceso de negocio, decidir qué conviene automatizar con workflows determinísticos, qué necesita IA, qué merece un agente, cómo integrarlo y cómo llevarlo a producción con métricas, observabilidad y seguridad.

## Regla de trabajo

- 1 hora por día.
- Continuar siempre desde la última tarea marcada.
- Evitar saltar de proyecto antes de terminar el mínimo funcional del actual.
- Construir primero una versión rápida y utilizable.
- Repetir luego el mismo problema en código para aprender arquitectura, testing y producción.
- Documentar qué resolvió mejor n8n, qué resolvió mejor código y qué debe quedar híbrido.
- Todo aprendizaje reutilizable vuelve a MatiOS/Agentis como conocimiento o primitive.

## Filosofía de arquitectura

> Resolver rápido primero. Entender profundamente después. Convertir lo repetible en producto.

### n8n gana cuando

- el flujo es simple y secuencial;
- hay muchas integraciones SaaS;
- necesitamos llegar rápido a una demo o MVP;
- la lógica es visible y fácil de mantener como workflow.

### Código gana cuando

- hay estado complejo;
- loops o planificación;
- múltiples tools;
- concurrencia;
- lógica de negocio compleja;
- evals y testing profundos;
- retries avanzados;
- idempotencia;
- observabilidad propia;
- alto volumen o necesidad de producto reutilizable.

### Arquitectura objetivo

```text
Canales / Apps
WhatsApp · Web · Instagram · CRM · Ecommerce
                  │
                  ▼
          Automation Layer
                 n8n
                  │
                  ▼
            Agent Runtime
        Python / TypeScript
  LangGraph / PydanticAI / similar
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
      Tools      Data     Workers
                Postgres   Queue
                pgvector   Redis
```

n8n no desaparece: se convierte en la capa de automatización e integración alrededor de agentes construidos en código cuando haga falta.

---

# Roadmap de proyectos

## Proyecto 1 — Booking Agent

Aprendizajes principales:

- n8n
- webhooks
- APIs
- structured outputs
- tool calling
- Postgres
- estado conversacional
- idempotencia
- FastAPI
- Pydantic
- agent runtime básico
- comparación n8n vs código

Resultado esperado:

Un agente que pueda interpretar una solicitud de reserva, consultar disponibilidad, ofrecer horarios, mantener contexto, confirmar una opción y crear la reserva sin duplicados.

## Proyecto 2 — Sales Agent

Aprendizajes:

- CRM
- lead qualification
- RAG
- memoria
- follow-ups
- scoring
- structured outputs
- pipelines comerciales

## Proyecto 3 — Support Agent

Aprendizajes:

- evals
- guardrails
- confidence / escalation
- human-in-the-loop
- clasificación de problemas
- knowledge retrieval
- auditoría de acciones

## Proyecto 4 — Research / Operations Agent

Aprendizajes:

- tools en paralelo
- long-running jobs
- workers
- queues
- retries
- planificación
- observabilidad

## Proyecto 5 — Multi-Agent System

Aprendizajes:

- planner
- researcher
- executor
- reviewer
- coordinación entre agentes
- responsabilidades separadas
- evaluación end-to-end

---

# Proyecto 1 — Booking Agent

## Caso de uso inicial

Negocio de reservas — pensado para poder reutilizar luego el mismo primitive en canchas, centros médicos, clases, turnos, servicios o cualquier negocio basado en slots.

### Conversación objetivo

```text
Usuario: "¿El sábado después de las 8 tenés algo?"

Agent
→ interpreta la fecha
→ interpreta >20:00
→ consulta disponibilidad
→ ofrece 20:30 / 22:00

Usuario: "20:30 dale"

Agent
→ recuerda el contexto
→ valida el slot
→ crea la reserva una sola vez
→ confirma
```

## Definition of Done — V1 n8n

- recibe mensajes por webhook;
- interpreta intención y datos de reserva;
- consulta disponibilidad;
- ofrece slots;
- mantiene contexto suficiente entre mensajes;
- crea la reserva;
- evita reservas duplicadas;
- registra la operación;
- puede escalar a humano cuando no puede resolver;
- el flujo completo puede probarse end-to-end.

## Definition of Done — V2 code

- API propia con FastAPI;
- modelos tipados con Pydantic;
- tools explícitas;
- estado conversacional propio;
- persistencia en Postgres;
- idempotencia;
- tests;
- eval set básico;
- logs suficientes para reconstruir qué ocurrió;
- n8n pasa a actuar principalmente como integrador/orquestador externo.

---

# Plan de ejecución — sesiones de 1 hora

## Fase 0 — Diseño mínimo

### Sesión 1 — Definir el problema

- [ ] Elegir el dominio inicial del Booking Agent.
- [ ] Escribir el workflow humano actual en 5–10 pasos.
- [ ] Definir qué acción exacta automatiza la V1.
- [ ] Definir qué queda fuera de alcance.
- [ ] Definir 3 métricas: una técnica, una operativa y una de negocio.
- [ ] Escribir 10 conversaciones de ejemplo reales o sintéticas.

**Entregable:** `proyectos/agentis/booking-agent/spec.md`

### Sesión 2 — Modelo de datos

- [ ] Definir entidades mínimas: customer, resource, slot, booking, conversation.
- [ ] Diseñar tablas Postgres.
- [ ] Definir estados de booking.
- [ ] Definir una `idempotency_key`.
- [ ] Definir qué datos son persistentes y qué datos son temporales.

**Entregable:** esquema inicial de datos.

---

# Fase 1 — V1 en n8n

### Sesión 3 — Webhook + mensaje entrante

- [ ] Crear workflow n8n.
- [ ] Crear webhook de entrada.
- [ ] Normalizar payload del mensaje.
- [ ] Guardar request inicial en logs o Postgres.
- [ ] Responder un mensaje fijo end-to-end.

**Meta:** comprobar entrada y salida antes de agregar IA.

### Sesión 4 — Structured output

- [ ] Conectar LLM.
- [ ] Definir schema de salida estructurada.
- [ ] Extraer intención.
- [ ] Extraer fecha/hora.
- [ ] Extraer cantidad de personas o recurso si aplica.
- [ ] Probar 10 mensajes distintos.

### Sesión 5 — Tool: disponibilidad

- [ ] Crear fuente de disponibilidad.
- [ ] Implementar `get_availability`.
- [ ] Filtrar slots según pedido del usuario.
- [ ] Devolver opciones claras.
- [ ] Probar cuando no hay disponibilidad.

### Sesión 6 — Estado conversacional

- [ ] Persistir conversation/session id.
- [ ] Guardar slots ofrecidos.
- [ ] Permitir respuesta corta como "20:30 dale".
- [ ] Reconstruir contexto desde DB.
- [ ] Probar conversación de 3+ turnos.

### Sesión 7 — Crear reserva

- [ ] Implementar `create_booking`.
- [ ] Validar nuevamente disponibilidad antes de escribir.
- [ ] Guardar booking.
- [ ] Confirmar al usuario.
- [ ] Registrar tool result.

### Sesión 8 — Idempotencia

- [ ] Crear `idempotency_key`.
- [ ] Impedir doble booking ante retry.
- [ ] Simular timeout y reintento.
- [ ] Verificar que haya una sola reserva.

### Sesión 9 — Fallos y humano

- [ ] Definir 5 failure modes.
- [ ] Manejar input ambiguo.
- [ ] Manejar tool error.
- [ ] Manejar slot perdido durante la conversación.
- [ ] Crear `escalate_to_human`.

### Sesión 10 — V1 end-to-end

- [ ] Correr las 10 conversaciones iniciales.
- [ ] Registrar cuáles fallan.
- [ ] Corregir errores críticos.
- [ ] Medir tiempo/respuesta y success rate básico.
- [ ] Congelar V1.

**Milestone:** Booking Agent funcional en n8n.

---

# Fase 2 — Rehacer el cerebro en código

### Sesión 11 — API mínima

- [ ] Crear proyecto Python.
- [ ] Crear FastAPI.
- [ ] Crear endpoint `/agent/run`.
- [ ] Recibir input tipado.
- [ ] Devolver output tipado.
- [ ] Dockerizar servicio.

### Sesión 12 — Modelos Pydantic

- [ ] Crear `BookingRequest`.
- [ ] Crear `BookingState`.
- [ ] Crear `AvailabilityResult`.
- [ ] Crear `BookingResult`.
- [ ] Validar inputs inválidos.

### Sesión 13 — Tools en código

- [ ] Implementar `get_availability()`.
- [ ] Implementar `create_booking()`.
- [ ] Implementar `escalate_to_human()`.
- [ ] Crear contratos tipados.
- [ ] Probar tools sin LLM.

### Sesión 14 — Agent runtime

- [ ] Integrar un framework de agentes adecuado.
- [ ] Conectar structured output.
- [ ] Exponer tools.
- [ ] Ejecutar conversación simple.
- [ ] Comparar comportamiento con n8n.

### Sesión 15 — Estado + Postgres

- [ ] Persistir conversation state.
- [ ] Recuperar estado por conversación.
- [ ] Persistir tool calls importantes.
- [ ] Probar restart del servicio sin perder contexto.

### Sesión 16 — Idempotencia en código

- [ ] Implementar idempotency key.
- [ ] Agregar constraint en DB.
- [ ] Simular retry concurrente.
- [ ] Validar una sola escritura.

### Sesión 17 — Tests

- [ ] Unit test de disponibilidad.
- [ ] Unit test de creación.
- [ ] Test de idempotencia.
- [ ] Test de conversación multi-turn.
- [ ] Test de fallo de tool.

### Sesión 18 — Evals

- [ ] Convertir las conversaciones iniciales en eval cases.
- [ ] Definir expected intent.
- [ ] Definir tools permitidas/esperadas.
- [ ] Definir acciones prohibidas.
- [ ] Ejecutar eval suite.

### Sesión 19 — Observabilidad

- [ ] Loggear request id.
- [ ] Loggear conversation id.
- [ ] Loggear tools ejecutadas.
- [ ] Loggear latencia.
- [ ] Poder reconstruir una ejecución fallida.

### Sesión 20 — Integración n8n + código

- [ ] n8n recibe evento.
- [ ] n8n llama `POST /agent/run`.
- [ ] agent runtime resuelve el cerebro.
- [ ] n8n entrega respuesta al canal.
- [ ] Verificar flujo completo.

**Milestone:** arquitectura híbrida n8n + Agent Runtime.

---

# Fase 3 — Deploy y producción

### Sesión 21 — Railway dev

- [ ] Crear/desplegar Agent API.
- [ ] Conectar Postgres.
- [ ] Configurar variables de entorno.
- [ ] Configurar networking privado cuando aplique.
- [ ] Probar healthcheck.

### Sesión 22 — CI/CD

- [ ] Vincular repo.
- [ ] Deploy automático desde rama adecuada.
- [ ] Ejecutar tests antes de promoción.
- [ ] Definir rollback básico.

### Sesión 23 — Seguridad mínima

- [ ] Revisar secrets.
- [ ] Proteger endpoints internos.
- [ ] Validar payloads.
- [ ] Limitar acciones riesgosas.
- [ ] Documentar permisos de cada tool.

### Sesión 24 — Cierre del proyecto

- [ ] Comparar n8n vs code.
- [ ] Documentar qué se queda en cada capa.
- [ ] Registrar aprendizajes.
- [ ] Registrar fallos repetibles.
- [ ] Extraer primitives reutilizables.
- [ ] Crear backlog del Proyecto 2.

---

# Comparativa obligatoria al finalizar cada proyecto

| Pregunta | Respuesta |
|---|---|
| ¿Qué fue más rápido en n8n? | Pendiente |
| ¿Qué fue más limpio en código? | Pendiente |
| ¿Qué fue más fácil de testear? | Pendiente |
| ¿Qué fue más fácil de observar/debuggear? | Pendiente |
| ¿Qué debería quedar en n8n? | Pendiente |
| ¿Qué debería vivir en Agent Runtime? | Pendiente |
| ¿Qué primitive podemos reutilizar? | Pendiente |
| ¿Qué aprendimos que debe volverse conocimiento? | Pendiente |

---

# Primitives candidatas

A medida que aparezcan en proyectos reales, evaluar convertirlas en componentes reutilizables:

- `HumanApprovalTool`
- `EscalateToHumanTool`
- `BookingTool`
- `AvailabilityTool`
- `IdempotentAction`
- `ConversationState`
- `AuditLog`
- `EvalCase`
- `RetryPolicy`
- `StructuredOutputContract`

---

# Disciplina de avance

Cada día:

1. abrir esta página;
2. buscar la primera tarea sin marcar;
3. trabajar solo sobre esa sesión durante la hora disponible;
4. marcar lo terminado;
5. dejar una línea de `Último avance`;
6. el próximo día continuar desde ahí.

No hace falta terminar una sesión por día. Si una sesión ocupa 3 días, se continúa desde la última casilla marcada.

## Último avance

- Fecha: 2026-08-24
- Estado: roadmap creado.
- Próximo paso: **Proyecto 1 · Sesión 1 — Definir el problema.**
