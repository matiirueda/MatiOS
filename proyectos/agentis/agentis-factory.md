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

La validación más reciente refuerza además un requisito concreto del producto: prompts, thresholds, tiempos, textos, campos y reglas deben poder centralizarse en una capa `Client Config`, de modo que un cliente nuevo requiera principalmente configuración + credenciales + adapters y no cambios en la lógica central.

### Lead & Booking — PRD de mercado para v1

El patrón funcional a usar como criterio de aceptación de la primera versión queda:

`Lead source → webhook → normalize/dedupe → AI qualification → CRM Adapter → human approval → follow-up → Calendar → meeting brief → logs/retries`

La configuración por cliente debe separar al menos:

`prompts + scoring/thresholds + timings + CRM fields/stages + messages + channel rules + credentials/secrets references`

Los secretos no deben vivir embebidos en el workflow exportable; la configuración debe referenciarlos mediante el mecanismo seguro del entorno.

Objetivo: poder verticalizar Real Estate, Legal, Home Services, clínicas u otros sectores principalmente mediante `Client Config + adapters`, sin duplicar el core.

### Voice agents

Retell sube de prioridad por aparición repetida junto con n8n + GHL + booking/CRM. El Voice Receptionist deja de ser una curiosidad futura y pasa a template comercial relevante, pero después del core de booking/lead.

### Quote / Procurement Engine

Apareció una señal de mayor ticket para automatización de cotizaciones/procurement con extracción estructurada, sourcing de tarifas/proveedores, comparación, checkpoints humanos, generación de cotización y follow-up. Esto amplía el antiguo `AI Quote & Qualification Agent` a un template más generalizable:

`inquiry → structured extraction → supplier/rate sourcing → comparison → HITL → quote generation → CRM/accounting → follow-up`

Potenciales verticales: logística/freight, distribuidores, servicios B2B, compras/procurement y negocios con cotización compleja. Mantenerlo detrás del Lead & Booking core, pero observar frecuencia y ticket porque puede ser una línea de mayor valor.

### Content Factory

Apareció demanda de sistemas de contenido con:

`n8n/Make → LLM productor → segundo LLM reviewer → human-in-the-loop → Notion/Kanban → publicación`

Es un template reutilizable y además valida el patrón de dos modelos/agentes con enfoques distintos antes de aprobación humana.

La Content Factory debe poder evolucionar a producción audiovisual completa: research/brief → ángulos/hooks → guion/storyboard → generación de assets → edición/motion → revisión independiente → aprobación humana → variantes/repurposing → publicación → métricas/aprendizaje.

### Handover y operabilidad como parte del producto

La demanda reciente vuelve a mostrar que workflow funcionando no alcanza. Para templates comercializables, el entregable debe contemplar cuando corresponda:

`workflow/template importable + Client Config + documentación de instalación/operación + walkthrough/video + tests + error handling + logs + handover`

El cliente debe poder operar la solución y Agentis debe poder clonarla sin reconstruirla.

## Templates prioritarios — ranking vivo

1. **AI Lead & Booking Engine** — señal muy alta; reuso estimado 85–90%; primer producto/criterio de aceptación de Factory v0.1.
2. **CRM Sales Follow-up** — señal muy alta; reuso 85–90%; idealmente módulo del mismo core.
3. **AI Voice Receptionist** — señal alta y creciente; reuso 80–90%.
4. **WhatsApp Support / Sales Agent** — señal alta; reuso 80–90%.
5. **AI Quote / Procurement Engine** — señal media/alta con potencial de ticket alto; reuso 75–85%.
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

### Verticalización sin forks

No crear un workflow distinto por industria si cambia sólo configuración. Ejemplo:

`Agentis Lead Core + GHL Adapter + Telegram HITL + Real Estate Config`

Legal, HVAC/Home Services, clínicas y otras verticales deberían cambiar principalmente el `Client Config`, prompts/reglas, campos y adapters necesarios.

## Servicios publicables derivados de demanda

### Agentis AI Receptionist
“Responde llamadas/WhatsApp, contesta preguntas, califica clientes, agenda turnos y deriva a tu equipo.”

Implementación interna posible:
`Retell / WhatsApp → n8n → LLM → Calendar → GHL → human handoff`

### Agentis Lead Engine
“Automatizamos tu proceso de leads de punta a punta: formulario/WhatsApp → CRM → calificación → seguimiento → cita.”

