---
title: Auditoría de 100 recetas para congelar
slug: auditoria-100-recetas-congelar
domain: alimentacion
module: recetario
type: source-audit
status: reviewed
locale: es-AR
reviewed_at: 2026-08-17
source:
  title: Recetas para congelar - La Biblia de la Organización Saludable
  author: Vanesa Bella
  pages: 89
  treatment: inventario y curación; no transcripción literal
tags:
  - freezer
  - recetas
  - meal-prep
  - auditoria
  - seguridad-alimentaria
---

# Auditoría: 100 recetas para congelar

## Veredicto

Es una **muy buena fuente de ideas y probablemente el documento central** para construir el módulo freezer de MatiOS. Tiene preparaciones cotidianas, ingredientes accesibles en Argentina y un enfoque compatible con meal prep.

No debe importarse de forma automática. El documento no contiene 100 recetas únicas y terminadas: llega a esa cifra contando variantes, subrecetas, rellenos, salsas y varias repeticiones casi textuales. Además, algunos tiempos de freezer son excesivos y varias fórmulas tienen cantidades omitidas o contradictorias.

Decisión de curación: **usar como banco de ideas; reescribir, probar y normalizar cada receta antes de publicarla**.

## Fortalezas

- Ingredientes económicos y fáciles de conseguir.
- Muchas bases reutilizables: rellenos, masas, pollo desmenuzado, carne desmechada, salsas y legumbres.
- Buen equilibrio entre platos completos, proteínas, acompañamientos, desayunos y dulces.
- Incluye método de conservación en casi todas las preparaciones.
- Encaja especialmente bien con una estrategia de cocinar por tandas y porcionar.
- Varias recetas pueden adaptarse a objetivos de subir o bajar calorías sin rehacer el plato completo.

## Problemas encontrados

### Repeticiones

Entre otras, aparecen repetidas o casi repetidas:

- albóndigas de pollo;
- hamburguesas de pollo en páginas consecutivas;
- albóndigas de carne;
- hamburguesas de carne;
- guiso de lentejas con carne;
- pastel de carne;
- relleno de empanadas de carne;
- rollitos de carne tipo niño envuelto;
- ensalada de legumbres.

En MatiOS se conservará una sola versión canónica y las diferencias útiles pasarán a `variantes`.

### Duraciones que no heredaremos

El PDF asigna frecuentemente 6 a 12 meses a hamburguesas, albóndigas, milanesas, pollo cocido, carne cocida, guisos y purés. Para uso doméstico y calidad real, MatiOS empleará rangos más conservadores definidos en la guía general de freezer.

Ejemplos:

- platos cocidos, guisos y salsas: normalmente 2-3 meses de mejor calidad;
- hamburguesas y albóndigas caseras: 2-3 meses;
- pollo y carne cocidos: aproximadamente 2-6 meses según preparación, priorizando los rangos cortos;
- panes y productos horneados: generalmente 1-3 meses;
- purés: aproximadamente 2-3 meses para conservar buena textura;
- helados caseros de banana y yogur: pensados para consumo corto, no 3-4 meses como experiencia óptima.

### Fórmulas incompletas o contradictorias

- El pan integral indica 700 ml de agua en ingredientes y luego 600 ml en el procedimiento.
- La masa de tarta menciona leche en polvo en el procedimiento, pero no figura en ingredientes.
- El pan sin gluten contiene una línea de “20 g” sin indicar el ingrediente.
- El pan de lentejas indica 1.400 g de lentejas; requiere validación porque parece una escala o un error.
- Hay unidades omitidas: por ejemplo “100 soja texturizada” y “200 caldo caliente”.
- Algunas recetas usan expresiones ambiguas como “una pelota de tenis” para porcionar hamburguesas.
- En distintas páginas, la misma receta recibe tiempos de conservación diferentes.

Estas recetas quedan en estado `requiere_prueba`, no listas para publicar.

### Técnica y textura

- Brotes de soja, zapallito, zucchini y algunas verduras acuosas pierden mucha textura al congelarse.
- Las salsas con queso crema pueden separarse; conviene congelar la base y terminar la salsa al servir.
- Las preparaciones con papa necesitan método de recalentado específico para evitar textura harinosa o acuosa.
- Los helados basados en banana se endurecen y forman cristales en almacenamiento prolongado.
- El hummus congelado puede cambiar de textura; se recupera mezclando y agregando un poco de agua o aceite.
- Las ensaladas armadas con verduras frescas no son buenas candidatas: conviene congelar solo las legumbres cocidas.

## Inventario curado por familias

### Masas, panes y alternativas

