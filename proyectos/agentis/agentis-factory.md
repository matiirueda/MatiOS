# Agentis Factory — arquitectura, roles y stack reutilizable

## Objetivo

Construir una fábrica asistida por IA para detectar demanda real, reutilizar componentes existentes, ensamblar automatizaciones/productos, probarlos y convertirlos en templates comercializables.

La prioridad actual NO es construir agentes puros en código desde cero. La prioridad es cubrir rápidamente los casos de uso que el mercado realmente compra usando n8n como orquestador, APIs/SaaS existentes y código JS/Python sólo donde aporte.

> Regla: antes de construir desde cero, buscar si ya existe un repo/template que resuelva 60–80% del problema. Revisar licencia, seguridad, calidad y API oficial; entenderlo, adaptarlo, testearlo y convertirlo en un componente Agentis.

## Estrategia de mercado

1. Radar diario de demanda real en Upwork, Freelancer, Workana y comunidades.
2. Prioridad Argentina, LATAM y español; mercado internacional como segunda vía.
3. Separar cliente final de agencias que subcontratan.
4. Extraer de cada oferta: problema, flujo, stack, presupuesto, competencia y vertical.
5. Convertir patrones repetidos en backlog de templates.
6. Construir primero los templates más frecuentes/reutilizables.
7. Probarlos con canales propios (WhatsApp, Telegram, Calendar, etc.).
8. Publicarlos como demos/casos/servicios.
9. Vender la solución al problema, no la tecnología subyacente.

## Radar de mercado — hallazgos acumulados

### Señales fuertes

- El patrón dominante no es “necesito n8n” sino sistemas completos: lead entra → IA/calificación → CRM → seguimiento → agenda → human handoff → reporting.
- GoHighLevel aparece con mucha más frecuencia que Chatwoot en demanda freelance observada y sigue como CRM prioritario para aprender/comercializar.
- Chatwoot aparece menos, pero en proyectos más técnicos/self-hosted: WhatsApp/Meta omnicanal, IA, human handoff y control de infraestructura/datos.
- En LATAM aparecen Kommo y Bitrix24; Kommo queda como CRM secundario a vigilar especialmente para mercado hispano.
- HubSpot/Pipedrive aparecen como integraciones útiles, pero por ahora no justifican especialización profunda: conviene dominar adapters/API.
- Make/Zapier aparecen como complementos. El core puede seguir siendo n8n; aprender suficiente para integrar/migrar y responder a demanda.
- Python aparece como skill complementaria valiosa para resolver lo que low-code no cubre, pero no es prioridad construir runtimes puros en código en esta etapa.
- WhatsApp + IA + CRM + agenda/seguimiento es una señal especialmente fuerte para LATAM.
- Poca publicación explícita en Argentina no debe interpretarse como falta de mercado: puede ser oportunidad outbound donde el cliente conoce el problema pero no la palabra “automatización”.

### Validación clave: template-first

Se observó demanda explícita de clientes que quieren dejar de construir una automatización desde cero para cada cliente y pasar a un modelo:

`core probado → configuración por cliente → integraciones → testing → deploy`

Esto valida directamente la meta de Agentis de reutilizar 70–90% y parametrizar el resto.

### Voice agents

Retell sube de prioridad por aparición repetida junto con n8n + GHL + booking/CRM. El Voice Receptionist deja de ser una curiosidad futura y pasa a template comercial relevante, pero después del core de booking/lead.

### Content Factory

Apareció demanda de sistemas de contenido con:

`n8n/Make → LLM productor → segundo LLM reviewer → human-in-the-loop → Notion/Kanban → publicación`

Es un template reutilizable y además valida el patrón de dos modelos/agentes con enfoques distintos antes de aprobación humana.

La Content Factory debe poder evolucionar a producción audiovisual completa: research/brief → ángulos/hooks → guion/storyboard → generación de assets → edición/motion → revisión independiente → aprobación humana → variantes/repurposing → publicación → métricas/aprendizaje.

## Templates prioritarios — ranking vivo

1. **AI Lead & Booking Engine** — señal muy alta; reuso estimado 85–90%.
2. **CRM Sales Follow-up** — señal muy alta; reuso 85–90%.
3. **AI Voice Receptionist** — señal alta y creciente; reuso 80–90%.
4. **WhatsApp Support / Sales Agent** — señal alta; reuso 80–90%.
5. **AI Quote & Qualification Agent** — señal media/alta; reuso 75–85%.
6. **AI Content Factory + Reviewer** — señal creciente; reuso 80–90%.
7. **Omnichannel Inbox + human handoff** — Chatwoot encaja especialmente bien; reuso 75–85%.
8. **CRM Automation Core** — transversal; objetivo ~90% reutilizable.
9. **Lead Reactivation** — reuso 85–90%.
10. **Web Research / Scraping Agent** — reuso 70–80%.

