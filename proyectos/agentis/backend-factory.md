# Agentis — Backend Factory

## Objetivo

Construir una Backend Factory progresiva para Agentis sin sobreingeniería temprana. n8n sigue siendo el orquestador principal y puede cubrir gran parte del backend al inicio, pero las capacidades que se vuelvan reutilizables, complejas, críticas, de baja latencia o con garantías propias deben poder extraerse a servicios en código.

Principio base:

> n8n primero para descubrir y orquestar; código cuando la lógica se vuelve reusable, compleja, crítica o necesita garantías propias.

Secuencia preferida:

`resolver rápido en n8n → observar → identificar fronteras → extraer servicio → testear → reutilizar`

No hacer microservicios por deporte. Mantener monolito/modular backend mientras sea suficiente y separar servicios sólo cuando haya una razón medible.

## Arquitectura objetivo

```text
Frontend / Internal UI
        ↓
FastAPI / Backend services
        ↓
Postgres / Supabase
        ↓
n8n Orchestrator
        ↓
WhatsApp / CRM / Calendar / AI / Payments / other APIs
```

n8n conserva la coordinación de workflows, integraciones, eventos y tareas async. FastAPI concentra APIs reutilizables, contratos, lógica de negocio estable, validación, auth, servicios de baja latencia y componentes compartidos.

## Cuándo dejar lógica en n8n

- webhooks e integraciones sencillas;
- secuencias de negocio todavía en descubrimiento;
- cron/schedules;
- llamadas a APIs SaaS;
- CRUD simple;
- workflows con human-in-the-loop;
- prototipos y primeras versiones;
- lógica que cambia seguido mientras se aprende el proceso.

## Cuándo extraer a FastAPI/Python

- lógica repetida en varios workflows/clientes;
- reglas complejas que necesitan tests unitarios;
- endpoints consumidos por múltiples sistemas;
- auth/RBAC más fino;
- validación y contratos importantes;
- baja latencia o alto volumen;
- procesamiento de datos pesado;
- streaming/SSE/WebSockets;
- algoritmos de scoring, dedupe, normalización o matching estables;
- servicios que necesiten versionado de API y SLOs propios;
- piezas críticas donde retries, idempotencia y observabilidad deben ser controladas en código.

Ejemplo:

`n8n → POST /lead/process → normalize + dedupe + score → response → n8n continúa`

## Stack inicial propuesto

- Python
- FastAPI
- Pydantic v2
- PostgreSQL / Supabase
- SQLModel o SQLAlchemy 2.0 según complejidad
- Alembic cuando haya migrations propias
- pytest + HTTPX
- uv
- Ruff
- Docker
- OpenAPI como contrato/documentación
- structured logging + request/correlation IDs
- Sentry/OpenTelemetry cuando el producto lo justifique
- Redis sólo para estado efímero, locks, rate limiting, cache o colas cuando haya una necesidad concreta

## Repos y skills investigados

### 1. Skill oficial de FastAPI — prioridad muy alta

Repo: `fastapi/fastapi`
Path: `.agents/skills/fastapi/SKILL.md`

Es la skill oficial de FastAPI para agentes. Cubre convenciones actuales, Pydantic, dependencias, streaming/SSE, routers, response models y tooling relacionado. Recomendada como conocimiento obligatorio del Backend Engineer cuando edite código FastAPI.

Decisión Agentis: **incorporar como skill prioritaria**. Preferir skill oficial antes que forks genéricos.

### 2. Full Stack FastAPI Template — referencia/base prioritaria

Repo: `fastapi/full-stack-fastapi-template`

Incluye FastAPI, SQLModel, Pydantic, PostgreSQL, React/TypeScript, Tailwind/shadcn, cliente frontend generado, Playwright, Docker Compose y CI/deployment.

Decisión Agentis: **usar como referencia y posible starter**, no copiar a ciegas. Sirve para estudiar estructura, auth, contratos backend/frontend, testing e infraestructura sin inventar todo desde cero.

### 3. Pyforge — referencia secundaria

