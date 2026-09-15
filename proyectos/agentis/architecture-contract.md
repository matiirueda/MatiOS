# Agentis — Architecture Contract

> Estado: contrato canónico de arquitectura  
> Fecha: 2026-09-15

## Propósito

Este archivo no duplica la documentación detallada existente. Define únicamente las separaciones e invariantes que deben mantenerse consistentes en todo Agentis.

Antes de agregar documentación nueva al repo:

1. revisar los archivos existentes del área;
2. identificar si el concepto ya existe;
3. actualizar o referenciar la fuente canónica correspondiente;
4. crear un archivo nuevo sólo cuando represente un concepto realmente distinto;
5. evitar repetir la misma arquitectura en research, product y implementation docs.

Los documentos de investigación pueden contener contexto y fuentes; las decisiones consolidadas deben vivir en documentos canónicos.

## Arquitectura canónica: cinco capas separadas

### 1. Knowledge Core — verdad del negocio

Contiene conocimiento y configuración independientes del agente que los consume:

- servicios/productos;
- precios y promociones;
- horarios;
- políticas;
- FAQs;
- procedimientos;
- reglas operativas;
- documentos y conocimiento validado.

Regla: **el conocimiento pertenece al negocio, no al agente**.

Cambiar Sales Agent por otro runtime/modelo no debe implicar reconstruir precios, FAQs, procedimientos o políticas.

Fuente detallada: `bootstrap-knowledge-core.md`.

### 2. Employee Layer — identidad, rol y gobierno

Cada agente/empleado es un objeto explícito con:

- identidad;
- rol/responsabilidad;
- knowledge scope;
- tools permitidas;
- permisos;
- límites de riesgo/costo;
- canales;
- políticas de aprobación;
- versión/runtime/modelo cuando corresponda.

El empleado **consulta** el Knowledge Core según su scope; no es propietario de una copia aislada de la verdad empresarial.

Principio:

`mismo conocimiento + distinto rol/permisos = distinto empleado`

Esto permite reemplazar runtime/modelo/agente sin perder conocimiento ni estado del negocio.

### 3. Customer Graph — memoria comercial persistente del cliente

Representa conocimiento reutilizable sobre cada cliente cuando sea legítimo y útil:

- preferencias explícitas;
- inferencias separadas de hechos;
- comportamiento/interacciones;
- historial comercial;
- contexto relevante;
- consentimiento y preferencias de comunicación;
- provenance/confidence/recency.

No pertenece al prompt ni a la memoria privada de un único agente. Debe ser una capa estructurada y auditable accesible según permisos.

Fuente detallada: `product/customer-preference-graph-and-recampaigning.md`.

### 4. Conversation Intelligence — conversación como señal, no como verdad

Las conversaciones son materia prima. El sistema puede extraer:

- facts;
- intent;
- objections;
- preferences;
- entities/relationships;
- next actions;
- CRM updates;
- knowledge gaps;
- candidate knowledge/config changes.

Flujo general:

`conversation → extract → classify → normalize → confidence/provenance → route → validate/HITL cuando aplique → persistir en la capa correcta`

Regla central:

> **Una conversación genera señales. Una señal no se convierte automáticamente en verdad.**

Ejemplos:

- “Soy de River” → preferencia explícita del Customer Graph.
- “¿Abren los domingos?” repetido por muchos clientes → señal de FAQ/gap; no cambia el horario por sí sola.
- “El dueño dijo que desde mañana cambia el precio” → propuesta de cambio de Knowledge Core; requiere autenticación/aprobación según política.

Fuente detallada: `bootstrap-knowledge-core.md` (Bootstrap Learn / Conversation Intelligence Core).

### 5. Tools / Action Layer — capacidad real de actuar

Los empleados sólo pueden ejecutar operaciones mediante tools/adapters autorizadas:

- CRM;
- WhatsApp/canales;
- calendar/booking;
- payments;
- inventory;
- n8n/workflows;
- bases/APIs;
- otros servicios.

