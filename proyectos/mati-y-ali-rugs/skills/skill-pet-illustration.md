# Skill — Pet Illustration

## Propósito

Transformar una o más fotos de una mascota en una ilustración limpia, expresiva y comercializable, manteniendo identidad y parecido, y dejando una base reutilizable para rugs, stickers, cuadros, remeras, tazas, bordados y otros productos personalizados.

## Principio rector

Primero emoción y parecido. Después estilo.

La skill debe preservar los rasgos que hacen reconocible a la mascota antes de buscar una estética llamativa.

## Inputs

- 1 o más fotos de referencia.
- Producto objetivo: rug, sticker, cuadro, taza, remera, bordado u otro.
- Estilo deseado: cartoon, bold graphic, tattoo-inspired, cute, minimal, realista simplificado.
- Nivel de detalle: bajo, medio o alto.
- Preferencias de paleta o colores a evitar.

## Análisis visual previo

Antes de generar, describir estructuradamente:

- especie / raza aproximada;
- colores dominantes;
- patrón de manchas;
- forma de ojos;
- forma de orejas;
- hocico y nariz;
- expresión;
- pose;
- rasgos distintivos;
- energía percibida: tierna, divertida, noble, elegante, guerrera, dormilona, etc.

## Outputs

1. Descripción visual estructurada.
2. 3 variantes de estilo.
3. Prompt final elegido.
4. Lista de correcciones human-in-the-loop.
5. Versión final aprobada.
6. Nota sobre aptitud para tufting u otros productos.

## Principios de diseño

### Parecido
Mantener especialmente:

- ojos;
- hocico;
- nariz;
- orejas;
- manchas;
- expresión;
- inclinación de cabeza;
- sonrisa / lengua / mirada.

### Legibilidad
La ilustración debe entenderse rápido y tener una silueta clara.

### Reutilización
La base debe poder adaptarse a múltiples productos sin rehacer todo desde cero.

## Exploración por capas

### 1. Fiel / comercial
Alta similitud con la mascota.

### 2. Estilizada
Más lenguaje visual y personalidad.

### 3. Product-ready
Más simple, clara y adaptable a superficies y técnicas de producción.

## Prompt maestro

Crear una ilustración de una mascota basada en la foto de referencia. Mantener el parecido real del animal, especialmente ojos, hocico, orejas, manchas y expresión. Simplificar de forma elegante para que se vea como una ilustración comercial limpia y atractiva. Fondo limpio o mínimo. Composición centrada. Priorizar silueta clara, contraste y expresividad. Estilo: [ESTILO]. Nivel de detalle: [BAJO/MEDIO/ALTO]. Pensado para luego adaptarse a [PRODUCTO].

## Prompts por estilo

### Cartoon comercial
Crear una ilustración cartoon limpia y encantadora de esta mascota, manteniendo el parecido facial, las manchas y la expresión. Usar formas suaves, contornos claros, color plano con sombras simples y silueta bien definida. Debe sentirse tierna, vendible y apta para sticker, print y productos personalizados.

### Bold graphic
Crear una ilustración bold graphic de esta mascota, con contornos definidos, paleta reducida, lectura visual fuerte y composición simple. Mantener el parecido real en ojos, hocico y patrón de color. Pensada para funcionar muy bien en rug, print y remera.

### Tattoo-inspired
Crear una ilustración inspirada en diseño tattoo tradicional de esta mascota, manteniendo el parecido facial y los colores principales. Usar líneas claras, contraste alto, composición frontal o tres cuartos, rasgos expresivos, formas fuertes y lectura visual inmediata. Que se vea como una pieza artística pero comercializable.

### Realista simplificado
Crear un retrato ilustrado de esta mascota con estilo realista simplificado, manteniendo el parecido, la expresión y el patrón de color. Reducir microdetalles y dejar superficies limpias para futura adaptación a productos.

## Negative prompt / restricciones sugeridas

- no extra ears
- no distorted muzzle
- no wrong fur pattern
- no extra limbs
- no overly realistic human-like eyes
- no noisy background
- no text
- no hyper-detailed fur everywhere
- no anatomy distortion

## Human in the loop

### Checklist de identidad

- ¿Se parece a la mascota?
- ¿Los ojos son correctos?
- ¿El hocico está bien?
- ¿La nariz tiene forma y color correctos?
- ¿Las manchas están donde corresponden?
- ¿La expresión transmite lo mismo?
- ¿Las orejas respetan su forma real?

### Checklist comercial

- ¿Se entiende rápido?
- ¿La silueta funciona?
- ¿Queda linda como producto?
- ¿Tiene detalles inútiles que se pueden simplificar?
- ¿Puede derivarse a varias superficies?

### Correcciones típicas

- cambiar color de nariz;
- corregir manchas;
- ajustar orejas;
- mejorar expresión;
- simplificar pelaje;
- limpiar contornos;
- ajustar proporciones faciales.

## Workflow recomendado

1. Recibir fotos.
2. Extraer rasgos distintivos.
3. Generar 3 estilos.
4. Elegir una dirección.
5. Hacer revisión HITL.
6. Corregir rasgos clave.
7. Aprobar master illustration.
8. Derivar a producto específico.

## Regla de versionado

Guardar siempre:

- foto de referencia;
- prompt usado;
- seed/modelo cuando esté disponible;
- versión inicial;
- correcciones solicitadas;
- versión aprobada;
- notas sobre qué rasgos no se deben alterar.

Esto permite reproducibilidad y mejora continua del pipeline.
