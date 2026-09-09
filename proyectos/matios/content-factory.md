# Content Factory — UGC + publicidad para todos los negocios

## Idea central

El proyecto UGC no se trata como un negocio aislado. Funciona como laboratorio para construir una **Content Factory** reutilizable en todo Mati OS.

La misma infraestructura debe servir para:

1. Crear UGC para marcas de terceros y generar ingresos.
2. Crear publicidad para productos y servicios propios.
3. Alimentar contenido de Agentis, proyectos tech, e-commerce, cuadros y futuros negocios.
4. Convertirse más adelante en un producto/servicio vendible por Agentis como **Content Factory as a Service**.

La regla es simple: **una capacidad que construimos debe servir a varios negocios y reducir trabajo humano, no crear otro sistema aislado para mantener.**

## Flujo objetivo

```text
Producto / brief
  ↓
Research de cliente, competencia, reviews y pains
  ↓
Ángulos de venta
  ↓
Hooks
  ↓
Guiones
  ↓
Shot list / instrucciones de grabación
  ↓
Humano graba
  ↓
Edición asistida por IA
  ↓
Variantes / repurposing
  ↓
Publicación orgánica y/o pauta
  ↓
Métricas
  ↓
Aprendizaje
  ↓
Nueva iteración creativa
```

Objetivo operativo: que la mayor parte del sistema ocurra de manera automática y que el humano intervenga principalmente para **aprobar, grabar y tomar decisiones importantes**.

## Agentes previstos

### Research Agent

Investiga:
- producto y categoría;
- cliente ideal;
- competencia;
- anuncios existentes;
- reviews;
- Reddit, comentarios y lenguaje real del usuario;
- objeciones, deseos y pains.

Salida: insights estructurados que alimentan al Creative Strategist.

### Creative Strategist

Genera múltiples conceptos creativos para el mismo producto:
- problema → solución;
- testimonial;
- demo;
- comparación;
- tutorial;
- storytelling;
- before/after;
- lista;
- objeción;
- caso de uso;
- advertorial / educational;
- performance ad.

Debe priorizar variedad real de hipótesis, no simples reescrituras del mismo anuncio.

### Hook Agent

Genera y rankea hooks de apertura para cada concepto.

Objetivo: producir suficientes variantes para testear creatividades sin multiplicar el trabajo humano.

### Script Writer

Convierte concepto + hook en guiones adaptados a distintos formatos:
- 15 s;
- 30 s;
- 60 s;
- Reel;
- TikTok;
- Short;
- paid ad;
- contenido orgánico.

### Production Director

Transforma el guion en una guía accionable de grabación:
- talking head;
- plano producto;
- screen recording;
- B-roll;
- cambios de plano;
- props;
- tomas extra reutilizables;
- indicaciones para grabar una sesión larga que pueda reutilizarse en muchas piezas.

### Human in the Loop

Rol humano principal:
- aprobar concepto;
- corregir información sensible/comercial;
- grabar;
- aprobar versión final cuando corresponda.

La IA automatiza el trabajo alrededor de la presencia humana, no intenta reemplazar lo que da autenticidad al contenido.

### Video / Editing Agent

Responsabilidades objetivo:
- transcripción;
- selección de clips;
- eliminación de silencios;
- cortes;
- subtítulos;
- sugerencia o inserción de B-roll;
- reencuadre;
- zooms y énfasis;
- versiones por plataforma;
- preparación de assets.

### Repurposing Agent

De una misma sesión de grabación debe poder producir múltiples piezas.

Ejemplo:

```text
10 minutos de material humano
  → review
  → problema/solución
  → testimonial
  → 3 cosas que...
  → versión 15 s
  → versión 30 s
  → múltiples hooks A/B/C
  → Reel
  → TikTok
  → Short
  → paid ads
  → frame grabs / creatividades estáticas
```

Principio: **maximizar output por minuto humano grabado.**

### Publishing Agent

