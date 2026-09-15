# Amarte Deco — materiales, habilidades manuales y expansión v0

## Idea central

Amarte Deco no se piensa como una marca de una sola categoría. Nace con rugs/tufting, pero el sistema está diseñado para crecer de forma progresiva incorporando nuevas habilidades manuales y nuevas capacidades digitales.

La regla de crecimiento sigue siendo la de MatiOS:

> validar barato → producir bajo demanda → medir → recién después comprar activos o escalar stock.

La expansión no se hace agregando productos al azar. Cada nueva categoría debe cumplir al menos una de estas condiciones:

- comparte cliente, estética o ocasión de compra con el catálogo actual;
- reutiliza materiales, herramientas, contenido o proveedores;
- puede producirse con baja inversión inicial;
- permite mejorar ticket medio, frecuencia de compra o personalización;
- crea contenido y aprendizaje reutilizable para la Content Factory;
- puede validarse sin stock grande.

## División de roles

### Ali — capa manual / productiva

Ali incorpora habilidades artesanales de forma progresiva. Cada curso debe abrir una capacidad productiva concreta.

Secuencia inicial propuesta:

1. tufting básico;
2. práctica continua y terminaciones;
3. relieve / carving / texturas 3D;
4. almohadones tufted;
5. velas de diseño;
6. bases y objetos de yeso/jesmonite u otros materiales compatibles;
7. pintura y terminaciones decorativas;
8. futuras técnicas manuales según demanda real.

No se busca que Ali aprenda todo de golpe. Se incorpora una técnica, se hacen prototipos, se mide y recién después se decide si entra al catálogo.

### Mati — capa digital / comercial

Mati construye y opera:

- branding;
- web y e-commerce;
- diseño asistido por IA;
- mockups;
- configuradores;
- catálogo;
- fotografía y edición;
- Content Factory;
- CRM y WhatsApp;
- automatizaciones;
- pricing y costeo;
- proveedores;
- stock;
- analytics;
- SEO, redes y campañas;
- sistemas de recomendación y filtros por paleta.

La tesis es que la infraestructura digital se reutiliza para todas las categorías nuevas.

## Costo de trabajo vs costo de caja

Durante la etapa inicial, tanto el trabajo manual de Ali como el trabajo digital de Mati pueden tener **costo de caja prácticamente nulo**, porque son realizados por los propios fundadores.

Sin embargo, el sistema debe registrar igualmente las horas teóricas de trabajo de ambos. Esto permite:

- conocer la economía real del producto;
- detectar productos que venden pero consumen demasiado tiempo;
- proyectar qué pasa si mañana hay que contratar ayuda;
- evitar precios artificialmente bajos difíciles de sostener.

Por lo tanto se distinguen dos métricas:

- **cash cost:** dinero efectivamente desembolsado;
- **economic cost:** cash cost + valor teórico de horas de trabajo + desperdicio + overhead.

En MVP se puede priorizar caja, pero nunca perder el registro del costo económico.

## Roadmap inicial de categorías

### 1. Rugs

Categoría de entrada y laboratorio principal.

Aprendizajes:
- tufting;
- tensión de tela;
- densidad;
- carving;
- terminación;
- adhesivos;
- backing;
- consumo de hilo;
- fotografía de textura;
- personalización.

### 2. Almohadones tufted

Extensión natural del rug:

- mismo universo visual;
- misma técnica base;
- menor tamaño;
- ticket complementario;
- permite explorar relieve y 3D;
- fácil de combinar con rugs en colecciones.

Benchmark relevante: Bengal Rugs vende almohadones tufted y personalizados, validando que la categoría puede convivir naturalmente con rugs.

### 3. Velas de diseño

Categoría atractiva por:

- moldes reutilizables;
- inversión inicial relativamente baja;
- enorme libertad de formas y color;
- percepción de valor alta si el diseño y packaging son buenos;
- buena combinación con regalos y deco.

Antes de comercializar se debe validar:

- tipo de cera;
- mecha adecuada;
- recipiente o molde;
- pruebas de quemado;
- estabilidad térmica;
- etiquetado y advertencias;
- seguridad del producto.

El objetivo no es vender velas genéricas, sino piezas alineadas con la identidad de Amarte Deco.

### 4. Bases y pequeños objetos decorativos

Explorar materiales de baja barrera de entrada, por ejemplo:

- yeso;
- jesmonite o alternativas disponibles localmente;
- bandejas;
- portavelas;
- posavasos;
- pequeñas esculturas;
- jaboneras;
- macetas pequeñas;
- floreros decorativos.

