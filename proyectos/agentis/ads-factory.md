# Agentis — Ads Factory

## Objetivo

Construir una Ads Factory conectada a la Content Factory para transformar investigación, insights, ofertas y piezas creativas en campañas publicitarias medibles, iterables y reutilizables.

La Ads Factory no debe ser sólo un publicador de anuncios. Debe actuar como capa de estrategia, experimentación, distribución y aprendizaje.

Patrón objetivo:

`Business/CRM insights → Campaign Strategy → Content Factory → Ads Factory → tráfico/leads → CRM/Lead Agent → revenue/booking → métricas → aprendizaje → nueva iteración`

## Relación con Content Factory

La Content Factory produce materia prima creativa:
- ángulos de venta;
- hooks;
- guiones;
- copies;
- imágenes;
- videos;
- variantes;
- formatos y repurposing.

La Ads Factory decide cómo convertir esas piezas en campañas:
- objetivo de campaña;
- audiencia/segmento;
- oferta;
- canal;
- presupuesto;
- estructura de ad sets/campaigns;
- combinación creativo × copy × audiencia;
- reglas de test;
- pausado/escalado;
- medición y atribución;
- feedback hacia Content Factory.

No duplicar roles: Content Factory crea y adapta contenido; Ads Factory diseña y ejecuta experimentos publicitarios.

## Arquitectura conceptual

```text
CRM / Business Operator / Research
              ↓
      Campaign Strategist
              ↓
        Experiment Plan
              ↓
        Content Factory
              ↓
 Creative variants + copy + hooks
              ↓
          Ads Factory
              ↓
 Meta Ads | Google Ads | TikTok Ads | otros
              ↓
 Landing / WhatsApp / Lead Form / Booking
              ↓
 Lead Agent / CRM / Sales
              ↓
   Revenue / Booking / Quality
              ↓
 Analytics + Attribution + Learnings
              ↓
 Campaign Strategy + Content Factory
```

## Agentes/componentes candidatos

### Campaign Strategist

Convierte objetivo de negocio en hipótesis publicitaria. Define:
- objetivo;
- ICP/segmento;
- propuesta/oferta;
- funnel;
- canal;
- presupuesto inicial;
- métricas objetivo;
- plan de experimentos.

### Audience / Segmentation Agent

Usa CRM + Agentis DB + research para proponer segmentos y exclusiones. Debe respetar políticas, permisos y restricciones de cada plataforma.

### Creative Selector

Recibe assets de Content Factory y arma combinaciones testeables de:
`hook × visual × copy × CTA × formato × audiencia`.

### Campaign Builder

Traduce una campaña aprobada a la API/ad manager del canal. En primeras versiones puede ser semi-automático y requerir HITL antes de publicar o aumentar gasto.

### Ads Platform Operator

Responsabilidad: convertir un plan de campaña aprobado en operaciones concretas sobre cada plataforma mediante MCP/API oficial.

No decide por sí solo la estrategia. Es la capa de ejecución especializada.

Patrón:

`Campaign Plan → Platform Adapter/Skill → MCP/API → draft/paused campaign → validation → human approval → publish`

Subroles/adapters:
- Meta Ads Operator;
- Google Ads Operator;
- TikTok Ads Operator;
- otros canales futuros.

Debe conocer estructura, objetivos, restricciones, naming, targeting, budget, placements, creatives, pixels/conversiones y políticas propias de cada plataforma.

### Performance Analyst

Une métricas de plataforma con métricas de negocio. No optimizar sólo por CTR o CPC si el objetivo real es booking, venta, revenue o lead de calidad.

### Budget / Experiment Controller

Aplica reglas de test, límites y escalado. Inicialmente recomendado como sistema de recomendaciones + aprobación humana; automatizar gasto sólo cuando las reglas estén bien validadas.

## MCPs y skills investigados para Ads Platform Operator

### Meta Ads — prioridad alta

**MCP oficial de Meta Ads**

Servidor hospedado por Meta: `https://mcp.facebook.com/ads`.

La documentación comunitaria actual reporta que el rollout comenzó en 2026 y que expone herramientas para lectura y gestión del ciclo publicitario mediante OAuth. Preferir el MCP oficial cuando la cuenta tenga acceso.

