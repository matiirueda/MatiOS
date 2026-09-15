# Agentis — Customer Preference Graph + Re-campaigning Contextual

> Fecha: 2026-09-15  
> Estado: idea de producto / arquitectura a validar

## Idea central

Cuando una persona interactúa con nuestros negocios personalizados —por ejemplo enviando fotos de su casa, diciendo qué estilo le gusta, qué música escucha, qué arte consume, colores preferidos, equipo de fútbol, bandas, películas, hobbies, mascotas, viajes o estética— esa conversación no debe servir únicamente para resolver el pedido actual.

Debe convertirse, con consentimiento y de forma transparente, en un **perfil de preferencias reutilizable** que nos permita:

1. dar recomendaciones mucho más cercanas y relevantes;
2. diseñar productos que realmente encajen con la demanda observada;
3. detectar patrones entre clientes;
4. lanzar nuevas cápsulas basadas en intereses reales;
5. reactivar clientes cuando aparece algo genuinamente afín a lo que ya dijeron que les gusta.

La ventaja no es solo “tener datos”: es construir una relación donde el sistema recuerda gustos útiles y evita mandar campañas genéricas.

## Ejemplo

Una persona manda fotos de su living y durante la conversación dice:

- le gusta River;
- escucha Soda Stereo;
- prefiere madera clara + negro;
- le gustan ilustraciones minimalistas;
- tiene un perro;
- quiere que el departamento se vea más amplio;
- no le gustan diseños demasiado cargados.

Hoy esa información ayuda a recomendarle un cuadro o una alfombra.

Meses después lanzamos:

- una cápsula de fútbol personalizada;
- una colección inspirada en rock argentino;
- rugs negro/madera/minimalistas;
- retratos de mascotas;
- decoración para espacios chicos.

El CRM puede detectar automáticamente la afinidad y generar una campaña específica, por ejemplo:

> “Hace un tiempo nos contaste que te gustaban los diseños minimalistas y River. Lanzamos una pieza nueva que creemos que te puede encajar. Como ya trabajaste con nosotros, tenés X% de descuento esta semana.”

No mandar “promo general”; mandar **motivo de relevancia + producto + beneficio**.

## Customer Preference Graph

No conviene guardar todo como texto libre únicamente. Crear una capa estructurada que pueda coexistir con notas/conversaciones.

Ejemplo conceptual:

```text
Customer
├── explicit_preferences
│   ├── colors: [black, light_oak]
│   ├── styles: [minimalist, industrial]
│   ├── sports_teams: [River Plate]
│   ├── music: [Soda Stereo]
│   ├── art_styles: [illustration]
│   ├── hobbies: [...]
│   ├── pets: [dog]
│   └── disliked_styles: [maximalist]
├── home_context
│   ├── rooms
│   ├── approximate_dimensions
│   ├── existing_palette
│   └── photos/assets
├── product_interests
│   ├── rugs
│   ├── prints
│   └── mugs
├── observed_behavior
│   ├── viewed
│   ├── clicked
│   ├── quoted
│   └── purchased
├── source/provenance
│   └── conversation / form / purchase / explicit survey
└── consent / communication preferences
```

### Muy importante: distinguir tipos de dato

**Explícito**: el cliente dijo “me gusta River”.  
**Inferido**: el sistema cree que le puede gustar fútbol por sus interacciones.  
**Conductual**: hizo clic/compró/vio una pieza.  

No tratarlos como equivalentes. Cada atributo debe tener `source`, `confidence`, `first_seen`, `last_seen` y, cuando corresponda, `explicit=true/false`.

## Arquitectura propuesta

```text
WhatsApp / Web / Instagram / tienda
            ↓
Conversation / interaction layer
            ↓
Preference extraction agent
            ↓
Validation + normalization
            ↓
Customer Preference Store
            ↓
CRM / Product Analytics / Recommendation Engine
            ↓
Campaign matching
            ↓
Human approval / business rules
            ↓
WhatsApp / email / ads / offers
```

### El LLM no debe ser la base de datos

El agente puede extraer de lenguaje natural:

> “Me gusta algo oscuro pero no todo negro; soy de River y escucho bastante rock nacional.”

Y convertirlo en estructura:

```json
{
  "colors": [{"value":"dark_neutral","confidence":0.9}],
  "sports_teams": [{"value":"River Plate","confidence":1.0,"explicit":true}],
  "music_genres": [{"value":"rock argentino","confidence":1.0,"explicit":true}]
}
```

Pero el dato persistente vive en una base estructurada y auditable.

