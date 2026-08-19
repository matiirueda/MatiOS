---
name: matios-nutrition
description: Planificar alimentación práctica, buscar o crear recetas, organizar meal prep, calcular una lista de compras y registrar comidas en MatiOS. Usar ante pedidos de menú semanal, lista del supermercado, qué comer, qué cocinar con stock disponible, cómo conservar sobras o cómo adaptar la alimentación al entrenamiento y objetivo vigente.
---

# Nutrición MatiOS

## Propósito
Responder sobre comidas usando objetivos vigentes, actividad del día, historial reciente, preferencias y recetario MatiOS.

## Flujo
1. Leer objetivo nutricional vigente; no asumir calorías/macros históricos como permanentes.
2. Consultar entrenamiento/actividad del día si es relevante.
3. Consultar comidas recientes cuando exista DB.
4. Buscar recetas en `recetas/`.
5. Recomendar opciones simples, nutritivas y compatibles con el objetivo.
6. Favorecer variedad de alimentos y micronutrientes, no solo macros.
7. Si una receta nueva se prueba y funciona, enviar el aprendizaje a Memory Curator para actualizar el recetario.

## Plan semanal y lista de compras

1. Reunir objetivo vigente, personas, comidas a cubrir, horarios, entrenamientos, presupuesto, preferencias, restricciones y tiempo para cocinar.
2. Leer inventario de alacena, heladera y freezer; priorizar abiertos y próximos a vencer.
3. Seleccionar recetas canónicas y repetir bases de manera intencional sin repetir siempre el mismo plato.
4. Escalar ingredientes por porciones y sumar cantidades normalizadas.
5. Restar stock utilizable sin llevar cantidades por debajo de cero.
6. Consolidar la compra por ingrediente y unidad; agrupar por rubro y marcar opcionales o sustituciones.
7. Producir menú, sesión de meal prep, porciones de heladera/freezer, descongelados y lista final.
8. Guardar el plan como borrador y solicitar revisión profesional cuando incluya objetivos calóricos, macros individualizados, restricciones médicas o cambios relevantes.

Usar `../../recetas/esquemas/plan-semanal.schema.yaml` y `../../recetas/esquemas/lista-compras.schema.yaml`. No inventar cantidades de stock ni tratar una estimación nutricional como medición exacta.

## Registro conversacional

- Aceptar texto, audio transcripto o foto descrita como registro aproximado.
- Separar lo observado de lo estimado y conservar unidades, porciones y nivel de confianza.
- Preguntar solo cuando la ambigüedad pueda cambiar materialmente el seguimiento.
- No reprender por una comida aislada; analizar tendencia semanal, adherencia y contexto.
- Conectar sobras con conservación y futuras comidas: qué queda, dónde se guarda, hasta cuándo y cómo reutilizarlo.

## Aprobación

- Distinguir `draft`, `pending_review`, `approved`, `changes_requested` y `archived`.
- Permitir recomendaciones generales y selección de recetas sin aprobación individual.
- Requerir revisión de ustedes antes de asignar un plan nutricional individual nuevo o modificar metas, restricciones clínicas o suplementación.
- Mostrar al alumno únicamente la última versión aprobada, sin ocultar que las calorías y macros son estimaciones.

## Principios nutricionales del recetario

### Densidad + diversidad
No buscar un único “superalimento” ni intentar meter todos los nutrientes en cada comida. Optimizar la alimentación a nivel del día y especialmente de la semana: variedad de alimentos de buena calidad, suficiente proteína, fibra y diversidad de micronutrientes.

### Proteínas variadas
Rotar entre pollo, huevos, pescado, lácteos altos en proteína, tofu, legumbres y otras fuentes. Combinar fuentes animales y vegetales cuando mejore la variedad nutricional sin sacrificar practicidad o sabor.

### Vegetales y frutas
Favorecer verduras de distintos tipos y colores (por ejemplo brócoli, morrón, zanahoria, cebolla, espinaca, tomate y hongos) y rotar frutas según disponibilidad y estación.

### Carbohidratos según contexto
Usar avena, arroz, papa, batata, pasta/orzo, frutas y legumbres según la comida, el hambre y la actividad/entrenamiento del día. No tratar los carbohidratos como algo a evitar por defecto.

### Grasas, frutos secos y semillas
Incorporar aceite de oliva, frutos secos, mantequilla de maní, palta, chía, lino y sésamo para sumar variedad y densidad nutricional, cuidando cantidades cuando sea relevante por su densidad calórica.

### Snacks y postres que den ganas de comer
Priorizar recetas caseras que sean realmente ricas y sostenibles. Yogur griego, avena, cacao, fruta, whey, huevo, frutos secos y chocolate amargo funcionan como caja de herramientas para reemplazar con frecuencia snacks ultraprocesados sin convertir el postre en una comida “de dieta”.

### Recetas como conocimiento iterativo
Distinguir entre idea y receta validada:
- 🧪 Pendiente de probar.
- 🔧 Probada, necesita ajustes.
- ✅ Probada y aprobada.

Cuando se prueba una receta, capturar cantidades reales, marcas relevantes, rendimiento, tiempos, textura, sabor, cambios realizados y macros si aportan valor. Actualizar la ficha existente en vez de crear versiones desconectadas.

## Principio general
La dieta debe poder sostenerse. Usar estructura y defaults para reducir decisiones, sin convertir cada comida en una optimización obsesiva. El objetivo no es maximizar nutrientes en una sola comida sino construir, con recetas que realmente se disfrutan, una alimentación semanal diversa y de alta calidad.
