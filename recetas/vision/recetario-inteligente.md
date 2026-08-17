---
title: Visión del recetario inteligente de MatiOS
slug: vision-recetario-inteligente
domain: alimentacion
module: recetario
type: product-vision
status: approved
locale: es-AR
updated_at: 2026-08-17
tags:
  - recetas
  - freezer
  - meal-prep
  - inteligencia-artificial
  - planificacion-semanal
---

# Visión del recetario inteligente de MatiOS

## Propósito

MatiOS no será una colección de PDFs ni una lista estática de recetas. Será un sistema práctico para **comer bien, sostener buenos hábitos y hacer más simple la semana**.

La web debe combinar tres capas:

1. Un recetario visual, lindo, rápido e intuitivo.
2. Una base de conocimiento estructurada sobre conservación, freezer, porciones, meal prep y nutrición.
3. Una IA que use esa información para responder preguntas y ayudar a planificar y cocinar.

## Experiencia deseada

Una persona debería poder:

- buscar por cualquier palabra o ingrediente;
- filtrar por objetivo, tiempo, comida, proteína, calorías y aptitud para freezer;
- saber si una receta se puede congelar y en qué momento;
- saber cuánto conviene preparar de más;
- conocer el tamaño de porción y el envase adecuado;
- recibir instrucciones de congelado, descongelado y recalentado;
- reutilizar una preparación base en varias comidas;
- organizar la semana aprovechando lo que ya tiene;
- pedirle a la IA un menú y una sesión de meal prep realista;
- reducir decisiones, desperdicio y pedidos impulsivos de comida.

## Búsqueda y navegación

La búsqueda debe funcionar por:

- nombre de receta;
- ingrediente: pollo, banana, lentejas;
- tipo de comida: desayuno, merienda, almuerzo, cena;
- objetivo: subir calorías, bajar calorías, alta proteína, comida equilibrada;
- tiempo disponible;
- método: horno, sartén, air fryer, sin cocción;
- situación: post gimnasio, comida para llevar, cocinar el domingo;
- conservación: freezer, heladera, preparación anticipada;
- restricción o preferencia alimentaria;
- ingrediente disponible o próximo a vencer.

La búsqueda debe tolerar lenguaje cotidiano y errores de escritura. Ejemplos:

- “qué hago con pollo y arroz”;
- “algo dulce con mucha proteína”;
- “comida para freezar y llevar al trabajo”;
- “tengo bananas maduras”;
- “quiero cocinar una vez y comer tres días”.

## Ficha de receta

Cada receta debe mostrar primero lo importante:

- foto;
- nombre y descripción corta;
- tiempo total y dificultad;
- porciones;
- calorías y macros estimados;
- etiquetas de objetivo;
- ingredientes en gramos y medidas domésticas;
- pasos claros;
- variantes para subir calorías, reducirlas o aumentar proteína;
- sustituciones posibles;
- conservación en heladera;
- aptitud y duración orientativa en freezer;
- momento correcto para congelar: cruda, formada, precocida o cocida;
- porción recomendada para guardar;
- envase sugerido;
- descongelación y recalentado;
- cambios de textura esperables;
- preparaciones relacionadas y formas de reutilizar sobras.

## El concepto “hacer de más”

La web debe indicar cuándo una receta conviene duplicarla y qué hacer con el excedente.

Ejemplo:

> Cociná 1 kg de pollo en lugar de 500 g. Usá una parte hoy, guardá una porción en heladera y congelá dos paquetes de 220 g. Después podés convertirlos en fajitas, arroz con pollo o pasta con salsa.

No alcanza con indicar “se puede congelar”. El sistema debe enseñar:

- cuánto extra preparar;
- cómo dividirlo;
- qué porciones sirven para una comida;
- cómo rotularlas;
- en qué recetas futuras se pueden reutilizar.

## Planificador semanal con IA

La IA debería poder combinar:

- objetivo nutricional;
- cantidad de personas;
- días y comidas a planificar;
- entrenamientos y actividades;
- tiempo disponible para cocinar;
- alimentos que ya existen en heladera o freezer;
- preferencias y restricciones;
- presupuesto aproximado;
- recetas favoritas y preparaciones pendientes.

