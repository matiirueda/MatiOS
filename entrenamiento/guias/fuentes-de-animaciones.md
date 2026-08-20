# Fuentes de animaciones de ejercicios

## Decisión para el prototipo MatiOS

MatiOS puede enlazar temporalmente animaciones de `ExerciseGymGifsDB` para validar la experiencia privada. Cada ficha debe registrar proveedor, identificador externo, URL, estado de licencia y necesidad de reemplazo.

La colección pública expone 1.323 ejercicios mediante archivos JSON y CDN. Su autor aclara que recopiló los GIF de Internet y que no concede derechos sobre ellos. Otra distribución atribuye esos medios a GymVisual. Por eso, que una URL sea pública no convierte el recurso en reutilizable comercialmente.

## Reglas

1. Usar el GIF solo como referencia temporal en el prototipo privado.
2. No copiar la colección completa ni presentarla como propia.
3. No inferir que pagar a un revendedor concede una licencia válida.
4. Guardar siempre `animacion_proveedor`, `animacion_id_externo`, `animacion_licencia` y `animacion_uso`.
5. Para clientes o publicación comercial, reemplazar por video propio o medio con licencia comercial verificada.
6. La técnica escrita y revisada en la ficha prevalece sobre el GIF si existe alguna diferencia.
7. Descargar o cachear únicamente la rutina activa cuando se implemente el modo sin conexión.

## Fuente temporal

- Catálogo: <https://github.com/JahelCuadrado/ExerciseGymGifsDB>
- Versión fijada: `v1.1.0`
- Uso en MatiOS: `prototipo-interno`
- Licencia de los medios: `temporal-no-verificada`

## Migración futura

El identificador canónico de MatiOS no depende del proveedor visual. Al reemplazar una animación solo deben cambiar los campos `animacion_*`; rutinas, registros históricos y enlaces a la ficha permanecen estables.