| Preparación base | Decisión | Ajuste principal |
| --- | --- | --- |
| Pan integral | Incluir corregida | Resolver hidratación, mejorar levado y acortar conservación |
| Pan rápido de sartén | Incluir | Definir gramos y cantidad de agua |
| Masa integral de tarta | Incluir corregida | Resolver ingrediente fantasma y rendimiento |
| Masa integral de empanadas | Incluir | Definir número y diámetro de tapas |
| Prepizzas integrales | Incluir | Separar congelado precocido y crudo |
| Grisines integrales | Incluir | Aclarar conservación crudos/cocidos |
| Rapiditas o tortillas integrales | Incluir | Crear receta canónica independiente |
| Pasta integral rellena | Incluir con prueba | Definir harina faltante y rellenos compatibles |
| Pan de lentejas | Probar antes | Revisar cantidad de lentejas y estructura |
| Pan sin gluten con semillas | Bloqueada | Falta identificar un ingrediente de 20 g |

### Pollo

| Preparación base | Decisión | Uso en MatiOS |
| --- | --- | --- |
| Milanesas de pollo con avena | Prioridad alta | Cena rápida; congelar crudas y separadas |
| Pollo al horno con verduras | Incluir corregida | Separar verduras que regeneran mal |
| Albóndigas de pollo | Prioridad alta | Unificar versiones y definir peso por unidad |
| Pollo macerado | Prioridad alta | Base para wok, arroz, fajitas y horno |
| Pollo a la cacerola | Incluir | Plato completo ajustable en carbohidratos |
| Pollo desmenuzado | Prioridad alta | Base para wraps, tacos, pastas y ensaladas |
| Relleno de pollo | Prioridad alta | Empanadas, tartas y canelones |
| Arroz con pollo | Incluir corregida | Evitar sobrecocción al recalentar |
| Pechuga rellena | Incluir | Congelar cocida y porcionada |
| Arrollado de pollo | Incluir con prueba | Seguridad y método de recalentado |
| Wok de pollo | Incluir corregida | Agregar vegetales delicados al final |
| Salsas con pollo | Dividir | Congelar base; terminar cremosas al servir |
| Hamburguesa de pollo | Prioridad alta | Eliminar duplicado y fijar peso de 120-150 g |
| Boloñesa de pollo | Prioridad alta | Excelente salsa proteica |
| Cazuela de pollo | Incluir | Ajustar verduras según textura |
| Nuggets de pollo | Prioridad alta | Buena opción para horno o air fryer |

### Carne vacuna y carne picada

| Preparación base | Decisión | Uso en MatiOS |
| --- | --- | --- |
| Albóndigas de carne | Prioridad alta | Una versión canónica, cruda y cocida en salsa |
| Hamburguesas de carne | Prioridad alta | Ajustar avena y peso por unidad |
| Boloñesa de carne | Prioridad alta | Salsa base multiuso |
| Guiso de lentejas con carne | Prioridad alta | Fusionar tres apariciones |
| Pastel de papa y zapallitos | Incluir corregida | Controlar agua del zapallito |
| Pastel de carne | Incluir | Eliminar versión duplicada |
| Relleno de empanadas | Prioridad alta | Congelar relleno sin huevo duro o empanadas armadas |
| Canelones de carne | Incluir | Definir si se congelan con salsa |
| Milanesas de carne | Prioridad alta | Corregir duración exagerada |
| Niño envuelto | Incluir | Unificar repetición y congelar con salsa |
| Bife a la criolla | Incluir corregida | Congelar preferentemente sin papa |
| Carne macerada | Prioridad alta | Base flexible para salteados y horno |
| Carne desmechada | Prioridad alta | Excelente para tacos, sándwiches y platos completos |
| Estofado de carne | Incluir | Separar de la boloñesa y del guiso |

### Pescado y mariscos

| Preparación base | Decisión | Ajuste principal |
| --- | --- | --- |
| Filetes de pescado arrollados | Incluir con prueba | Verificar que el pescado no haya sido descongelado previamente |
| Milanesas de merluza | Prioridad alta | Congelar crudas solo con pescado apto |
| Pescado al wok | Reformular | Las verduras y el pescado pueden sobrecocinarse al regenerar |
| Wok de langostinos | Reformular | Congelar componentes por separado o cocinar en el momento |
| Brochettes de langostinos | Incluir con criterio | Congelar langostinos; armar y cocinar después |

### Soja, ricota y legumbres