### Salida esperada

La IA no debe limitarse a devolver siete recetas. Debe generar:

1. Menú semanal.
2. Lista de compras consolidada.
3. Sesión de preparación agrupada por tareas.
4. Qué comer fresco primero.
5. Qué congelar y en qué porciones.
6. Qué pasar del freezer a la heladera cada noche.
7. Cómo reutilizar una misma base sin sentir que se repite la comida.

Ejemplo de secuencia:

- Hornear pollo y verduras mientras se cocina arroz.
- Separar dos porciones para lunes y martes.
- Congelar dos porciones de pollo desmenuzado.
- Usar una para fajitas la semana siguiente y otra para una salsa.

## Tipos de contenido

El recetario contendrá más que recetas:

- guías de freezer y conservación;
- técnicas de cocina;
- preparación de ingredientes base;
- sesiones de meal prep;
- menús semanales;
- listas de compras;
- equivalencias y sustituciones;
- seguridad alimentaria;
- hábitos y organización;
- artículos breves que respondan dudas frecuentes.

## Modelo mínimo de datos

```yaml
recipe:
  title: string
  aliases: []
  status: draft | tested | approved
  description: string
  categories: []
  objectives: []
  meal_types: []
  equipment: []
  difficulty: easy | medium | advanced
  prep_minutes: 0
  cook_minutes: 0
  servings: 0
  ingredients: []
  steps: []
  nutrition_per_serving:
    calories: null
    protein_g: null
    carbs_g: null
    fat_g: null
  variations:
    higher_calorie: null
    lower_calorie: null
    higher_protein: null
  storage:
    fridge_days: null
    freezer:
      suitable: true
      freeze_stage: cooked
      best_quality_months: null
      portion: null
      packaging: null
      instructions: null
    thawing: null
    reheating: null
    texture_notes: null
  batch_cooking:
    worth_doubling: true
    suggested_multiplier: 2
    reuse_ideas: []
  source_provenance: []
```

## Flujo de curación de los PDFs

Cada fuente recibida debe pasar por este proceso:

1. Leer el documento completo, incluyendo tablas e imágenes relevantes.
2. Inventariar recetas, técnicas y consejos.
3. Detectar duplicados y contradicciones.
4. Verificar seguridad alimentaria y conservación.
5. Separar ideas útiles de contenido publicable.
6. Reescribir las recetas con voz y estructura propias de MatiOS.
7. Estandarizar cantidades, rendimiento, porciones y tiempos.
8. Agregar variantes nutricionales y de ingredientes.
9. Completar campos de heladera, freezer y reutilización.
10. Marcar cada elemento como borrador, probado o aprobado.

Los PDFs son fuentes; nunca serán la interfaz ni la fuente de verdad final.

## Organización propuesta

```text
alimentacion/recetario/
  README.md
  vision/
    recetario-inteligente.md
  recetas/
    desayunos/
    meriendas/
    platos-principales/
    acompanamientos/
    postres/
    bases-y-preparaciones/
  guias/
    freezer-y-conservacion.md
    meal-prep.md
    descongelado-y-recalentado.md
  planes/
    menus-semanales/
    sesiones-meal-prep/
  fuentes/
    auditorias/
  schemas/
    recipe.schema.yaml
```

## Principios no negociables

- La información debe resolver una acción concreta.
- La navegación debe ser más simple que abrir y recorrer un PDF.
- Una receta no se publica sin cantidades claras y método entendible.
- “Saludable” no reemplaza el cálculo nutricional ni el contexto del objetivo.
- Los tiempos de conservación se presentan como orientación de seguridad y calidad, no como promesas absolutas.
- La IA debe apoyarse en contenido curado y estructurado, no improvisar instrucciones de freezer.
- La persona siempre debe saber qué cocinar, qué guardar y cuál es el siguiente paso.
- El éxito se mide por semanas más simples y hábitos sostenibles, no por la cantidad de recetas acumuladas.