### Agentis Quote Engine
“Transformamos consultas y pedidos complejos en cotizaciones comparadas y listas para aprobar, con seguimiento automático y control humano donde importa.”

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
- Architecture Map / Documentation Adapter (Archify)
- Project Knowledge Graph Adapter (Graphify)
- LLM Router
- Human Handoff / Approval Gate
- Lead Scoring / Qualification
- Follow-up Engine
- Client Config
- Meeting Brief Generator
- Normalize / Deduplication
- Logging / Audit
- Error Handler / Retry / Idempotency / Rate-limit handling
- Knowledge / RAG Adapter
- Handover / Installer / Template Export package

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
- `vercel-labs/agent-browser` — Browser Operator para casos donde no exista una API adecuada y un agente deba navegar/interactuar con una web como una persona.
- Prioridad: `API/webhook > integración nativa > browser automation`.

### Creative / Content Factory
- Higgsfield Skills — generación de imágenes/video/assets desde los agentes.
- Remotion Skills — composición, edición programática, motion graphics, audio/timing y render de video desde Claude Code/Codex.
- Patrón: `brief/research → hooks → script/storyboard → Higgsfield/assets → Remotion/edit → reviewer independiente → Mati HITL → variantes → publish → métricas`.

### Arquitectura / documentación visual
- `tt-a1i/archify` — candidato para generar y mantener mapas visuales de arquitectura, workflows, secuencias, data flows y cambios del sistema desde Claude Code/Codex.
- Usarlo especialmente en proyectos/templates medianos o grandes para que Mati pueda entender visualmente qué construyeron los agentes y para mantener documentación técnica ligada al sistema real.
- Patrón deseado: `implementación → tests → security → docs AI → docs Mati → Archify/mapa actualizado → human review`.
- Evitar convertirlo en burocracia para cambios pequeños; aplicarlo cuando el mapa reduzca complejidad o ayude a reconstruir/explicar el sistema.

### Project knowledge graph / code understanding
- `Graphify-Labs/graphify` — candidato prioritario para convertir código, documentación, schemas SQL, configs y otros materiales del proyecto en un knowledge graph consultable por agentes.
- Soporta Claude Code, Codex y Gemini CLI, por lo que encaja especialmente bien con la estrategia multi-modelo de Agentis.
- Usarlo como capa de comprensión del proyecto: relaciones entre componentes, dependencias, código, datos e infraestructura. No reemplaza la documentación humana ni los mapas visuales.
- Diferencia conceptual: `Graphify = grafo consultable para que los agentes entiendan el sistema`; `Archify = mapa/documentación visual para explicar y revisar arquitectura`.
- Probarlo temprano en Factory v0.1 para evaluar si reduce lectura repetitiva de repos y mejora onboarding/contexto de agentes.

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
- funciona como “manos y ojos” web de otros agentes.

### Creative / Content Engineer
- convierte brief/research en assets y piezas audiovisuales;
- usa Higgsfield Skills para generación visual/video;
- usa Remotion Skills para composición/edición/render programático;
- genera variantes y entrega a reviewer independiente + Mati HITL.

### Architecture / Documentation Engineer
- mantiene la arquitectura comprensible para agentes y para Mati;
- usa Archify cuando aporte para generar/actualizar mapas de arquitectura, workflows, secuencias y data flows;
- compara cambios importantes y refleja el estado posterior del sistema;
- complementa, no reemplaza, `AGENTS.md`, `CLAUDE.md`, specs, contratos, SOPs y documentación funcional para Mati;
- objetivo: que otro agente pueda reconstruir/entender el sistema y Mati pueda explicar qué hace sin mirar el código.

### Project Knowledge Engineer
- usa Graphify cuando aporte para mantener un grafo consultable del proyecto;
- ayuda a Claude Code, Codex y Gemini a localizar componentes, dependencias y relaciones entre código, documentación, datos e infraestructura;
- reduce relectura innecesaria y acelera onboarding/contexto de agentes;
- complementa el Knowledge Engineer de producto, que usa RAG/LightRAG sobre conocimiento del cliente.

### Frontend / UX Engineer
- Next.js/React;
- 21st.dev / Agent Elements;
- UI UX Pro Max.

### CRM / Integration Engineer
- GHL, Chatwoot, Kommo y otros CRMs;
- Meta/WhatsApp, Calendar, email y APIs de terceros.

### Knowledge Engineer
- LightRAG/RAG;
- ingestión, retrieval y knowledge bases cuando el caso lo necesite.

