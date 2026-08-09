# Investigación — fábrica de anuncios con Higgsfield, ComfyUI y n8n

> Estado: propuesta para experimentar, no decisión arquitectónica definitiva.  
> Fecha de revisión: 2026-08-09. Los precios y catálogos de modelos cambian con frecuencia; verificarlos antes de contratar.

## Resumen ejecutivo

Para Agentis no conviene elegir una sola plataforma. La mejor arquitectura inicial es híbrida:

- **Higgsfield Supercomputer** para explorar campañas y producir piezas audiovisuales rápidamente, sin construir primero toda la infraestructura.
- **ComfyUI** como motor visual reproducible: imágenes, video, edición, consistencia de personajes/productos, variantes y uso de modelos locales o pagos.
- **n8n** como orquestador de negocio: recibe el brief, busca memoria de marca, dispara investigación, llama modelos y ComfyUI, controla aprobaciones, registra costos y distribuye resultados.
- **Git/MatiOS** como memoria durable: briefs, hipótesis, prompts, workflows JSON, criterios, resultados de pruebas y aprendizajes.
- **PostgreSQL** posteriormente para campañas, ejecuciones, métricas, costos y estados; **pgvector** como índice derivado.

La recomendación es **probar antes de construir**: usar Higgsfield durante una campaña piloto para descubrir qué piezas y pasos generan valor; después convertir solamente los flujos repetidos y caros en skills y workflows propios con n8n + ComfyUI.

## Qué aporta cada plataforma

| Capa | Rol | Ventaja principal | Riesgo o límite |
| --- | --- | --- | --- |
| Higgsfield Supercomputer | Estudio creativo agentic SaaS | De un pedido en lenguaje natural pasa a plan, modelos, skills y assets | Créditos, menor control fino, dependencia del proveedor |
| ComfyUI | Motor generativo visual | Workflows versionables y repetibles; modelos locales y APIs pagas en un mismo grafo | Curva de aprendizaje, mantenimiento de nodos/modelos/GPU |
| n8n | Orquestación general | Triggers, integraciones, reglas, aprobaciones, logs y distribución | No sustituye un motor visual; hay que diseñar bien idempotencia y errores |
| MatiOS/Git | Conocimiento y procedimientos | Portabilidad, historial, decisiones y reutilización | No sirve como base transaccional para ejecuciones masivas |
| PostgreSQL | Estado vivo y métricas | Costos, campañas, piezas, tests, estados y resultados | Se agrega cuando exista un flujo real que medir |

## 1. Higgsfield Supercomputer

No es una supercomputadora alquilable sino una interfaz agentic para producción creativa. Recibe un objetivo (por ejemplo, investigar competidores y crear tres anuncios), arma un plan, elige modelos/presets, pide aprobación del gasto y entrega assets dentro de proyectos.

### Funciones relevantes para Agentis

- Orchestrator que selecciona el modelo más adecuado por etapa.
- Skills instalables y personalizables para convertir procesos en recetas reutilizables.
- Memoria, archivos y proyectos con revisiones.
- Tareas programadas para variantes de anuncios, scans competitivos y calendarios.
- Conectores a Drive, Notion, Gmail, Figma, Slack y otros servicios.
- Investigación web/social que puede terminar en documento o sitio.
- Producción de UGC, product shots, reels, motion graphics y campañas con muchas variantes.
- Uso comercial declarado para las generaciones.

### Costos

La página pública de precios es dinámica y no expone de forma estable toda la tabla al crawler. Material oficial de junio de 2026 sitúa el rango entre **USD 9/mes (Basic)** y **USD 129/mes (Ultra)**; planes, promociones, generaciones “unlimited” y créditos cambian seguido. La propia plataforma muestra el costo en créditos del plan antes de renderizar y requiere aprobación.

Esto lo vuelve accesible para **experimentación y pocas campañas**, pero no permite asumir todavía un costo unitario estable para producción de agencia. El costo real debe medirse con una campaña piloto: brief → cantidad de intentos → piezas aprobadas → costo total → costo por asset usable.

### Veredicto

Sí conviene probarlo. No conviene convertirlo de entrada en el núcleo de Agentis. Su mejor uso inicial es ser nuestro **laboratorio y acelerador creativo**: aprender qué tipos de anuncios, skills y secuencias queremos luego reproducir o abaratar.

