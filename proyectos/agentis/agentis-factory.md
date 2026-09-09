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

## Templates prioritarios

- AI Lead & Booking Engine
- AI Sales Follow-up
- AI Customer/Support Inbox
- AI Clinic / Appointment Receptionist
- AI Quote & Sales Agent
- Lead Reactivation
- Omnichannel Agent + human handoff
- Voice Agent
- CRM Automation Core
- Web Research / Scraping Agent

Objetivo de diseño: reutilizar idealmente 70–90% del sistema entre clientes mediante configuración.

## Componentes reutilizables candidatos

- CRM Adapter (GHL primero; Chatwoot/Kommo/HubSpot/Pipedrive/Bitrix según demanda)
- WhatsApp Adapter
- Telegram Adapter
- Calendar Adapter
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
- JavaScript/Python dentro de n8n o servicios auxiliares cuando los nodos no alcancen.
- APIs/webhooks como habilidad central.

### CRM / canales
- GoHighLevel — prioridad comercial por demanda observada.
- Chatwoot — alternativa open-source/self-hosted, especialmente omnicanal/human handoff.
- Kommo — vigilar especialmente en LATAM.
- HubSpot/Pipedrive/Bitrix24 — adapters según cliente/demanda.
- WhatsApp Cloud API — preferencia para producción frente a automatizaciones no oficiales de WhatsApp Web.

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
- Mantener radar de repos de workflows/templates y seleccionar bases por caso de uso.

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
