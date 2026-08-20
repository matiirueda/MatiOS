# Arquitectura de contenido

## Una ficha, cinco capas

### 1. En 30 segundos

- Una pregunta real: “¿Cómo armo el plato hoy?”
- Una frase central sin tecnicismos.
- Una visual principal.
- Una acción concreta.

### 2. Aplicalo

- Qué hacer.
- Dos o tres alternativas disponibles en Argentina.
- Un ejemplo económico y uno rápido.
- Enlaces a recetas MatiOS.

### 3. Entendé por qué

- Mecanismo explicado en lenguaje simple.
- Qué beneficio es razonable esperar.
- Qué no demuestra esa explicación.

### 4. Adaptalo a vos

Controles o ramas por:

- objetivo: ganar músculo, bajar grasa, mantener o rendir;
- comida y horario;
- entrenamiento del día;
- presupuesto y tiempo;
- preferencias y restricciones;
- hambre/tolerancia.

### 5. Profundizá

- Matices y excepciones.
- Nivel de evidencia.
- Fuentes primarias/oficiales.
- Cuándo consultar a un profesional.

## Bloques reutilizables

Cada tema puede combinar un subconjunto:

- `idea-clave`
- `visual-central`
- `paso-a-paso`
- `comparador`
- `mito-y-matiz`
- `error-frecuente`
- `probalo-esta-semana`
- `recetas-relacionadas`
- `adaptacion-por-objetivo`
- `fuentes-y-limites`

## Contrato propuesto

```yaml
id: plato-flexible
titulo: Un plato que se adapta a vos
estado: borrador
nivel: inicial
tiempo_lectura_min: 3
idea_clave: "Usá una estructura visual y ajustá cantidades al contexto."
acciones:
  - "Elegí una proteína, un vegetal y una fuente de energía."
objetivos: [ganar-musculo, perder-grasa, mantener, rendimiento]
componentes: [visual-central, adaptacion-por-objetivo, recetas-relacionadas]
recetas_relacionadas: []
evidencia:
  nivel: consenso
  revisado_por: []
  ultima_revision: null
advertencias: []
```

## Funcionamiento conversacional

La IA no recita toda la ficha. Selecciona la menor capa que resuelve el momento:

- “Estoy en el supermercado”: comparador de etiquetas.
- “¿Qué desayuno?”: estructura + tres recetas.
- “Me dio hambre a las dos horas”: revisar composición, porción, sueño y contexto sin diagnosticar.
- “Tengo partido”: adaptación de carbohidratos e hidratación.

Luego ofrece `Ver por qué`, `Adaptarlo a mi objetivo` o `Abrir recetas`.

## Aprendizaje y seguimiento

Registrar eventos separados:

- `topic_viewed`
- `topic_explained`
- `action_selected`
- `action_reported_done`
- `question_asked`
- `professional_review_requested`

No inferir aprendizaje solo porque se abrió una pantalla. Priorizar una pregunta de comprobación práctica: “¿Cuál de estas dos opciones elegirías para tu desayuno y por qué?”.