### Core compartido deseado

Lead/Booking, Voice y WhatsApp Support no deben ser tres productos independientes. Deben compartir primitives:

`Conversation Engine → Knowledge → Qualification → Calendar → CRM → Follow-up → Human Handoff → Logs`

El canal debe ser intercambiable/configurable:

`WhatsApp | Voice | Web | Telegram`

## Servicios publicables derivados de demanda

### Agentis AI Receptionist
“Responde llamadas/WhatsApp, contesta preguntas, califica clientes, agenda turnos y deriva a tu equipo.”

Implementación interna posible:
`Retell / WhatsApp → n8n → LLM → Calendar → GHL → human handoff`

### Agentis Lead Engine
“Automatizamos tu proceso de leads de punta a punta: formulario/WhatsApp → CRM → calificación → seguimiento → cita.”

La comunicación comercial no debe vender nombres de herramientas: debe vender resultado.

## Componentes reutilizables candidatos

- CRM Adapter (GHL primero; Chatwoot/Kommo/HubSpot/Pipedrive/Bitrix según demanda)
- WhatsApp Adapter
- Telegram Adapter
- Voice Adapter (Retell/Vapi)
- Calendar Adapter
- Browser Operator Adapter (agent-browser)
- Creative Asset Generator Adapter (Higgsfield)
- Video Composition / Rendering Adapter (Remotion)
- LLM Router
- Human Handoff
- Lead Scoring
- Follow-up Engine
- Client Config
- Logging / Audit
- Error Handler / Retry / Idempotency
- Knowledge / RAG Adapter

## Stack comercial actual

### Core
- n8n — orquestación principal.
- APIs/webhooks — habilidad central.
- JavaScript/Python dentro de n8n o servicios auxiliares cuando los nodos no alcancen.

### Prioridad de aprendizaje actual

`n8n → APIs/Webhooks → GHL → WhatsApp Cloud API → OpenAI/Claude → Google Calendar → Supabase/Postgres → Retell → Make/Zapier básico`

### CRM / canales
- GoHighLevel — prioridad comercial por demanda observada.
- Chatwoot — alternativa open-source/self-hosted, especialmente omnicanal/human handoff.
- Kommo — vigilar especialmente en LATAM.
- HubSpot/Pipedrive/Bitrix24 — adapters según cliente/demanda.
- WhatsApp Cloud API — preferencia para producción frente a automatizaciones no oficiales de WhatsApp Web.
- Retell/Vapi — voice layer; Retell sube de prioridad por demanda observada.

### Browser automation
- `vercel-labs/agent-browser` — Browser Operator para casos donde no exista una API adecuada y un agente deba navegar/interactuar con una web como una persona: abrir páginas, leer snapshots semánticos, hacer click, completar formularios, manejar sesiones, screenshots y flujos web.
- Tiene skill utilizable tanto por Claude Code como por Codex, por lo que encaja con la estrategia multi-modelo de Agentis.
- No usar browser automation por defecto cuando exista una API estable/oficial. Prioridad: `API/webhook > integración nativa > browser automation`.
- Usarlo sólo sobre sistemas propios o donde tengamos autorización y respetando permisos/términos del servicio.

### Creative / Content Factory
- Higgsfield Skills — candidato para generación de imágenes/video/assets desde los agentes, sin sacar a Mati del flujo Claude Code/Codex. Integrarlo como herramienta del Creative/Content Engineer y no acoplar la arquitectura a un único modelo visual.
- Remotion Skills — candidato para composición, edición programática, motion graphics, audio/timing y render de video desde Claude Code/Codex.
- Patrón deseado: `brief/research → hooks → script/storyboard → Higgsfield/assets → Remotion/edit → reviewer independiente → Mati HITL → variantes → publish → métricas`.
- Mantener revisión visual/render antes de publicar; la generación automática no implica aprobación automática.

### Datos / conocimiento
- Supabase/Postgres.
- Redis cuando haya estado/colas/locking que lo justifique.
- LightRAG como candidato para Knowledge/RAG cuando el producto necesite consultar conocimiento del cliente.

### Frontend
- Next.js/React cuando un front propio aporte valor.
- 21st.dev — componentes/UI y Agent Elements.
- UI UX Pro Max — skill/recurso candidato para el rol Frontend/UX.

Principio: front liviano + n8n/Supabase detrás cuando alcance. No crear un backend grande por defecto.

## Agentis Dev Team — roles

### Human Product Owner
Matías. Define objetivo, restricciones, prioriza y aprueba decisiones importantes.