| Preparación base | Decisión | Uso en MatiOS |
| --- | --- | --- |
| Pastel de papa con soja texturizada | Incluir | Alternativa económica y proteica |
| Relleno de soja multiuso | Prioridad alta | Tacos, empanadas, tartas y canelones |
| Albóndigas de soja | Incluir | Definir hidratación y ligante |
| Hamburguesas de soja | Incluir | Controlar humedad |
| Boloñesa de soja | Prioridad alta | Salsa económica, rica en proteína vegetal |
| Guiso de soja y lentejas | Incluir | Corregir unidades y líquido |
| Ricota y espinaca | Prioridad alta | Relleno para varias preparaciones |
| Hummus clásico y variantes | Incluir | Porciones pequeñas; recuperar textura al servir |
| Hamburguesas de legumbres | Prioridad alta | Versiones lenteja, garbanzo y poroto como variantes |
| Falafel | Prioridad alta | Congelar formado, preferentemente crudo |
| Sopa y guiso de legumbres | Incluir | Buenos para porcionado individual |
| Ensalada de legumbres | Reformular | Congelar legumbres solas, no la ensalada armada |

### Acompañamientos

| Preparación base | Decisión | Ajuste principal |
| --- | --- | --- |
| Arroz integral con verduras | Incluir | Cocinar al dente y recalentar con humedad |
| Arroz de coliflor | Incluir | Porciones pequeñas, cocción directa |
| Verduras al horno | Incluir corregida | Separar por familias y tiempos de cocción |
| Fideos integrales con verduras | Incluir con prueba | Dejar la pasta al dente |
| Puré de calabaza | Prioridad alta | Corregir duración de 12 meses |
| Puré de batata | Prioridad alta | Corregir duración y textura |
| Puré de papa | Incluir con técnica | Añadir materia grasa y recalentar correctamente |
| Quinoa cocida | Prioridad alta | Congelar plana en porciones |

### Desayunos, meriendas y dulces

| Preparación base | Decisión | Ajuste principal |
| --- | --- | --- |
| Panqueques integrales | Prioridad alta | Congelar separados |
| Muffins | Incluir | Crear variantes proteicas y frutales |
| Barritas energéticas | Incluir con cálculo | Son densas en calorías; etiquetar objetivo |
| Barras de cereal y chocolate | Incluir con cálculo | No vender como bajas en calorías |
| Hotcakes o waffles de banana | Prioridad alta | Buena base pre/post entrenamiento |
| Budín de frutas | Prioridad alta | Adaptable con leche y whey proteicas |
| Galletas de avena y frutos secos | Incluir | Definir rendimiento y macros |
| Scones integrales | Incluir | Ajustar grasa y porción |
| Pan de avena | Incluir | Revisar estructura y cantidad de líquido |
| Trufas y bocados | Incluir con cálculo | Etiqueta alta densidad calórica |
| Chipa o pan de queso | Incluir | Congelar crudo formado o cocido |
| Frutas preparadas | Prioridad alta | Bolsas para batidos y toppings |
| Helado proteico de banana | Prioridad alta para Matías | Crear versión con whey y leche proteica |
| Helados de frutos rojos y café | Incluir | Consumo corto para buena textura |
| Mermeladas con chía | Incluir | Separar conservación en heladera y freezer |

## Primera selección para probar en la cocina de MatiOS

Estas preparaciones tienen la mejor relación entre utilidad, proteína, facilidad y comportamiento en freezer:

1. Pollo macerado en tres sabores.
2. Pollo desmenuzado en porciones de 200-250 g.
3. Milanesas de pollo con avena.
4. Nuggets caseros de pollo.
5. Boloñesa de pollo.
6. Hamburguesas de carne de 130-150 g.
7. Albóndigas de carne en salsa.
8. Carne desmechada.
9. Relleno de empanadas de carne.
10. Guiso de lentejas con carne.
11. Boloñesa de soja texturizada.
12. Falafel.
13. Hamburguesas de lentejas.
14. Relleno de ricota y espinaca.
15. Quinoa cocida porcionada.
16. Puré de calabaza.
17. Rapiditas integrales.
18. Prepizzas integrales individuales.
19. Hotcakes de banana y avena.
20. Budín proteico de frutas.
21. Helado proteico de banana y cacao.
22. Packs de fruta para batidos.

## Cómo se incorporará al modelo de recetas

Cada receta derivada deberá usar una estructura consistente:

```yaml
title: Nombre de la receta
status: draft | tested | approved
source_inspiration: 100-recetas-para-congelar
category: plato-principal
objectives:
  - ganar-masa
  - meal-prep
servings: 4
nutrition_estimated:
  calories: null
  protein_g: null
  carbs_g: null
  fat_g: null
freezer:
  suitable: true
  freeze_stage: cooked
  best_quality_months: 2-3
  portion: 1 comida
  packaging: recipiente hermetico
  thawing: heladera durante la noche
  reheating: olla o microondas
  texture_notes: null
variants:
  lower_calorie: null
  higher_calorie: null
  higher_protein: null
```

## Regla editorial

El PDF se conserva como fuente. MatiOS no publicará copias literales: generará versiones propias, corregidas, probadas, con cantidades en gramos, rendimiento, conservación segura, instrucciones claras y estimación nutricional.