Gestiona:
- calendario;
- copies;
- metadata;
- organización de assets;
- nombres y versiones;
- publicación cuando sea conveniente y segura;
- vínculo entre pieza, campaña y producto.

### Performance Agent

Mide y aprende de:
- retención;
- hook rate;
- watch time;
- CTR;
- conversión;
- CPA/CAC;
- ROAS cuando aplique;
- performance por concepto, hook y duración.

El objetivo es cerrar el loop:

```text
CREAR → PUBLICAR → MEDIR → APRENDER → CREAR MEJOR
```

## Tres vías de negocio

### 1. Mati UGC Creator

Mati funciona como creador UGC para terceros.

Objetivos:
- generar ingresos;
- construir portfolio;
- aprender qué compran las marcas;
- alimentar la Content Factory con casos reales;
- financiar el desarrollo del sistema.

El valor comercial no depende necesariamente de tener una gran audiencia: se vende la capacidad de crear piezas que una marca pueda publicar o utilizar en pauta.

### 2. Content Factory para negocios propios

La misma máquina crea publicidad para cualquier producto propio.

Ejemplos:

#### Agentis

```text
"Una cancha pierde reservas todos los días por responder tarde WhatsApp..."
→ demo real del agente
→ reserva
→ CTA
```

Una grabación puede transformarse en numerosos anuncios.

#### Negocio de cuadros

```text
"Quería hacer un cuadro de este momento pero ninguna foto me convencía..."
→ transformación con IA
→ selección
→ impresión
→ producto en pared
```

#### Proyecto / página tech

```text
"Esta TV cuesta X acá y Y acá. Armé un sistema que revisa precios todos los días..."
→ demo
→ comparación
→ CTA
```

La Content Factory debe ser agnóstica al producto.

### 3. Content Factory as a Service

Posible oferta futura desde Agentis:

> Una persona de la empresa graba una sesión corta semanal. La Content Factory transforma ese material en contenido y anuncios para toda la semana.

Esto puede convertirse en un servicio B2B que combine:
- automatización;
- agentes;
- workflows;
- contenido;
- publicidad;
- analytics;
- human in the loop.

## Estrategia técnica

Seguir el patrón general de Mati OS / Agentis:

```text
Prototipo rápido en n8n
  ↓
Validación humana
  ↓
Medición
  ↓
Componentes reutilizables
  ↓
Reimplementación en código cuando aporte valor
  ↓
Agentes especializados
  ↓
Orquestación común
```

No sobreconstruir de entrada.

Cada módulo debe diseñarse para ser reutilizado por más de un negocio.

## Principios de arquitectura

1. **Shared infrastructure first.** Evitar pipelines separados por cada negocio.
2. **Human in the loop.** Automatizar producción y análisis, mantener aprobación humana donde agregue valor.
3. **One recording → many assets.** Minimizar tiempo de cámara.
4. **Measure everything.** Cada contenido es un experimento.
5. **Creative variety over paraphrasing.** Testear hipótesis distintas.
6. **n8n first, code when justified.** Aprender y validar antes de sofisticar.
7. **External UGC trains internal advertising.** Los trabajos para terceros mejoran la infraestructura usada por nuestros propios negocios.
8. **Build once, use everywhere.** Todo componente nuevo debe evaluarse por cuántos proyectos puede beneficiar.

## Primer experimento sugerido

Objetivo inicial:

```text
10 videos buenos
→ 1 portfolio
→ 50 prospectos
→ primer trabajo UGC pago
```

En paralelo medir:
- minutos humanos por video;
- minutos de grabación;
- número de piezas obtenidas por sesión;
- tiempo de edición manual;
- porcentaje automatizado;
- performance de hooks;
- cantidad de componentes reutilizables.

La meta no es convertirse solamente en creador UGC. La meta es usar UGC como terreno real de entrenamiento para construir una **máquina de contenido y publicidad reutilizable en todo Mati OS**.