### Project Lead
- recibe el objetivo;
- rompe el proyecto en specs/tareas pequeñas;
- coordina agentes;
- mantiene estado/progreso;
- escala sólo decisiones necesarias al humano.

### Process Architect
- entiende el proceso humano actual;
- detecta qué automatizar;
- define estados, excepciones y human-in-the-loop;
- diseña el flujo antes de implementar.

### Research / Reuse Agent
- busca repos, templates, MCPs y componentes existentes;
- compara calidad/licencia/mantenimiento;
- intenta cubrir 60–80% antes de construir desde cero.

### n8n Automation Engineer
- construye/adapta workflows;
- usa n8n MCP cuando resulte adecuado;
- integra APIs, webhooks, CRM, canales y tools;
- usa JS/Python sólo donde aporta.

### Browser Operator
- usa `agent-browser` cuando una tarea requiera interacción real con una interfaz web y no haya una API/integración mejor;
- puede navegar, leer páginas, hacer click, completar formularios, reutilizar sesiones y verificar resultados;
- funciona como “manos y ojos” web de otros agentes, no como reemplazo general de APIs.

### Creative / Content Engineer
- convierte brief/research en assets y piezas audiovisuales siguiendo la estrategia definida por Content Factory;
- usa Higgsfield Skills como capa candidata de generación visual/video;
- usa Remotion Skills para composición/edición/render programático;
- genera variantes y piezas para repurposing;
- entrega renders/assets a un reviewer independiente antes del human-in-the-loop de Mati;
- sirve tanto para UGC de terceros como para publicidad/contenido de Agentis y otros negocios propios.

### Frontend / UX Engineer
- Next.js/React;
- 21st.dev / Agent Elements;
- UI UX Pro Max;
- convierte el backend/orquestación en un producto presentable para el cliente.

### CRM / Integration Engineer
- GHL, Chatwoot, Kommo y otros CRMs;
- Meta/WhatsApp, Calendar, email y APIs de terceros.

### Knowledge Engineer
- LightRAG/RAG;
- ingestión, retrieval y knowledge bases cuando el caso lo necesite.

### Engineer A / Engineer B
Claude Code y Codex deben funcionar como dos empleados con enfoques independientes, no como clones.

Patrones:
- Claude implementa → Codex revisa.
- Codex implementa → Claude revisa.
- Para decisiones importantes: ambos proponen independientemente y Project Lead compara.

Las capacidades se definen por rol, no por proveedor. Si una skill existe sólo para uno, buscar equivalente para el otro o adaptar la metodología.

### Security Engineer
Dos capas complementarias:
- Trail of Bits Skills — revisión de código, configuración, testing y prácticas de seguridad para agentic coding.
- Strix (usestrix/strix) — pentesting dinámico autorizado de nuestros sistemas/sistemas del cliente con permiso.

Regla: ningún template pasa a vendible sin testing + security review proporcional al riesgo.

### QA / Test
- happy paths;
- failure modes;
- retries/idempotencia;
- human handoff;
- tests/evals;
- pruebas end-to-end.

## Herramientas / skills / repos a conservar e investigar

### Agent harness / coordinación
- Everything Claude Code — repo de Affaan Mustafa (`affaan-m/everything-claude-code`). Skills, agents, hooks, rules, MCPs, metodología y soporte multi-harness. Evaluar qué piezas usar en Claude Code y cuáles trasladar/equivaler en Codex.
- Get Shit Done — pendiente identificar URL/repo exacto y comparar con Everything Claude Code para coordinación/project management.
- Repo coordinador de proyectos mencionado por Matías — pendiente identificar.
- Repo “NeoHN” mencionado por Matías — pendiente URL exacta.

### n8n
- n8n MCP — investigar como interfaz para que los agentes entiendan/creen/modifiquen workflows.
- `czlonkowski/n8n-mcp` + `czlonkowski/n8n-skills` como candidatos principales para el n8n Engineer.
- Mantener radar de repos de workflows/templates y seleccionar bases por caso de uso.

### Browser / computer-like web interaction
- `vercel-labs/agent-browser` — candidato principal para Browser Operator. Skill compatible con Claude Code y Codex. Permite interacción web mediante browser real y snapshots/ref-based actions.

### Creative / video
- `higgsfield-ai/skills` — investigar/integrar como skill de generación de assets visuales/video para Claude Code y Codex.
- `remotion-dev/skills` — investigar/integrar como skill de edición/composición/render programático de video para Claude Code y Codex.
- Evaluar pipelines existentes que combinen generación + revisión + Remotion antes de construir uno desde cero.

### RAG
- LightRAG — candidato estándar para Knowledge/RAG cuando sea necesario.

### Front
- UI UX Pro Max.
- 21st.dev.
- 21st.dev Agent Elements.