Fallbacks/open source útiles mientras el rollout no sea universal:
- `rafaelszago/meta-ads-mcp`: MCP local + skills de launch/report/optimize/pause + contexto de marca;
- `feel-t/meta-ads-mcp`: wrapper productivo sobre Meta Marketing API;
- `santmun/meta-ads-skills`: skills de setup y operación sobre Meta Ads CLI;
- `Sandy-zippy/meta-ads-stack`: skills + MCP con human approval antes de spend.

Decisión Agentis: **Meta Ads Operator = primer adapter a implementar**. Crear siempre campañas nuevas en PAUSED/draft cuando sea posible y exigir aprobación antes de activar gasto.

### Google Ads — prioridad alta después de Meta

Repos/skills útiles:
- `kastriasani/google-ads-skills`: suite de 13 skills para research, planning, build, optimization, reporting y forecasting;
- `gabogabucho/google-ads-mcp`: MCP para Google Ads + GA4 con skills de setup/analyze/manage/GA4 y safety checks;
- `google/skills`: skills/plugins oficiales de Google para productos Google; revisar si incorpora componentes específicos de Ads antes de depender de ellos.

Decisión Agentis: usar skills para estrategia/estructura y un MCP/API para ejecución. Google Ads Operator debe incluir integración de medición con GA4/conversiones cuando corresponda.

### TikTok Ads — prioridad posterior pero prevista desde diseño

Repos/skills útiles:
- `getmcpads-com/tiktok-ads-mcp-server`: MCP open source para TikTok Business API, lectura + operaciones de escritura con preview/safety model;
- `thatrebeccarae/claude-marketing` → skill `tiktok-ads`: expertise de campañas, Spark Ads, audiencias, TikTok Shop, Pixel/Events API y optimización;
- `AdsMCP/tiktok-ads-mcp-server`: alternativa read-only/analytics + OAuth, útil como referencia de seguridad.

Decisión Agentis: preparar contrato de adapter desde el inicio pero implementar después de Meta/Google salvo que la demanda de un cliente justifique adelantarlo.

### Capa multi-plataforma — investigar como acelerador

`adkit/ads-mcp` expone una interfaz MCP multi-plataforma para Google, Meta, TikTok, LinkedIn, Microsoft, Reddit y X Ads, y `adkit/ads-skills` aporta skills de estrategia para paid media.

Puede ser un acelerador para prototipos y comparación de adapters, pero no acoplar el core de Agentis a un proveedor multi-ads sin validar:
- cobertura real por plataforma;
- permisos;
- seguridad de escritura;
- versionado;
- costos;
- estabilidad;
- capacidad de atribución y reporting;
- límites frente a APIs oficiales.

Regla: **skills = cerebro/criterio; MCP/API = manos/ejecución; Agentis = guardrails, contexto, métricas y orquestación.**

## Flujo operativo recomendado

```text
Campaign Strategist
→ Campaign Spec normalizada
→ Content Factory genera/selecciona assets
→ Platform Operator traduce spec al canal
→ MCP/API crea draft o PAUSED
→ Validation Agent revisa estructura/políticas/tracking
→ Mati/HITL aprueba
→ Platform Operator activa
→ métricas de plataforma + CRM/outcomes
→ Performance Analyst
→ recomendación de iteración
```

La `Campaign Spec` debe ser agnóstica de canal tanto como sea posible y luego cada adapter hace la traducción específica.

Ejemplo de campos core:
- business objective;
- offer;
- funnel stage;
- audience intent/segment;
- geo;
- budget ceiling;
- experiment hypothesis;
- asset IDs;
- landing/WhatsApp destination;
- conversion event;
- tracking/UTM schema;
- approval policy.

## Métricas

Principio central:

> Optimizar por resultado de negocio, no por vanity metrics de la plataforma.

Medir por campaña/ad/creative cuando sea posible:
- spend;
- impressions/reach/frequency;
- CPM;
- CTR;
- CPC;
- landing/WhatsApp starts;
- leads;
- CPL;
- lead quality / qualification rate;
- booking rate;
- show rate;
- conversion/sale rate;
- CAC;
- revenue;
- ROAS / contribution margin cuando aplique;
- creative fatigue;
- tiempo hasta conversión;
- source/UTM/campaign/ad identifiers;
- segmento/offer/creative version;
- Content Factory asset ID;
- model/prompt/config version relevante.