Repo: `helioLJ/pyforge`

Starter moderno con FastAPI async, SQLAlchemy 2.0, Pydantic v2, Alembic, uv, Ruff, pytest/httpx, structlog, Docker y GitHub Actions.

Decisión Agentis: **referencia secundaria útil**, especialmente para comparar una estructura backend-only y logging moderno contra el template oficial.

### 4. fast-api-starter de cstacklab — referencia de simplicidad

Repo: `cstacklab/fast-api-starter`

Interesante porque explícitamente evita Clean Architecture pesada y usa una estructura más directa: routes, runtime/core, models, schemas, repositories y services. Incluye request IDs, Problem Details, CORS, pytest y async SQLAlchemy.

Decisión Agentis: **referencia valiosa para evitar sobrearquitectura**.

### 5. Claude/Agent backend skill packs — usar selectivamente

Repos investigados incluyen colecciones con skills como:
- `fastapi-templates`;
- `api-design-principles`;
- `python-testing-patterns`;
- `async-python-patterns`;
- `architecture-patterns`.

Decisión Agentis: no instalar una colección completa por defecto. Extraer sólo skills que cubran un hueco real y compararlas contra la skill oficial FastAPI y ECC para evitar duplicación de instrucciones.

### 6. Microsoft MarkItDown — preprocessing de documentos para IA

Repo: `microsoft/markitdown`

MarkItDown es una utilidad Python ligera orientada explícitamente a convertir archivos a Markdown para LLMs y pipelines de análisis de texto. Soporta PDF, PowerPoint, Word, Excel, imágenes, audio, HTML, CSV/JSON/XML, ZIP, YouTube, EPUB y otros formatos. El objetivo no es una conversión visual de alta fidelidad sino preservar estructura útil para análisis: headings, listas, tablas, links y contenido textual.

Decisión Agentis: **incorporar como componente recomendado de Document Ingestion / Knowledge Factory**.

Pipeline por defecto cuando el objetivo sea análisis textual/RAG y no inspección visual del documento:

`archivo → detección de tipo → MarkItDown → Markdown limpio → normalización → chunking/indexado → LLM/RAG`

Para PDF con texto embebido, preferir extracción local antes de mandar el binario completo a un modelo multimodal. Markdown suele ser más compacto y reutilizable, y permite cachear el resultado para múltiples consultas posteriores.

Para PDFs escaneados o contenido relevante dentro de imágenes, usar fallback OCR sólo cuando haga falta. MarkItDown dispone de plugin OCR con visión y también puede integrarse con Azure Document Intelligence/Content Understanding para casos de mayor fidelidad.

Regla de costo/calidad:

> No enviar un documento completo a un modelo multimodal si una extracción estructurada local preserva la información necesaria. Convertir una vez, reutilizar muchas veces.

No asumir que la conversión siempre reduce tokens en todos los documentos. Medir `bytes/tokens original-equivalent vs markdown`, calidad de extracción, tablas preservadas, errores y costo total. Para documentos visuales, diagramas, layouts complejos o casos donde la ubicación espacial importe, conservar también el archivo/páginas originales y escalar a visión sólo en las páginas necesarias.

Posible servicio futuro:

`POST /v1/documents/ingest`

Responsabilidades:
- validar tipo/tamaño;
- elegir converter;
- generar Markdown;
- detectar necesidad de OCR/visión;
- persistir hash + versión + artefacto derivado;
- deduplicar conversiones;
- devolver metadata y quality flags;
- dejar listo para chunking/RAG.

Observabilidad sugerida:
- file type + size;
- converter/version;
- páginas/hojas/slides;
- chars/tokens resultantes;
- OCR usado o no;
- latencia;
- costo externo si hubo visión/OCR cloud;
- errores/warnings;
- quality flags;
- cache hit/miss.

## Backend Factory — roles

### Backend Architect

Decide fronteras, contratos, persistencia, sync/async, monolito vs extracción y requisitos de observabilidad. Debe justificar cualquier nueva complejidad.

### Backend Engineer