## Campaign Matching Engine

Cada producto/cápsula también debería tener atributos.

Ejemplo:

```text
Product: Rug River Minimal
attributes:
- category: rug
- themes: [football, River Plate]
- colors: [black, white, red]
- style: minimalist
- giftable: true
```

Después se calcula afinidad:

```text
customer preferences × product attributes × purchase history × recency
→ affinity_score
```

Solo por encima de cierto score entra a una campaña.

Esto nos permite campañas del tipo:

- “clientes que dijeron ser de River y compraron decoración”;
- “clientes con mascotas que pidieron ilustraciones”;
- “clientes que prefieren madera clara + negro”;
- “clientes interesados en regalos familiares”;
- “clientes que mencionaron una banda y ahora existe una cápsula relacionada”.

## Uso para construir productos

El valor más grande puede estar antes de vender.

Dashboard agregado, nunca mirando personas una por una:

```text
Preferencias más frecuentes
Temas con demanda pero sin producto
Cruces emergentes
Ej:
- 18% mascotas
- 14% River
- 12% rock argentino
- 31% minimalista
- combinación River + minimalista = N clientes
```

Eso alimenta el proceso MatiOS:

```text
señal de cliente
→ demanda agregada
→ idea de cápsula
→ mockups IA
→ test/preventa
→ producir bajo demanda
→ medir
→ escalar solo si vende
```

Encaja directamente con la regla: **validar barato, producir bajo demanda, medir y comprar activos después**.

## Re-campaigning inteligente

Trigger conceptual:

```text
Nuevo producto/cápsula
→ etiquetar atributos
→ buscar clientes afines
→ excluir saturados / opt-out / compras incompatibles
→ generar mensaje explicando relevancia
→ aplicar oferta si corresponde
→ human/business-rule approval
→ enviar
→ medir conversión
→ aprender
```

La explicación de relevancia es clave para que se sienta cercano y no invasivo.

Malo:
> “Nueva colección. 15% OFF.”

Mejor:
> “Cuando armamos tu pedido nos habías contado que te gustaba X. Acabamos de lanzar Y y pensé que te podía interesar.”

## Cercanía sin volverse inquietante

Reglas de producto:

- usar principalmente preferencias que el propio cliente dio en contexto comercial;
- no inferir atributos sensibles innecesarios;
- no mencionar en campañas detalles íntimos o inesperados;
- permitir ver/corregir preferencias cuando tenga sentido;
- permitir opt-out claro;
- guardar procedencia del dato;
- establecer caducidad/decay de preferencias cuando sean temporales;
- separar datos necesarios para operación de datos usados para marketing;
- no vender/ceder el perfil de preferencias a terceros.

El objetivo es que el cliente piense **“se acordaron de lo que me gusta”**, no “¿por qué saben esto?”.

## Relación con Agentis

Esto puede convertirse en una capacidad horizontal de Agentis y no solo en una feature de cuadros/rugs.

Ejemplos por vertical:

- decoración: estilos, colores, ambiente, equipos/bandas;
- indumentaria: talles, colores, equipos, cortes;
- gastronomía: preferencias, restricciones, platos favoritos;
- canchas: horarios, deporte, grupo habitual;
- peluquería/estética: servicios, estilo, frecuencia;
- retail: marcas, rango de precio, categorías;
- contenido: temas, formatos, creadores favoritos.

Podría existir un módulo reusable:

**Agentis Customer Intelligence Layer**

que provea:

- extracción de preferencias;
- normalización;
- provenance/confidence;
- segmentos dinámicos;
- matching producto-cliente;
- triggers de campaña;
- analítica agregada de demanda;
- feedback de conversión.

## Hipótesis comercial

Esto puede ser una diferenciación fuerte frente a CRMs tradicionales: no solo registrar nombre/email/estado del lead sino convertir conversaciones naturales en **memoria comercial estructurada y accionable**.

La promesa no sería “IA que recuerda todo”, sino:

> **Cada conversación deja conocimiento reutilizable para atender mejor, crear mejores productos y vender con más relevancia.**

## Próximos experimentos

1. Definir schema mínimo de preferencias.
2. Probar extracción desde 20 conversaciones ficticias/reales anonimizadas.
3. Medir precisión y falsos positivos.
4. Crear atributos de producto equivalentes.
5. Implementar un matcher simple basado en reglas antes de usar embeddings/ML.
6. Simular una campaña y revisar manualmente si cada match se siente relevante.
7. Recién después automatizar envíos.