Esto permite responder no sólo “qué anuncio tuvo más clicks”, sino:
- qué hook trae mejores clientes;
- qué creativo genera bookings reales;
- qué segmento tiene menor CAC;
- qué oferta retiene mejor;
- qué combinación funciona por vertical;
- qué assets deberían volver a producirse o eliminarse.

## Learning loop

```text
hipótesis
→ campaña
→ tráfico
→ conversación/lead
→ CRM
→ resultado real
→ atribución
→ análisis
→ aprendizaje
→ Content Factory genera nueva variante
→ nueva campaña
```

Cada experimento debería guardar:
- hipótesis;
- variable que cambia;
- control;
- ventana mínima de prueba;
- presupuesto usado;
- resultado;
- decisión;
- aprendizaje reutilizable.

La Ads Factory debe acumular conocimiento, no sólo campañas.

## Human-in-the-loop y seguridad de gasto

Al inicio:
- creación de borradores: automática;
- análisis: automático;
- recomendaciones de pausa/escalado: automáticas;
- publicación: aprobación humana;
- cambios grandes de presupuesto: aprobación humana;
- campañas nuevas/ofertas sensibles: aprobación humana.

Definir límites de gasto diarios/mensuales y kill-switch por cliente/cuenta.

Además:
- nunca permitir cambios de presupuesto sin respetar ceiling del cliente;
- registrar actor/agente/tool que realizó cada cambio;
- mantener before/after de configuración de campaña;
- preferir preview/dry-run cuando la herramienta lo permita;
- crear en PAUSED por defecto para nuevas campañas;
- separar permisos read vs manage cuando la plataforma lo soporte.

## Conexión con Business Operator

A futuro:

`Business Analyst detecta oportunidad → Campaign Agent define segmento/oferta → Content Factory crea assets → Ads Factory testea/distribuye → Lead Agent convierte → CRM registra → Performance Analyst mide → Business Operator recomienda siguiente acción`.

Ejemplos:
- baja ocupación martes → oferta puntual → creativos → campaña geolocalizada → bookings;
- clientes inactivos → segmento → campaña/remarketing → reactivación;
- nuevo servicio → test de oferta/ángulos antes de escalar;
- creatividad ganadora → Content Factory genera variantes controladas.

## Principios de diseño

1. **Content Factory crea; Ads Factory distribuye, experimenta y aprende.**
2. **Cada campaña debe tener hipótesis y objetivo de negocio.**
3. **No optimizar sólo por métricas de plataforma.**
4. **Conectar identidad de campaña/ad con CRM/outcomes siempre que sea posible.**
5. **HITL antes de gasto significativo hasta validar reglas.**
6. **API/MCP oficial > browser automation para operación productiva.**
7. **Canales como adapters.** Meta primero no debe acoplar el core a Meta.
8. **Guardar versiones de creative/copy/offer/audience/config para aprender.**
9. **Experimentar una variable por vez cuando se quiera inferencia clara.**
10. **El aprendizaje debe volver a Content Factory y al Business Operator.**
11. **Skills definen criterio; MCP/API ejecuta; Agentis controla permisos, trazabilidad y resultados.**
12. **Toda acción que gaste dinero debe tener policy explícita.**

## Roadmap sugerido

No priorizar Ads Factory antes del Lead/Booking Core. Secuencia razonable:

`Lead/Booking + CRM + tracking → Content Factory v1 → Ads Factory v0.1 → Meta Ads Operator → attribution CRM → experiment loop → Google Ads Operator → TikTok Ads Operator`.

Ads Factory v0.1 puede empezar sin auto-optimización:
1. Campaign Strategist genera plan;
2. Content Factory produce variantes;
3. Platform Operator prepara campaña en draft/PAUSED;
4. Mati aprueba;
5. Platform Operator publica;
6. ingestión automática de métricas;
7. Performance Analyst recomienda;
8. nueva iteración.

Automatizar publicación, presupuesto y escalado sólo después de tener datos suficientes y guardrails claros.

Última actualización: 2026-09-11.