Los permisos efectivos deben imponerse en infraestructura/gateway, no sólo en prompts.

Toda acción relevante debe poder reconstruirse mediante Activity Ledger/audit:

`employee → role → task → knowledge consulted → tool/action → permission → approval → result → cost → timestamp`

## Relación entre capas

```text
Canales / eventos
      ↓
Conversation Intelligence
      ├──────────────→ Customer Graph
      ├──────────────→ CRM / state
      └─proposal────→ Knowledge Core / config
                         ↑
                         │ scoped access
                    Employee Layer
                         ↓
                  Tools / Action Layer
                         ↓
                    sistemas reales
                         ↓
                 events + outcomes
                         └────────→ aprendizaje / analytics
```

## Separaciones que NO deben romperse

1. **Agent ≠ Knowledge.** El agente puede cambiar; la verdad del negocio permanece.
2. **Conversation ≠ Knowledge.** El chat es evidencia/señal; debe extraerse, clasificarse y validarse.
3. **Customer preference ≠ Business truth.** “Me gusta River” pertenece al cliente; “abrimos a las 9” pertenece al negocio.
4. **Inference ≠ explicit fact.** Mantener provenance y confidence.
5. **Prompt ≠ permission.** Los límites reales se aplican en tool/gateway/infra.
6. **CRM ≠ único repositorio universal.** Definir source of truth por entidad/campo y usar adapters.
7. **RAG/index/grafo ≠ source of truth.** Son derivados/regenerables cuando exista una fuente canónica.
8. **Runtime/model ≠ employee identity.** El runtime debe poder sustituirse sin reconstruir conocimiento, estado o políticas.

## Ciclo de aprendizaje

Agentis debe aprender por dos caminos distintos:

### Aprendizaje individual

`conversation/event → Customer Graph / CRM → mejor próxima interacción`

Ejemplo: gustos, contexto, historial, objeciones, frecuencia.

### Aprendizaje empresarial/agregado

`muchas conversaciones/outcomes → patrones → hipótesis → análisis/HITL → Knowledge/Product/Process update`

Ejemplos:

- FAQ recurrente;
- producto que clientes piden y no existe;
- preferencia agregada que justifica probar una cápsula;
- objeción recurrente que requiere cambiar comunicación;
- promoción que convierte mejor/peor;
- gap de conocimiento o proceso.

La señal agregada puede alimentar Product Research y Content Factory sin convertir datos personales en conocimiento empresarial identificable.

## Flywheel objetivo

```text
mejor Knowledge Core
→ mejores empleados
→ mejores conversaciones/acciones
→ más outcomes y señales
→ mejor Customer Graph + analytics
→ mejor conocimiento/productos/procesos
→ mejores empleados
```

## Documentos canónicos relacionados

- `bootstrap-knowledge-core.md` — Knowledge Core, bootstrap, versionado, Conversation Intelligence y governance.
- `product/customer-preference-graph-and-recampaigning.md` — Customer Graph, preferencias y re-campaigning.
- `china-radar-business-operator.md` — Business Operator, CRM como system of execution, agentes especializados y señales externas.
- `agentis-factory.md` — Factory, roles de desarrollo y componentes reutilizables.
- `knowledge-vault-graphify.md` — knowledge/project graphs derivados, retrieval y source-of-truth rules.
- `research/erik-taveras-deep-dive-2026-09-15.md` — investigación/referencias externas; no debe convertirse en fuente canónica de decisiones si éstas ya fueron consolidadas en los archivos anteriores.

## Regla de mantenimiento

Cuando una nueva investigación valide una idea ya existente:

- agregar fuente/evidencia en `research/`;
- actualizar la decisión sólo si cambia;
- no crear una segunda descripción canónica del mismo concepto.

Cuando una idea nueva cruza varias áreas, primero decidir **qué documento es su fuente canónica** y luego enlazarla desde los demás.
