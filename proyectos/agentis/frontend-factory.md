# Agentis — Frontend Factory

## Objetivo

Construir una capa de frontend reutilizable para Agentis donde Claude Code, Codex y futuros agentes no improvisen interfaces desde cero. La Factory debe combinar criterio visual, componentes reutilizables, motion, visualización de datos, browser testing, QA y human-in-the-loop.

Principio:

`dirección visual → componentes → implementación → motion → crítica/audit → browser QA → métricas → HITL`

No instalar una herramienta sólo porque sea popular. Cada herramienta debe tener una responsabilidad clara y evitar solapamiento innecesario.

## Stack ya identificado

### 21st.dev

Fuente de componentes/patrones React/Tailwind para acelerar implementación. Rol: component sourcing, no dirección visual completa.

### UI UX Pro Max

Candidato de conocimiento/criterio UX para el Frontend Agent.

### Taste Skill

Rol propuesto: dirección/criterio creativo y reducción del aspecto genérico de interfaces generadas por IA.

### Impeccable

Rol propuesto: sistema de calidad visual. DESIGN.md/PRODUCT.md, critique, audit, polish y reglas determinísticas. Complementa Taste: Taste orienta; Impeccable critica y sistematiza.

### agent-browser

Rol: Browser Operator para exploración e interacción agéntica. API/integración nativa sigue teniendo prioridad cuando existe.

### Playwright CLI

Rol: QA/E2E determinístico. No reemplaza necesariamente agent-browser: Browser Operator trabaja/explora; Playwright valida comportamiento reproducible.

### Awesome DESIGN.md

Biblioteca/referencia de lenguajes visuales. No convertir en dependencia del runtime. Cada producto debe terminar con su propio DESIGN.md.

## Nuevos candidatos — investigación 2026-09-11

### Anime.js + animejs-skills — SUMA, pero como especialista

Anime.js es una librería de animación JavaScript adecuada para timelines, SVG/path motion, stagger, scroll, drag y secuencias más coreografiadas. Existe `BowTiedSwan/animejs-skills`, skill para Anime.js v4 con referencias y ejemplos para Claude Code.

Rol Agentis: **Motion Specialist para animaciones complejas/coreografiadas**, no default para toda interacción.

Regla: si CSS/Motion resuelve bien el problema, no agregar Anime.js por defecto. Usarlo cuando timeline/SVG/stagger/coreografía justifique la dependencia.

Estado: **candidato aprobado / instalar cuando el proyecto lo requiera**.

### Motion.dev — SUMA, prioridad alta

Motion es un candidato fuerte como default de motion para React cuando el proyecto no tenga ya otra librería. Sirve para springs, layout animations, exit animations, gestures y motion interactivo.

Skills candidatas:
- `emilkowalski/skills` (`animate`, más skills de review/improve de animaciones): muy interesante porque primero decide si algo debe animarse y elige la herramienta más barata que resuelva el caso; contempla accesibilidad y performance.
- `199-biotechnologies/motion-dev-animations-skill`: skill especializada en Motion.dev con ejemplos, referencias, schemas y validación.

Preferencia inicial Agentis: **evaluar primero el enfoque de Emil Kowalski como criterio de motion**, y usar Motion.dev como implementación cuando corresponda. No forzar Motion si CSS/WAAPI alcanza.

Reglas mínimas: `prefers-reduced-motion`, performance, no animar datos/controles sólo por decoración, validar visualmente una animación antes de propagarla.

Estado: **aprobado para Frontend Factory / prioridad alta**.

### Coconut UI — SUMA como biblioteca de componentes, no como dependencia core

Importante: no confundir el Coconut UI moderno de `coconutui.com` (componentes React/copy-paste usados en contenido actual) con el repo histórico `MVCoconut/coconut.ui`, que es una librería Haxe distinta.

El Coconut UI moderno ofrece componentes visuales/animados listos para reutilizar: liquid-glass, bento grids, cards, text effects y componentes relacionados con AI/voice según demos y referencias públicas.

Rol Agentis: **component sourcing / inspiration**, parecido a 21st.dev pero con piezas visuales más específicas. Reutilizar/adaptar componentes cuando ahorren trabajo; no convertir toda la arquitectura UI en Coconut.

Antes de incorporar un componente: revisar código, licencia/condiciones del componente concreto, accesibilidad, performance y dependencia de Motion u otras libs.

