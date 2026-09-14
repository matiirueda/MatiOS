# Experimento: master imprimible para Pet Capsule

## Objetivo

Validar que una ilustración de mascota generada/asistida por IA pueda convertirse en un archivo maestro de calidad suficiente para imprenta y reutilizarse en múltiples productos físicos sin regenerar el arte desde cero.

## Hipótesis

Un mismo diseño maestro puede alimentar cuadros, stickers, tazas, fundas, remeras, buzos, mousepads, bordados y otros derivados, siempre que se generen variantes técnicas correctas por producto.

## Pipeline propuesto

1. Foto original de la mascota.
2. Skill `pet-illustration`: generar ilustración manteniendo identidad, expresión y rasgos distintivos.
3. Human-in-the-loop: corregir ojos, nariz, orejas, manchas, hocico, expresión y colores.
4. Crear un **master raster de alta resolución**.
5. Crear un **master vector/simplificado** para productos que lo requieran.
6. Derivar archivos específicos por producto.
7. Hacer prueba física con imprenta/proveedor.
8. Evaluar calidad real y ajustar el pipeline.

## Master raster

Objetivo: conservar textura y detalle para impresión.

Recomendación inicial:
- espacio de color maestro: sRGB salvo que el proveedor pida CMYK;
- 300 DPI al tamaño final de impresión;
- mantener una versión grande y reducir, no escalar desde una imagen chica;
- PNG/TIFF/JPEG según necesidad;
- idealmente fondo transparente cuando el producto lo permita.

Referencias de resolución:
- 50 x 50 cm @ 300 DPI ≈ 5906 x 5906 px;
- 70 x 70 cm @ 300 DPI ≈ 8268 x 8268 px.

## Master vector

Objetivo: obtener una versión limpia y escalable para stickers, bordado, logos, estampas planas y tufting.

Flujo tentativo en Illustrator:
1. partir del master raster;
2. Image Trace / Calco de imagen;
3. Expand;
4. limpiar nodos manualmente;
5. simplificar áreas y colores;
6. revisar contornos y huecos;
7. exportar AI/PDF/SVG según proveedor.

Importante: Illustrator no se usa para recuperar resolución del raster; se usa para obtener una versión vector/simplificada. El upscale debe ocurrir antes, en el master raster.

## Derivados por producto

### Cuadro / print
- PNG/TIFF/JPEG;
- 300 DPI al tamaño final;
- tamaños piloto: A4, A3, 30x40 cm;
- confirmar con imprenta si pide sRGB o CMYK.

### Funda de celular
- normalmente proveedor de sublimación/UV o especialista en fundas;
- usar plantilla exacta del modelo de teléfono;
- PNG transparente o JPEG según proveedor;
- respetar cámara, bordes y safe area;
- 300 DPI cuando corresponda.

### Sticker
- PNG 300 DPI o SVG/vector;
- agregar margen/cutline según proveedor.

### Taza
- raster 300 DPI;
- adaptar a plantilla y área imprimible del proveedor.

### Remera / buzo
- PNG transparente grande o vector según técnica;
- confirmar DTG, DTF, sublimación o serigrafía.

### Bordado / parche
- preferir vector/simplificado;
- reducir colores y microdetalle;
- validar ancho mínimo de líneas con el proveedor.

### Tufting
- no usar directamente el master de impresión;
- pasar por `skill-tufting-simplifier`;
- versión inicial ideal de 4–7 colores para aprendizaje;
- conservar el master original intacto.

## Arquitectura de archivos por mascota

Ejemplo:

```text
/Nami/
  original/
  master-raster/
  master-vector/
  tufting/
  print/
  case/
  apparel/
  stickers/
  embroidery/
  mockups/
```

Archivo fuente sugerido:
- `nami_master_v01`

Nunca regenerar la identidad desde cero para cada producto si el master ya fue aprobado.

## Prueba prevista

Primera candidata: Nami.

Crear:
1. master de impresión grande;
2. versión para cuadro/print;
3. versión sticker;
4. versión taza o funda;
5. enviar al proveedor/imprenta;
6. evaluar resultado físico.

## Checklist de prueba física

- [ ] El parecido se mantiene.
- [ ] Los negros no empastan demasiado.
- [ ] Los marrones conservan diferencia tonal.
- [ ] Los bordes se ven limpios.
- [ ] No aparecen artefactos de upscale.
- [ ] La imagen no se ve pixelada de cerca.
- [ ] La impresión conserva contraste.
- [ ] El proveedor respetó encuadre/safe area.
- [ ] La calidad percibida justifica venderlo.
- [ ] Registrar costo unitario y mínimos del proveedor.

## Próximo paso

Probar este flujo con Nami, mandar una muestra a imprenta/proveedor y registrar resultado real antes de automatizar o escalar.