### Engineer A / Engineer B / Reviewer C opcional
Claude Code y Codex deben funcionar como dos empleados con enfoques independientes. Gemini puede funcionar como tercer especialista/reviewer opcional cuando aporte diversidad de criterio o capacidad específica; no usar tres modelos por defecto si no agrega valor.

Patrones:
- Claude implementa → Codex revisa.
- Codex implementa → Claude revisa.
- Decisiones importantes: propuestas independientes → Project Lead compara → Mati aprueba.
- Gemini puede entrar como tercera opinión/reviewer cuando el riesgo o la ambigüedad lo justifique.

Las capacidades se definen por rol, no por proveedor.

### Security Engineer
- Trail of Bits Skills — revisión de código/configuración/testing.
- Strix — pentesting dinámico autorizado.

### QA / Test
- happy paths;
- failure modes;
- retries/idempotencia;
- human handoff;
- tests/evals;
- pruebas end-to-end.

## Herramientas / skills / repos a conservar e investigar

### Agent harness / coordinación
- Everything Claude Code / ECC (`affaan-m/ECC`; verificar compatibilidad/configuración elegida antes de instalar todo el bundle).
- Get Shit Done — pendiente identificar URL/repo exacto.
- Grok Bot architecture — estudiar como referencia de AI employee persistente, sandbox, MCP, automations y human approval.
- `ptmrio/harness-subagent` — candidato a permitir delegación/revisión cruzada entre harnesses/modelos (Claude/Codex/Grok); investigar antes de adoptar.
- Repo coordinador de proyectos mencionado por Matías — pendiente identificar.
- Repo “NeoHN” mencionado por Matías — pendiente URL exacta.

### n8n
- n8n MCP.
- `czlonkowski/n8n-mcp` + `czlonkowski/n8n-skills` como candidatos principales para el n8n Engineer.
- Mantener radar de repos de workflows/templates.

### Browser
- `vercel-labs/agent-browser` — Browser Operator.

### Creative / video
- `higgsfield-ai/skills` — generación de assets visuales/video.
- `remotion-dev/skills` — edición/composición/render programático.

### Arquitectura / documentación / comprensión de proyecto
- `tt-a1i/archify` — mapas visuales de arquitectura y workflows para Claude Code/Codex; evaluar como parte del Definition of Done en sistemas medianos/grandes.
- `Graphify-Labs/graphify` — knowledge graph del proyecto para Claude Code, Codex y Gemini CLI; prioridad alta para probar en Factory v0.1.

### RAG
- LightRAG.

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
                ↓
        Process Architect
                ↓
          Project Lead
                ↓
 n8n / CRM / Browser / Front / Creative
                ↓
 Claude Code / Codex (+ Gemini opcional)
       implementación + peer review
                ↓
       Graphify context/knowledge
                ↓
          QA / Evals / Tests
                ↓
        Security Review
                ↓
 Docs AI + Docs Mati + Archify cuando aplique
                ↓
       Human-in-the-loop (Mati)
                ↓
        Agentis Template v1
                ↓
 demo + docs + video + landing + pricing + handover
