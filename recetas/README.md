# 🍳 Recetario MatiOS

Fuente de verdad de las recetas que Mati usa, quiere probar o quiere adaptar a sus objetivos.

## Objetivo

Guardar recetas en un formato simple y reutilizable para que MatiOS pueda:

- recomendar comidas según momento del día y entrenamiento;
- estimar macros y calorías;
- priorizar recetas ricas en proteína y nutrientes;
- reutilizar ingredientes que Mati suele tener en casa;
- distinguir recetas probadas de recetas pendientes;
- registrar variantes y mejoras después de probarlas;
- indicar cómo conservar, congelar, descongelar y recalentar cada preparación;
- sugerir cuándo conviene cocinar de más para simplificar la semana.

## Estructura

- `desayunos-meriendas/` — pancakes, bowls y opciones rápidas.
- `batidos/` — pre/post entreno y batidos proteicos.
- `postres-snacks/` — alternativas dulces, alfajores, cookies y puddings.
- `platos-principales/` — almuerzos y cenas.
- `bases-toppings/` — preparaciones reutilizables: proteína casera, salsas, mermeladas, semillas, etc.
- `guias/` — freezer, alacena, meal prep y técnicas transversales.
- `fuentes/auditorias/` — revisión interna de las fuentes; no reemplaza las fichas individuales.
- `vision/` — propósito y evolución del producto.

## Estados

- 🧪 `por-probar`
- ✅ `probada`
- 🔧 `necesita-ajustes`
- ⭐ `favorita`

## Formato de cada receta

Cada receta vive en su propio archivo Markdown. La ficha debería incluir, cuando tengamos datos suficientes:

- descripción breve;
- estado y tipo;
- rendimiento o porciones;
- ingredientes y cantidades;
- preparación;
- kcal y macros aproximados;
- momento ideal;
- versión MatiOS y variantes;
- notas después de probarla;
- conservación y freezer;
- si conviene hacer cantidad doble y cómo reutilizar el excedente.

El bloque de conservación debe responder explícitamente:

- cuánto dura en heladera;
- si se puede congelar;
- en qué momento conviene congelarla;
- cómo porcionarla y envasarla;
- duración orientativa de mejor calidad;
- cómo descongelarla;
- cómo recalentarla;
- qué cambios de textura pueden ocurrir.

> Principio: primero guardar una receta útil. Después la refinamos con cantidades, macros y experiencia real. Las guías y auditorías acompañan al recetario, pero nunca reemplazan las fichas individuales.