La lógica es aprender moldes, pigmentos, lijado, sellado y terminaciones.

### 5. Cuadros y láminas

Categoría de prioridad alta porque aprovecha inmediatamente la capacidad digital.

Modelo:

- catálogo pequeño y curado;
- impresión bajo demanda al principio;
- múltiples tamaños y marcos;
- variantes de color;
- diseños propios, IA propia, dominio público o con licencia comercial;
- personalización desde una foto o idea del cliente.

No asumir que una imagen es libre porque múltiples tiendas la vendan. Registrar origen/licencia de cada artwork.

## Sistema de paletas como ventaja competitiva

Cada producto debe guardar metadata visual estructurada.

Ejemplo:

```yaml
palette:
  - crema
  - terracota
  - oliva
style: organico
room:
  - living
  - dormitorio
temperature: calida
contrast: medio
```

Filtros futuros:

- por color;
- por combinación de colores;
- por temperatura visual;
- por ambiente;
- por estilo;
- por contraste.

Esto permite navegar Amarte Deco no solo por categoría, sino también por universos visuales:

- Terracota + crema;
- Oliva + arena;
- Bordó + mostaza;
- Blanco + negro + madera;
- etc.

## Recomendador por ambiente

Visión futura:

1. el cliente sube una foto del ambiente;
2. el sistema analiza colores dominantes, materiales y contraste;
3. propone una o varias paletas compatibles;
4. filtra el catálogo real según esas paletas;
5. recomienda rugs, cuadros, almohadones y objetos compatibles;
6. opcionalmente genera un mockup del ambiente.

La IA no debe ser el producto que se vende. La propuesta para el cliente es simple:

> “Mostranos tu espacio y te ayudamos a encontrar lo que mejor le queda.”

## Catálogo que aprende

Cada personalización puede crear inventario digital nuevo.

Ejemplo:

1. cliente pide un cuadro en tonos verdes;
2. se generan varias variantes;
3. una se aprueba y produce;
4. las variantes reutilizables se revisan;
5. las mejores pueden incorporarse al catálogo;
6. se etiquetan por paleta, estilo y ambiente.

Lo mismo aplica a rugs y otras piezas custom.

El objetivo es que los pedidos personalizados aumenten el valor del catálogo en vez de ser trabajos aislados que desaparecen luego de la entrega.

## Curaduría e importación — etapa posterior

Amarte Deco puede evolucionar de “todo lo hacemos nosotros” a una combinación de:

1. **Hecho por Amarte:** producción manual propia.
2. **Diseñado por Amarte:** diseño propio producido por terceros.
3. **Curado por Amarte:** productos de terceros seleccionados por estética/calidad.

La importación desde China u otros mercados se considera solo cuando:

- ya existe caja del negocio;
- hay señales claras de demanda;
- el producto completa colecciones existentes;
- se puede probar con una cantidad pequeña;
- el margen compensa logística, impuestos, devoluciones y riesgo de stock.

No comprar stock grande solo porque un producto parece atractivo.

## Flywheel de habilidades

La expansión ideal funciona así:

curso → prototipo → medición → contenido → primeras ventas → mejora → SOP → catálogo → automatización / escala

Cada habilidad manual nueva genera simultáneamente:

- nuevos productos;
- contenido;
- aprendizaje de materiales;
- proveedores;
- nuevas búsquedas de clientes;
- datos de costos y tiempos;
- oportunidades de cross-sell.

## Principio de capital eficiente

Mientras Mati y Ali puedan aportar trabajo propio, la inversión debe concentrarse primero en:

- insumos;
- cursos que abran capacidad real;
- herramientas mínimas;
- moldes/prototipos;
- adquisición de clientes;
- packaging necesario;
- infraestructura reutilizable.

La ventaja inicial es poder aprender y producir sin una estructura salarial externa. Aun así, registrar siempre el costo económico teórico para que el modelo siga siendo válido cuando haya que delegar.

## Criterio para habilitar una nueva categoría

Antes de lanzar una categoría responder:

1. ¿Encaja con Amarte Deco?
2. ¿La podemos validar con poca inversión?
3. ¿Se puede fabricar bajo pedido o con stock mínimo?
4. ¿Tenemos o podemos aprender la técnica?
5. ¿Tiene margen luego de incluir tiempo real?
6. ¿Genera contenido útil?
7. ¿Permite cross-sell?
8. ¿Se puede sistematizar?
9. ¿Tiene riesgos de seguridad o regulación que debamos validar?
10. ¿Qué dato concreto nos haría decidir escalarla?

Si no sabemos responder, queda en backlog de experimentos y no entra todavía al catálogo.