### Seguridad
- Trail of Bits Skills (`trailofbits/skills`).
- Strix (`usestrix/strix`).

## Pipeline objetivo de Agentis Factory

```text
Demanda freelance / outbound / problema real
                ↓
          Agentis Backlog
                ↓
       Research / Reuse Agent
     (repos/templates existentes)
                ↓
        Process Architect
                ↓
          Project Lead
                ↓
 ┌──────────────┼──────────────┐
 ↓              ↓              ↓
n8n Eng.    CRM/Integr.    Frontend/UX
      ↘       Browser Operator       ↙
          Creative/Content Eng.
                ↓
        Claude Code / Codex
       implementación + peer review
                ↓
          QA / Evals / Tests
                ↓
 Trail of Bits review + Strix cuando aplique
                ↓
       Human-in-the-loop (Mati)
                ↓
        Agentis Template v1
                ↓
 demo + docs + video + landing + pricing
                ↓
       portfolio / freelance / outbound
```

## Estrategia de marca

Marca principal: **Agentis**.

Matías debe ser visible como fundador/constructor para generar confianza, pero el activo comercial se acumula en Agentis y puede escalar a equipo, servicios y productos.

Estructura sugerida:
- Agentis Agency — implementaciones/servicios.
- Agentis Labs — experimentos, demos y templates.
- Agentis Learn/Blog — contenido técnico/comercial.
- Agentis Products — productos que demuestren tracción.

Al inicio, un solo sitio y una sola cuenta principal de Agentis; no fragmentar audiencia en muchas marcas. Los productos se independizan sólo cuando tengan señal real (usuarios, tráfico, leads o ventas).

## Principios

1. n8n es la fábrica/orquestador, no lo que vendemos.
2. Vender resultados de negocio, no nombres de herramientas.
3. Low-code donde alcanza; código donde aporta.
4. Reuse-first: investigar antes de construir.
5. Human-in-the-loop obligatorio en decisiones y releases importantes.
6. Claude Code y Codex se revisan mutuamente y deben conservar diversidad de enfoque.
7. Seguridad y testing forman parte del Definition of Done.
8. Todo componente reutilizable vuelve a la biblioteca Agentis.
9. Muchos experimentos, pocas marcas al principio.
10. La fábrica debe servir para múltiples proyectos/negocios, no sólo para un caso.
11. La demanda freelance funciona también como investigación de producto: cada patrón pagado puede convertirse en template/servicio.
12. Mantener un ranking vivo: frecuencia, presupuesto, competencia, idioma/país, vertical y reusabilidad.
13. Para integración web: preferir API/webhook; usar Browser Operator cuando la interfaz sea realmente la única/mejor vía autorizada.
14. En Content Factory: generación automática ≠ publicación automática; mantener reviewer independiente + human-in-the-loop.

## Próximas decisiones

- [ ] Identificar Get Shit Done exacto.
- [ ] Identificar repo coordinador de proyectos.
- [ ] Identificar repo NeoHN exacto.
- [ ] Comparar Everything Claude Code vs GSD vs coordinador y eliminar redundancias.
- [ ] Investigar n8n MCP y compatibilidad Claude Code/Codex.
- [ ] Crear matriz `rol → skill Claude → skill Codex → herramienta compartida`.
- [ ] Inventariar repos/templates n8n por cada template comercial prioritario.
- [ ] Elegir el conjunto mínimo de herramientas de Agentis Factory v0.1.
- [ ] Levantar Booking/Lead Agent con canales propios y probar end-to-end.
- [ ] Diseñar el core compartido Conversation/Qualification/Calendar/CRM/Handoff/Logs.
- [ ] Evaluar Retell después del primer Booking/Lead core para reutilizarlo como Voice Receptionist.
- [ ] Probar `vercel-labs/agent-browser` con Claude Code y Codex y documentar el Browser Operator SOP.
- [ ] Probar Higgsfield Skills desde Claude Code y Codex para generación de assets.
- [ ] Probar Remotion Skills con un video corto y documentar el ciclo render → revisión → corrección → render final.
- [ ] Diseñar Content Factory v0.1 reutilizable para UGC externo + Agentis + negocios propios.

## Última actualización de mercado

- Fecha: 2026-09-09.
- GHL mantiene prioridad sobre Chatwoot por volumen de demanda observado.
- Retell sube de prioridad por demanda de voice receptionist + n8n + CRM/booking.
- Se valida explícitamente el modelo template-first/configuración por cliente.
- Content Factory + segundo LLM reviewer entra al backlog.
- Próximo objetivo de producto: construir primero el core Lead & Booking y reutilizarlo como base de WhatsApp, Voice y otros verticales.