Estado: **aprobado como recurso de Frontend Factory**.

### Bklit UI — SUMA especialmente para dashboards

Repo oficial: `bklit/bklit-ui`. Biblioteca open source MIT de UI/charts distribuida mediante registry compatible con shadcn. Tiene skill oficial `bklit-ui` instalable con Skills CLI. La skill lee configuración del proyecto y guía instalación, composición, theming, animation y tooltips.

Catálogo documentado de charts: area, bar, line, live line, composed, scatter, candlestick, pie, ring, radar, gauge, heatmap, funnel, sankey y choropleth.

Rol Agentis: **Data Visualization Specialist** para dashboard interno y futuros paneles de clientes. Encaja especialmente bien con la filosofía de Agentis de medir resultados.

Nota: el antiguo `bklit/bklit` Analytics SaaS fue discontinuado/archivado; lo relevante es `bklit/bklit-ui`, que sigue siendo el proyecto de UI/charts.

Estado: **aprobado / prioridad alta cuando construyamos dashboard/observability UI**.

### Manus / Manus API Skill — NO core por ahora, sí radar e integración opcional

Manus actualmente tiene un sistema de Skills portable y una **Manus API skill oficial** instalable en Codex y otros coding agents compatibles. La skill oficial cubre integración con API v2: creación/lifecycle de tasks, multi-turn, confirmations, structured output, files, projects, connectors, custom skills, webhooks, usage, publishing, agents/browser clients y auth.

Esto es distinto de una simple skill de frontend: Manus es otro runtime/plataforma de agentes que Agentis podría integrar o evaluar.

Rol Agentis: **adapter/proveedor opcional y fuente de patrones de skills**, no agregarlo al engineering core mientras Claude Code + Codex + n8n cubran nuestras necesidades. Evitar sumar otro runtime sin caso de uso medible.

Sí vale estudiar su portabilidad de Skills y su API si aparece una capacidad o workflow donde Manus supere claramente al stack actual por calidad/costo/tiempo.

Estado: **watchlist / no instalar en core todavía**.

## Política de selección de motion

Usar la herramienta mínima que resuelva correctamente el caso:

`CSS transition / @starting-style → CSS animation → WAAPI → Motion.dev → Anime.js/especialista`

La elección depende del tipo de interacción, complejidad, performance, accesibilidad, mantenibilidad y stack existente. Si el proyecto ya usa una librería de motion adecuada, preferir consistencia antes que agregar otra.

## Arquitectura propuesta del Frontend Factory

`brief + producto + referencias`
`→ DESIGN.md / design tokens`
`→ Taste / UX rules`
`→ 21st.dev | Coconut UI | shadcn/component sources`
`→ Claude/Codex implementation`
`→ Motion decision → CSS | Motion.dev | Anime.js`
`→ Bklit UI cuando haya data visualization`
`→ Impeccable critique/audit/polish`
`→ agent-browser exploratory validation`
`→ Playwright deterministic E2E`
`→ screenshots + logs + metrics`
`→ reviewer independiente`
`→ Mati HITL`

## Métricas del Frontend Factory

Medir para aprender qué combinación de herramientas/modelos produce mejor resultado:
- tiempo hasta primera versión funcional;
- cantidad de iteraciones hasta aprobación;
- findings visuales/a11y antes y después de audit;
- errores E2E;
- regresiones;
- performance relevante;
- correcciones humanas requeridas;
- costo/tokens/modelo por etapa;
- reutilización de componentes;
- tiempo de implementación vs reutilización;
- aprobación/rechazo humano y motivo.

Objetivo: no optimizar sólo velocidad o costo por llamada; optimizar **calidad útil por costo y tiempo**.

## Próximos experimentos

1. Probar una misma pantalla/landing con Frontend Factory y registrar métricas.
2. Comparar `CSS vs Motion.dev` para microinteracciones y reservar Anime.js para un caso realmente coreografiado.
3. Probar Bklit UI en el dashboard interno de métricas/logs de Agentis.
4. Usar Coconut UI/21st.dev como fuentes, pero medir cuánto código se reutiliza realmente y cuánto hay que corregir.
5. Mantener Manus en radar hasta que exista un caso concreto donde su runtime/API tenga ventaja frente al stack actual.

Última actualización: 2026-09-11.