## 2. ComfyUI

ComfyUI es una aplicación open source basada en nodos para diseñar pipelines generativos. Un workflow es un grafo JSON que define modelos, entradas, transformaciones y salidas. Puede ejecutarse localmente o por API en infraestructura cloud.

### Por qué encaja

- Reproducibilidad: guardamos el JSON del workflow y sus parámetros.
- Variantes controladas: cambiar semilla, copy, imagen, producto, formato o modelo sin rediseñar el proceso.
- Consistencia: ControlNet, referencias, LoRAs, inpainting y otros mecanismos permiten sostener identidad visual, personaje o producto.
- Portabilidad: la API cloud mantiene compatibilidad con el formato de la API local.
- Mezcla de costos: modelos open source en GPU propia/alquilada y Partner Nodes pagos para modelos cerrados.
- Automatización: servidor HTTP/REST + WebSocket para enviar jobs, monitorear y descargar outputs.
- Integración agentic: ComfyUI ya ofrece MCP/CLI para que un agente pueda descubrir y ejecutar herramientas de imagen, video, audio y 3D.

### Costos y operación

- **Self-hosted:** el software es gratuito; se paga hardware, electricidad o GPU cloud. Da máximo control, pero exige instalación, modelos, almacenamiento, seguridad y mantenimiento de custom nodes.
- **Comfy Cloud:** suscripción y créditos compartidos entre GPU y Partner Nodes. La API requiere plan pago; admite trabajos asíncronos y concurrencia según el tier. Es útil para empezar sin comprar GPU.
- **Proveedores de GPU/Comfy administrado:** pago por segundo/hora. Pueden ser más económicos al producir por lotes, pero hay que controlar tiempos ociosos, almacenamiento y cold starts.

No se debe comprar una GPU al comienzo. Primero hay que conocer el volumen, los modelos y la memoria VRAM necesarios. Para el MVP conviene Comfy Cloud o GPU bajo demanda; luego comparar costo mensual observado contra alquiler dedicado o hardware propio.

### Riesgos

- Workflows comunitarios pueden depender de nodos frágiles o inseguros.
- Actualizaciones de modelos/nodos pueden romper reproducibilidad.
- Licencias de modelos y datasets no son uniformes; “open weights” no siempre implica uso comercial irrestricto.
- Generar barato no garantiza un anuncio efectivo: la métrica es performance comercial, no cantidad de imágenes.

Mitigación: fijar versiones, registrar hashes/modelos, aislar custom nodes, documentar licencias y crear una batería de outputs de referencia por workflow.

## 3. n8n

n8n debe ser el **sistema nervioso**, no el creador visual. Coordina eventos y servicios; ComfyUI genera; MatiOS conserva el aprendizaje.

### Por qué sirve

- Triggers por webhook, formulario, calendario o evento.
- Conectores a herramientas comerciales y almacenamiento.
- Nodos HTTP para APIs no nativas.
- Código personalizado cuando el low-code no alcanza.
- Flujos de aprobación y rutas condicionales.
- Ejecuciones observables, reintentos y manejo de errores.
- Community Edition self-hosted disponible gratuitamente de forma indefinida.

La licencia de n8n es **fair-code/Sustainable Use**, no una licencia open source OSI tradicional. Permite usarlo internamente para operar servicios de la agencia; hay restricciones si el producto que se vende es esencialmente “n8n hospedado” o se cobra por dar acceso directo a sus funcionalidades. Para Agentis, la intención debe ser vender el resultado/servicio automatizado, no revender n8n como plataforma.

### Costos

- **Community self-hosted:** licencia base sin costo; se paga VPS, base de datos, backups y operación.
- **n8n Cloud:** actualmente el plan Pro publicado cuesta **EUR 50/mes anual por 10.000 ejecuciones**, con pasos ilimitados; existen tiers inferiores y Enterprise. El precio es por ejecución, no por nodo.

Para un MVP de Agentis, un VPS pequeño con n8n Community puede ser suficiente. La generación visual/GPU probablemente costará más que la orquestación.

## ¿Existe algo open source igual o mejor que Higgsfield?

No existe una réplica única y madura que iguale a Higgsfield en UX integrada, catálogo de modelos, skills, investigación, memoria, conexiones y producción final. Sí se puede construir un sistema más controlable combinando piezas:

