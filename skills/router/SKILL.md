# MatiOS Router Skill

## Propósito
Ser la puerta de entrada del cerebro MatiOS. Interpretar la intención del mensaje y cargar solamente las skills y el conocimiento necesarios.

## Flujo
1. Clasificar intención principal y, si aplica, secundarias.
2. Seleccionar skills relevantes.
3. Buscar primero conocimiento curado en Git.
4. Consultar histórico/eventos en PostgreSQL cuando la respuesta dependa del tiempo.
5. Usar pgvector únicamente como índice de recuperación, nunca como fuente de verdad.
6. Ejecutar acciones externas mediante el agente/orquestador correspondiente.
7. Al terminar la interacción, pasar la conversación a Memory Curator.

## Rutas iniciales
- comida, receta, macros -> nutrition
- rutina, constancia, checklist -> habits
- postura, cuello, movilidad -> mobility
- piel, serum, FPS -> skincare
- entrenamiento, fútbol, gym -> training
- agenda, recordatorios -> life-admin
- Agentis, producto, ventas, aprendizaje -> agentis
- nueva preferencia, aprendizaje, decisión -> memory

## Principio
No cargar todo MatiOS en cada prompt. Recuperar el mínimo contexto suficiente y citar/identificar la fuente interna utilizada cuando sea útil.