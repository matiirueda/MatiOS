# Estándar operativo y económico inicial — Mati y Ali Rugs

Fecha de calibración: 2026-09-13

Este documento no intenta prometer rentabilidad. Define supuestos de trabajo prudentes para estimar materiales, precios y viabilidad hasta reemplazarlos por datos reales del taller y de los primeros pedidos.

## 1. Consumo de hilo: estándar inicial

Las fuentes serias coinciden en que el consumo varía mucho por altura de pelo, densidad, grosor/peso del hilo y técnica.

Referencias:
- Tuftingshop: aprox. 0,9 kg/m² con acrílico y 2,5 kg/m² con su lana para tufting.
- Mantra Studio Argentina: usa 1,4 kg/m² como base para cashmilon/acrílico y recomienda margen de seguridad; para cut pile/principiantes sugiere +20%.

### Regla de Mati y Ali hasta medir producción propia

- Estimación base acrílico: 1,4 kg/m².
- Compra inicial segura: 1,68 kg/m² (= 1,4 x 1,20).
- No usar 2,5 kg/m² como estándar de acrílico: ese número corresponde a otra fibra/peso/densidad.
- Después de 5 piezas, sustituir este estándar por promedio real por tipo de hilo, altura y densidad.

### Referencias por tamaño

- 30x30 cm (0,09 m²): rango externo 81–126 g; compra segura con estándar Mantra +20% ≈ 151 g.
- 60x60 cm (0,36 m²): rango externo 324–504 g; compra segura ≈ 605 g.
- 100x100 cm (1 m²): rango externo 0,9–1,4 kg; compra segura ≈ 1,68 kg.

El dato popular de “100 g para 30x30” y “400–500 g para 60x60” es razonable. Para 1x1, 1,4–2 kg puede servir como buffer, pero no debe confundirse con consumo medio comprobado de acrílico.

## 2. Costos argentinos observables (snapshot, no lista definitiva)

### Hilo acrílico / Cashmilon semigordo

- Puntos y Tramas: Cashmilon 4/7 de 100 g a ~$3.410 -> ~$34.100/kg.
- Mercado Libre: Cashmilon 4/7 de 100 g alrededor de $4.950 -> ~$49.500/kg.

Objetivo del proyecto: conseguir precio directo/fábrica por debajo del retail mediante proveedor conocido, compras repetidas y escalas por volumen.

### Tela primaria

- Panamá rústico apto tufting: ejemplo de 3 x 1 m a ~$22.000 -> ~$7.333/m² antes de desperdicio de bastidor.
- Recordar que se compra más superficie que el área final de la alfombra por márgenes de tensión y recorte.

### Adhesivo

- Maderplast W-740 5 kg observado alrededor de ~$69.990 -> ~$14.000/kg.
- Rendimiento publicado para película de 2 mm: 600–800 g/m².
- Referencia teórica: ~$8.400–$11.200 de adhesivo por m².
- Validar consumo real de tufting en el taller; no asumir que el rendimiento de ficha técnica equivale exactamente al proceso artesanal.

### Backing, packaging y otros

Todavía sin estándar. Deben medirse por unidad y separarse de hilo/tela/adhesivo.

## 3. Costo mínimo conocido por m² (antes de backing, packaging y mano de obra)

Con acrílico base 1,4 kg/m²:

- Hilo: aprox. $47.740–$69.300/m² usando precios minoristas observados.
- Tela primaria: referencia ~$7.333/m², más desperdicio de bastidor.
- Adhesivo: referencia ~$8.400–$11.200/m².

Core observable: aprox. $63.000–$88.000/m² antes de backing, bordes, packaging, desperdicio adicional, comisiones, marketing y mano de obra.

Con margen de hilo +20% para primeras piezas, el core sube. El precio fábrica del hilo puede bajarlo significativamente.

## 4. Caso MVP: alfombra del living de Matías

Bounding box pensado: ~180 x 100/110 cm = 1,80–1,98 m² rectangulares.

Como el diseño será orgánico y no rectangular, usar un `shape_fill_ratio` hasta medir el SVG/dibujo real. Supuesto provisional: 75–85% del rectángulo.

Área tufted provisional: ~1,35–1,68 m².

Hilo seguro usando 1,4 kg/m² +20%: ~2,27–2,82 kg.

Con precios minoristas observados, solo el hilo podría rondar aproximadamente $77k–$140k. Conseguir precio fábrica puede mejorar mucho este número.

Para la tela primaria no usar el área orgánica: el bastidor necesita un paño rectangular con margen. Medir bastidor real antes de comprar.

Objetivo del MVP: reemplazar todos estos supuestos por datos reales.

## 5. Rentabilidad: corrección importante

No utilizar frases como “200–300% de margen”. El margen porcentual sobre venta no puede superar 100%.

Distinguir:

- Markup = (precio - costo) / costo.
- Margen bruto = (precio - costo) / precio.

Ejemplo: costo $100 y venta $300 = 200% de markup, pero 66,7% de margen bruto.

## 6. Fórmula de precio estándar

No usar solo `materiales x 2` o `materiales x 3`.

Precio mínimo sostenible:

`materiales + mano de obra + costos indirectos + adquisición/comisiones + margen del negocio`

Separar:

1. Materiales directos.
2. Mano de obra real (diseño, trazado, tufting, pegado activo, shaving/carving, backing, packaging).
3. Overhead/amortización (herramientas, repuestos, electricidad, desperdicio, espacio, mantenimiento).
4. Comercial (CAC, comisión de cobro, envío subsidiado, impuestos atribuibles).
5. Ganancia/reinversión de la empresa.

Mantra publica una calculadora que separa materiales, horas y margen. Tomar sus valores hora solo como referencia comercial, no como verdad; el valor hora propio debe derivarse de objetivos y mercado.

## 7. Tiempo: no asumir todavía 4–6 h como estándar

Hay ejemplos de comunidad de 60x60/medianos hechos en pocas horas, pero también piezas donde solo el carving requiere 4 h o el total supera 10 h.

Por eso:
- no presupuestar el negocio con un tiempo fijo tomado de internet;
- medir cada etapa en el curso;
- medir las primeras 5 piezas;
- crear coeficientes por área + complejidad + número de colores + nivel de carving.

Variables propuestas:
- area_m2
- num_colors
- complexity_score 1–5
- carving_score 1–5
- organic_edge_score 1–5
- hours_actual

## 8. Capacidad productiva

No adoptar “20–30 alfombras/mes por persona” como hecho. Es posible solo para determinadas medidas, complejidad y nivel de eficiencia.

La capacidad debe calcularse con horas reales:

`capacidad mensual = horas productivas disponibles / horas promedio por pieza`

Registrar por tamaño/categoría. La restricción principal del negocio será mano de obra artesanal y acabado, no la web.

## 9. Mercado / precio: estándar de posicionamiento

Las búsquedas actuales en Argentina muestran una dispersión fuerte:
- piezas chicas y simples desde decenas de miles de ARS;
- 1x1 personalizados observados alrededor de ~$295k a ~$445k según vendedor/diseño/canal;
- piezas deco de ~150x120 publicadas alrededor de ~$380k;
- múltiples marcas trabajan a pedido y aceptan cambios de color/tamaño.

Conclusión: existe disposición a pagar por personalización, pero no garantiza volumen. La posición buscada es `diseño + custom + buena terminación + experiencia digital`, no competir contra alfombra industrial.

## 10. Hipótesis comercial a validar

Tres niveles:

### Standard
- diseños repetibles;
- paletas cerradas;
- menor costo/precio;
- aprovecha compra en volumen y remanentes;
- menor tiempo de diseño y setup.

### Semi-custom
- base existente;
- cambio de tamaño/colores;
- recargo medio.

### Full custom
- diseño/adaptación desde cero;
- compra potencial de colores especiales;
- más iteraciones;
- recargo por diseño, complejidad y riesgo.

## 11. Marketing

El contenido de proceso es un activo real, pero no asumir que “se vende solo”. Testear:
- Instagram/Reels;
- TikTok;
- Pinterest orgánico y pago;
- Meta Ads;
- remarketing;
- contenido de antes/después, carving, trazado con proyector, instalación final y mockups.

Medir CAC y conversión por canal. La viralidad es upside, no parte obligatoria de la economía base.

## 12. Criterio GO / TEST / NO-GO

Después del curso + primera pieza grande + primeras 5 ventas:

### GO
- calidad vendible consistente;
- Ali disfruta la producción;
- demanda real al precio objetivo;
- margen de contribución positivo después de materiales, mano de obra y CAC;
- tiempos compatibles con capacidad deseada;
- poca necesidad de stock muerto.

### TEST / AJUSTAR
- interés alto pero margen bajo;
- tiempos demasiado altos;
- demasiadas revisiones custom;
- desperdicio alto;
- CAC alto pero buena conversión orgánica.

### NO-GO / PAUSAR
- no hay disposición a pagar un precio que cubra trabajo real;
- producción resulta frustrante o demasiado lenta;
- calidad no llega a estándar tras práctica razonable;
- CAC + producción destruyen el margen.

## Fuentes base

- Tuftingshop, “How much rug yarn do I need?”: https://tuftingshop.com/blogs/faq/how-much-rug-yarn-do-i-need
- Mantra Studio, calculadora de lana: https://mantrastudio.com.ar/calculadora-lana-tufting/
- Mantra Studio, calculadora de precios: https://mantrastudio.com.ar/calculadora-precios-tufting/
- Rugs Dragons, materiales/herramientas: https://www.rugsdragons.ar/blog/que-necesito-para-hacer-tufting-materiales-y-herramientas
- Rugs Dragons, pricing: https://www.rugsdragons.ar/blog/como-puedo-fijar-el-precio-de-mi-alfombra-tufting
- Maderplast W-740/C-109 fichas y rendimientos: https://www.maderplast.com.ar/
- Mercado argentino: Mercado Libre, Don Tapetto, Estudio Enredo y benchmarks registrados en `benchmarks-y-links.md`.

## Regla final

Internet sirve para construir un prior. El negocio se decide con nuestros datos. Cada pieza debe reemplazar un supuesto por una medición real.