| Alternativa | Qué reemplaza | Evaluación |
| --- | --- | --- |
| ComfyUI + n8n + LLM | Orquestación y producción visual | Mejor control y portabilidad; más ingeniería |
| ComfyMind sobre ComfyUI | Planificación jerárquica de workflows generativos | Prometedor para investigar; aún proyecto de investigación, no base productiva inicial |
| NodeTool (AGPL) | Canvas multimodal + agentes/modelos | Interesante para prototipos; menos conectores de negocio que n8n |
| Langflow/Flowise | Flujos LLM/agents | Útiles para razonamiento, no reemplazan ComfyUI en edición visual precisa |
| InvokeAI / SwarmUI | Generación visual self-hosted | Alternativas de interfaz; ComfyUI mantiene mejor encaje para grafos/API/ecosistema |

La combinación open source puede superar a Higgsfield en costo marginal, privacidad y control cuando hay volumen y procesos estables. Higgsfield gana al principio en velocidad de aprendizaje y tiempo hasta el primer resultado.

## Arquitectura recomendada para Agentis Ads

```text
Pedido de Mati/cliente
        ↓
n8n: intake + validación
        ↓
MatiOS: marca, producto, audiencia, aprendizajes previos
        ↓
Agente estratega: investigación + hipótesis + brief
        ↓
APROBACIÓN DE MATI (concepto y presupuesto máximo)
        ↓
Router de producción
  ├─ Higgsfield: campaña exploratoria / video complejo rápido
  ├─ ComfyUI: pipeline repetible / variantes / consistencia
  └─ APIs puntuales: copy, voz, música, video o edición
        ↓
QA automático: dimensiones, texto, marca, duplicados, costo
        ↓
APROBACIÓN DE MATI (piezas externas)
        ↓
Publicar/exportar
        ↓
Métricas + aprendizaje → PostgreSQL/Git → reindexación
```

### Regla de aprobación

Se aprueba antes de:

1. consumir más de un presupuesto configurable;
2. publicar o enviar algo externamente;
3. modificar conocimiento canónico contradictorio;
4. usar datos o imágenes sensibles de clientes.

Los borradores, investigaciones internas y generaciones bajo un límite bajo pueden correr sin intervención y quedar en una bandeja de revisión.

## Primera skill candidata: `campaign-research-and-creative-test`

### Entrada

- cliente/producto;
- objetivo comercial;
- audiencia y zona;
- oferta y restricciones;
- canales y formatos;
- presupuesto máximo de investigación/generación;
- fecha límite.

### Proceso

1. Buscar memoria previa del cliente/vertical.
2. Investigar competidores, anuncios y patrones creativos recientes.
3. Separar hechos, inferencias e hipótesis.
4. Proponer 3 ángulos, hooks y CTA con evidencia.
5. Estimar cantidad/costo de variantes.
6. Pedir aprobación del plan y tope.
7. Generar un lote pequeño, no cien variantes de entrada.
8. QA y revisión humana.
9. Lanzar test controlado.
10. Capturar métricas y destilar aprendizaje.

### Salidas durables

- `research.md`: fuentes, fecha, hallazgos y límites.
- `brief.yaml`: entradas estructuradas.
- `hypotheses.yaml`: ángulo, audiencia, hook, CTA y criterio de éxito.
- `workflow.json`: grafo ComfyUI versionado cuando aplique.
- `run.json`: modelos, seeds, costos y hashes de outputs.
- `results.md`: métricas y aprendizajes luego del test.

## Plan de implementación gradual

### Fase 0 — investigación actual

Guardar este mapa y no comprometer arquitectura ni suscripciones.

### Fase 1 — campaña piloto manual asistida

Elegir un caso real: Agentis para canchas. Crear un brief y tres conceptos. Producir 3–6 piezas con Higgsfield y registrar costo, tiempo, iteraciones y calidad usable.

**Salida esperada:** saber si el cuello de botella está en estrategia, assets, edición, aprobación o distribución.

### Fase 2 — reproducir una pieza en ComfyUI

Tomar el tipo de pieza más repetible y construir un workflow con entradas claras. Ejecutarlo primero manualmente; fijar modelos/nodos y guardar un output de referencia.

### Fase 3 — orquestar con n8n

Webhook/brief → consulta a memoria → generación de variantes → espera asíncrona → QA → bandeja de aprobación → exportación. Registrar costo y estado por ejecución.