Implementa FastAPI/Python usando la skill oficial, contratos Pydantic, tests y documentación OpenAPI.

### Database / Data Engineer

Diseña schemas, indexes, migrations, source-of-truth, retención y queries. Evita duplicar innecesariamente CRM y Agentis DB.

### API / Integration Engineer

Diseña adapters, webhooks, idempotency, retries, rate limiting, OAuth y contratos con n8n/CRM/WhatsApp/etc.

### QA / Reviewer

Ejecuta unit/integration/contract tests, edge cases y revisiones maker-checker.

### Security Engineer

Trail of Bits Skills + Strix como gates según criticidad, además de secret management, authz y revisión de endpoints.

## Contrato n8n ↔ backend

Toda pieza extraída a código debería exponer un contrato simple y versionable. Idealmente:

```text
POST /v1/... 
request Pydantic schema
response Pydantic schema
request_id / trace_id
idempotency key cuando aplique
error contract estable
health/readiness endpoints
OpenAPI
```

n8n debe consumir servicios por contratos, no conocer detalles internos del servicio.

## Observabilidad y métricas

La Backend Factory hereda el principio general de Agentis: todo componente importante debe ser medible.

Mínimo por request/ejecución cuando corresponda:
- service + version;
- endpoint/action;
- request/trace ID;
- status/error type;
- latency;
- retries;
- downstream dependencies;
- costo si involucra APIs/modelos pagos;
- business outcome asociable cuando exista;
- versión de reglas/model/config relevante.

Esto permite decidir con evidencia cuándo mover lógica de n8n a código, cuándo optimizar, y si la extracción realmente mejoró confiabilidad/costo/latencia.

## Reglas de arquitectura

1. **Monolito modular primero.** No crear microservicios hasta que haya una frontera real.
2. **Extraer por responsabilidad y contrato.** No porque “todo debe ser un servicio”.
3. **n8n coordina; FastAPI encapsula lógica estable/reutilizable.**
4. **API/webhook antes que browser automation.**
5. **Contratos explícitos antes que dependencias implícitas.**
6. **Tests donde el costo de equivocarse sea relevante.**
7. **No agregar Redis, queues, event buses o DDD pesado sin un problema concreto.**
8. **Backend agnóstico del CRM cuando sea razonable.** Usar adapters.
9. **OpenAPI y documentación son parte del producto.** Otro agente debe poder reconstruir/consumir el servicio leyendo contratos y docs.
10. **Medir antes de optimizar.**

## Primer experimento recomendado

No construir un backend enorme. Esperar a que Lead & Booking revele una primera pieza clara para extraer.

Buen candidato:

`Lead Processing Service`

Responsabilidades posibles:
- canonical normalization;
- deterministic dedupe;
- validation;
- feature extraction;
- scoring rules;
- structured result.

Experimento:

1. construir primero el flujo completo en n8n;
2. medir dónde aparece repetición/complejidad;
3. extraer sólo esa pieza a FastAPI;
4. agregar tests;
5. consumirla desde el mismo workflow;
6. comparar latencia, errores, mantenibilidad y reuse;
7. reutilizarla en una segunda vertical sin fork.

Si la extracción no aporta una ventaja tangible, mantener la lógica en n8n.

## Relación con Frontend Factory

La Frontend Factory no debería acoplarse directamente a detalles de n8n. A medida que Agentis madure:

`Frontend Factory → typed API/client → Backend Factory → n8n/tools/data`

Para MVPs internos simples, frontend → n8n webhook sigue siendo válido. La separación aparece cuando aporta auth, contratos, reuso, observabilidad o control.

## Prioridad actual

La Backend Factory es una capacidad paralela de aprendizaje y una dirección arquitectónica, pero no desplaza el roadmap inmediato de Agentis:

`Factory v0.1 → Lead & Booking → GHL/WhatsApp/Calendar/HITL → primera vertical → segunda vertical sin fork → Voice/Retell`

Aprender backend construyendo necesidades reales de Agentis, no mediante abstracciones aisladas.

Última actualización: 2026-09-11.
