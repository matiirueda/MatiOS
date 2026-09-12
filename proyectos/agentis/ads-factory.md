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

### Performance Analyst

Une métricas de plataforma con métricas de negocio. No optimizar sólo por CTR o CPC si el objetivo real es booking, venta, revenue o lead de calidad.

### Budget / Experiment Controller

Aplica reglas de test, límites y escalado. Inicialmente recomendado como sistema de recomendaciones + aprobación humana; automatizar gasto sólo cuando las reglas estén bien validadas.

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
6. **API oficial > browser automation para operación productiva.**
7. **Canales como adapters.** Meta primero no debe acoplar el core a Meta.
8. **Guardar versiones de creative/copy/offer/audience/config para aprender.**
9. **Experimentar una variable por vez cuando se quiera inferencia clara.**
10. **El aprendizaje debe volver a Content Factory y al Business Operator.**

## Roadmap sugerido

No priorizar Ads Factory antes del Lead/Booking Core. Secuencia razonable:

`Lead/Booking + CRM + tracking → Content Factory v1 → Ads Factory v0.1 → Meta Ads adapter → attribution CRM → experiment loop → Google/TikTok adapters`.

Ads Factory v0.1 puede empezar sin auto-optimización:
1. Campaign Strategist genera plan;
2. Content Factory produce variantes;
3. Mati aprueba;
4. publicación manual/semi-automática;
5. ingestión automática de métricas;
6. Performance Analyst recomienda;
7. nueva iteración.

Automatizar publicación, presupuesto y escalado sólo después de tener datos suficientes y guardrails claros.

Última actualización: 2026-09-11.
