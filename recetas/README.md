# 🍳 Recetario MatiOS

Fuente de verdad de las recetas que Mati usa, quiere probar o quiere adaptar a sus objetivos.

## Objetivo

Guardar recetas en un formato simple y reutilizable para que MatiOS pueda:

- recomendar comidas según momento del día y entrenamiento;
- estimar macros y calorías;
- priorizar recetas ricas en proteína y nutrientes;
- reutilizar ingredientes que Mati suele tener en casa;
- distinguir recetas probadas de recetas pendientes;
- registrar variantes y mejoras después de probarlas.

## Estructura

- `desayunos-meriendas/` — pancakes, bowls y opciones rápidas.
- `batidos/` — pre/post entreno y batidos proteicos.
- `postres-snacks/` — alternativas dulces, alfajores, cookies y puddings.
- `almuerzos-cenas/` — platos principales.
- `bases-toppings/` — preparaciones reutilizables: proteína casera, salsas, mermeladas, semillas, etc.

## Estados

- 🧪 `por-probar`
- ✅ `probada`
- ⭐ `favorita`

## Formato de cada receta

Cada archivo debería incluir, cuando tengamos datos suficientes:

- ingredientes y cantidades;
- preparación;
- porciones;
- kcal y macros aproximados;
- momento ideal (desayuno, snack, pre/post entreno, etc.);
- estado;
- notas de Mati;
- variantes posibles.

> Principio: primero guardar una receta útil. Después la vamos refinando con cantidades, macros y experiencia real.