### Fase 4 — aprendizaje cerrado

Conectar métricas reales de anuncios. El agente no debe “optimizar” por estética: debe priorizar resultados como leads, conversaciones iniciadas, reservas y costo de adquisición.

### Fase 5 — escalar solamente lo comprobado

Agregar colas, concurrencia, GPU dedicada, dashboards y auto-publicación sólo cuando el volumen lo justifique.

## Criterios de decisión después del piloto

| Pregunta | Señal a favor de Higgsfield | Señal a favor de ComfyUI+n8n |
| --- | --- | --- |
| ¿Cuánto cambia cada campaña? | Mucho; trabajo creativo exploratorio | Poco; plantilla repetible |
| ¿Cuántas piezas aprobadas por mes? | Volumen bajo/medio | Volumen alto y estable |
| ¿Necesitamos control fino y consistencia? | Moderado | Alto |
| ¿Tenemos capacidad técnica/operativa? | Baja o queremos velocidad | Sí, y el ahorro compensa |
| ¿Dependencia de un proveedor es aceptable? | Sí | No |
| ¿El costo unitario medido es sostenible? | Sí | No; conviene internalizar |

## Investigaciones automáticas en MatiOS

El patrón puede generalizarse para que MatiOS “aprenda por Mati”, pero no debe investigar temas arbitrarios sin una cola ni límites. El flujo recomendado es:

1. Mati agrega una pregunta o tema a un **backlog de investigación**.
2. Un planificador asigna prioridad, profundidad, fuentes permitidas, costo y fecha de caducidad.
3. Una tarea nocturna toma como máximo una investigación aprobada.
4. Produce borrador con fuentes, fecha, grado de confianza y contradicciones.
5. A la mañana entrega resumen ejecutivo y recomendación.
6. Sólo después de revisión se promueve a conocimiento canónico en Git; el borrador no se confunde con verdad vigente.
7. El Memory Curator deduplica, vincula y reindexa.

### Guardrails

- Tope de tiempo, dinero y cantidad de fuentes por run.
- Citar fuentes primarias siempre que existan.
- Marcar información temporal y fecha de próxima revisión.
- No ejecutar acciones externas como consecuencia de la investigación.
- No auto-modificar decisiones o reglas de negocio sin aprobación.
- Evitar duplicados y conservar historial.

Esto sí coincide con el patrón general de MatiOS:

`pedido/backlog → plan → skill → herramientas/modelos → revisión humana → conocimiento → métricas → aprendizaje`

## Decisión provisional

1. **Probar Higgsfield**, sin dependencia estructural.
2. **Aprender ComfyUI por un caso concreto**, no mediante un curso largo previo.
3. **Usar n8n como orquestador principal** de Agentis y MatiOS.
4. **No comprar GPU** hasta medir volumen y costo.
5. **Versionar workflows, briefs y aprendizajes en Git**.
6. **Automatizar investigación con backlog y revisión**, no como exploración ilimitada por default.

## Fuentes principales

- Higgsfield Supercomputer: https://higgsfield.ai/supercomputer-intro
- Higgsfield pricing: https://higgsfield.ai/pricing
- Comparación oficial de precios publicada por Higgsfield (junio 2026): https://higgsfield.ai/blog/best-all-in-one-subscription-ai-images-video
- ComfyUI docs: https://docs.comfy.org/
- ComfyUI API overview: https://docs.comfy.org/development/api-development/overview
- Comfy Cloud API: https://docs.comfy.org/development/cloud/overview
- ComfyUI Server API: https://docs.comfy.org/development/comfyui-server/comms_overview
- ComfyUI Agent Tools/MCP: https://docs.comfy.org/agent-tools
- Partner Nodes: https://docs.comfy.org/tutorials/partner-nodes/overview
- n8n Community Edition: https://docs.n8n.io/deploy/host-n8n/community-edition-features/
- n8n Sustainable Use License: https://docs.n8n.io/privacy-and-security/sustainable-use-license/
- n8n pricing: https://n8n.io/pricing/
- Ejemplo oficial n8n ↔ ComfyUI: https://n8n.io/workflows/4468-generate-ai-media-with-comfyui-images-video-3d-and-audio-bridge/
- ComfyMind paper/project: https://arxiv.org/abs/2505.17908

