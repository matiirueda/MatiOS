# Visión de MatiOS

## Norte
MatiOS es un cerebro personal acumulativo, portable y orientado a la acción. Su propósito es ayudar a Mati a pensar mejor, recordar lo importante, aprender de la experiencia, priorizar y ejecutar, sin depender de la memoria limitada de una conversación ni de un proveedor de IA concreto.

## Premisas

### 1. Cada experiencia debe abaratar la siguiente
Lo aprendido construyendo, estudiando, investigando o resolviendo problemas debe destilarse y quedar disponible para acelerar tareas y proyectos futuros.

No queremos pagar dos veces el mismo costo cognitivo.

### 2. El conocimiento pertenece a MatiOS, no al modelo
Git, PostgreSQL y formatos portables conservan conocimiento y estado. GPT, Claude, Gemini, modelos locales, Telegram, WhatsApp, n8n, Railway u otras herramientas son componentes reemplazables.

Cambiar de modelo o interfaz no debe significar perder el cerebro construido.

### 3. El asistente construye; Mati mantiene agencia
Los agentes pueden investigar, proponer, programar, documentar, desplegar en DEV, organizar y automatizar. Las decisiones relevantes mantienen human-in-the-loop y los cambios a producción siguen el estándar global de aprobación.

Ver `principles/development-and-deployment.md`.

### 4. Convertir intención en acción
MatiOS no debe limitarse a responder preguntas. Debe poder transformar objetivos en proyectos, tareas y siguientes acciones pequeñas; acompañar sesiones de foco; recordar en momentos útiles; medir resultados y aprender de ellos.

### 5. Automatizar patrones, no casos aislados
Cuando una solución se repite, buscar convertirla en skill, template, workflow parametrizado, componente o producto reutilizable.

La repetición es una señal de que existe una abstracción potencial.

### 6. Construir para uno antes de generalizar
MatiOS es el laboratorio y primer usuario real. Primero debe generar valor sostenido en la vida cotidiana de Mati. Solo después se abstraen los patrones que demostraron funcionar.

### 7. Memoria selectiva, no acumulación indiscriminada
Guardar más información no equivale a tener mejor memoria. Memory Curator debe conservar aquello que mejore decisiones, personalización o velocidad futura y descartar ruido, duplicados e inferencias débiles.

### 8. Estado y conocimiento son cosas distintas
El conocimiento durable vive principalmente en Git. Objetivos activos, proyectos, tareas, progreso, eventos y demás estado temporal viven principalmente en PostgreSQL. pgvector facilita encontrar contexto, pero no reemplaza la fuente de verdad.

### 9. Pocos agentes, skills componibles
Mati habla principalmente con MatiOS Core. El Router carga las skills necesarias según la intención. Crear un agente separado solo cuando exista una responsabilidad autónoma que realmente lo justifique.

### 10. Aprender haciendo
La construcción de MatiOS debe servir simultáneamente para aprender agentes, RAG, n8n, APIs, bases de datos, DevOps, automatización y diseño de producto. Ese conocimiento vuelve a MatiOS y puede reutilizarse en Agentis.

## Loop central

`hacer → observar → documentar → destilar → indexar → reutilizar → hacer mejor → volver a aprender`

## Resultado buscado
Con el tiempo, MatiOS debería necesitar cada vez menos contexto explícito para ayudar correctamente, porque conserva decisiones, conocimiento, experiencia y estado en sistemas propios y recuperables.