```

## Definition of Done — template comercial

Un template Agentis no termina cuando “funciona”. Para considerarlo comercializable debe, proporcionalmente a su complejidad:

1. resolver happy path y fallos relevantes;
2. separar core reusable de `Client Config` y adapters;
3. manejar retries/idempotencia/dedupe/rate limits cuando correspondan;
4. tener logs/auditoría suficiente para operar y depurar;
5. proteger secretos/credenciales fuera del template exportable;
6. tener tests/evals y revisión de seguridad proporcional;
7. incluir docs AI (`AGENTS.md`/`CLAUDE.md`, specs, contratos/SOPs según aplique);
8. incluir docs Mati/cliente: qué hace, configuración, operación y troubleshooting básico;
9. incluir Archify/mapa visual cuando el tamaño lo justifique;
10. incluir walkthrough/demo y paquete de handover cuando se venda/entregue;
11. poder ser reconstruido/entendido por otro agente leyendo la documentación;
12. poder ser explicado por Mati sin mirar el código.

## Estrategia de marca

Marca principal: **Agentis**.

Matías debe ser visible como fundador/constructor para generar confianza, pero el activo comercial se acumula en Agentis y puede escalar a equipo, servicios y productos.

Estructura sugerida:
- Agentis Agency — implementaciones/servicios.
- Agentis Labs — experimentos, demos y templates.
- Agentis Learn/Blog — contenido técnico/comercial.
- Agentis Products — productos que demuestren tracción.

## Principios

1. n8n es la fábrica/orquestador, no lo que vendemos.
2. Vender resultados de negocio, no nombres de herramientas.
3. Low-code donde alcanza; código donde aporta.
4. Reuse-first: investigar antes de construir.
5. Human-in-the-loop obligatorio en decisiones y releases importantes.
6. Claude Code y Codex se revisan mutuamente y deben conservar diversidad de enfoque.
7. Gemini es reviewer/especialista opcional, no gasto obligatorio.
8. Seguridad y testing forman parte del Definition of Done.
9. Todo componente reutilizable vuelve a la biblioteca Agentis.
10. Muchos experimentos, pocas marcas al principio.
11. La fábrica debe servir para múltiples proyectos/negocios.
12. La demanda freelance funciona también como investigación de producto.
13. Para integración web: preferir API/webhook; Browser Operator cuando sea la mejor vía autorizada.
14. En Content Factory: generación automática ≠ publicación automática.
15. Documentación es un entregable de primera clase: docs para IA + docs comprensibles para Mati + mapa visual cuando aporte.
16. Un template no está realmente terminado hasta que otro agente pueda entender/reconstruirlo con la documentación y Mati pueda explicar qué hace sin mirar el código.
17. La memoria/contexto técnico del proyecto debe ser reutilizable: evaluar Graphify como grafo común para reducir lectura repetida y mejorar coordinación multi-modelo.
18. Verticalizar por configuración y adapters antes de crear forks por industria.
19. Handover y operabilidad son parte del producto, no tareas administrativas posteriores.

## Próximas decisiones

- [ ] Identificar Get Shit Done exacto.
- [ ] Identificar repo coordinador de proyectos.
- [ ] Identificar repo NeoHN exacto.
- [ ] Comparar ECC vs GSD vs coordinador y eliminar redundancias.
- [ ] Evaluar `ptmrio/harness-subagent` y Grok Bot como referencias/capas de coordinación multi-harness.
- [ ] Investigar n8n MCP y compatibilidad Claude Code/Codex.
- [ ] Crear matriz `rol → skill Claude → skill Codex → Gemini opcional → herramienta compartida`.
- [ ] Inventariar repos/templates n8n por template comercial.
- [ ] Elegir Agentis Factory v0.1 mínima.
- [ ] Levantar Lead & Booking Engine según el PRD de mercado y probar end-to-end.
- [ ] Implementar `Client Config` centralizado y separar secretos/credenciales.
- [ ] Diseñar core Conversation/Qualification/Calendar/CRM/Handoff/Logs.
- [ ] Incorporar normalize/dedupe, retries, logging y meeting brief al core v1 donde correspondan.
- [ ] Probar una segunda vertical cambiando configuración/adapters sin forkear el workflow central.
- [ ] Evaluar Retell después del Booking/Lead core.
- [ ] Mantener Quote / Procurement Engine en radar y medir repetición/ticket antes de adelantarlo.
- [ ] Probar agent-browser con Claude Code y Codex.
- [ ] Probar Higgsfield Skills.
- [ ] Probar Remotion Skills con ciclo render → revisión → corrección → render final.
- [ ] Diseñar Content Factory v0.1 para UGC externo + Agentis + negocios propios.
- [ ] Probar Archify en un proyecto real y definir cuándo pasa a ser parte obligatoria del Definition of Done.
- [ ] Probar `Graphify-Labs/graphify` con Claude Code, Codex y Gemini CLI sobre el mismo repo y medir si mejora navegación, contexto y onboarding.

## Última actualización

- Fecha: 2026-09-10.
- GHL mantiene prioridad sobre Chatwoot por volumen de demanda observado.
- Lead & Booking Engine queda definido como primer producto/criterio de aceptación de Factory v0.1, con `Client Config` centralizado y verticalización por adapters/configuración.
- Quote / Procurement Engine aparece como línea potencial de mayor ticket a seguir midiendo.
- Handover, walkthrough, documentación, error handling, logs y operabilidad se consolidan como parte del producto comercial.
- Retell mantiene prioridad alta después del Lead & Booking core.
- Content Factory incorpora generación visual + edición programática.
- Agent Browser entra como capacidad de interacción web.
- Gemini queda como tercer reviewer/especialista opcional.
- Archify entra como capa de arquitectura/documentación visual, especialmente para proyectos medianos/grandes.
- Graphify entra con prioridad alta como knowledge graph compartido del proyecto para Claude Code, Codex y Gemini CLI.
- ECC queda registrado como candidato de harness operativo; instalar selectivamente para evitar solapamiento con GSD/otras capas.
