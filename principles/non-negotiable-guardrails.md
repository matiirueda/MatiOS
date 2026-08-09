# MatiOS — No negociables / Guardrails

## Propósito
Los acuerdos críticos de MatiOS no pueden depender de que un modelo recuerde una conversación anterior. Deben persistir como reglas globales, cargarse antes de actuar y, cuando sea posible, estar reforzados técnicamente por la infraestructura.

## Jerarquía
Estos guardrails están por encima de agentes, skills y flujos particulares.

`Mati -> Core -> GUARDRAILS -> Router/Skills -> Plan/Action -> GUARDRAILS -> Execution`

Una skill no puede ignorar un guardrail por conveniencia.

## No negociables iniciales

### 1. DEV antes que PROD
Todo cambio relevante debe probarse primero fuera de producción cuando exista un entorno de ejecución.

### 2. Git: branch + PR + aprobación
El comportamiento normal para conocimiento, código, configuración y documentación versionada es:

`branch -> commit -> PR/diff -> revisión de Mati -> merge a main`

Los agentes constructores no deben escribir directamente a `main` como flujo normal, aunque técnicamente tengan permisos.

### 3. Mati es el approval gate de PROD
La promoción a producción requiere aprobación explícita de Mati salvo que exista en el futuro una política específica, previamente aprobada, que autorice una categoría de cambios automáticos de bajo riesgo.

### 4. Reglas importantes: enforcement técnico
No confiar únicamente en prompts o memoria del modelo. Cuando sea posible, implementar controles reales: branch protection, required reviews/checks, permisos separados, credenciales DEV/PROD, CI/CD gates y políticas de despliegue.

### 5. Secretos fuera de Git
Tokens, passwords, API keys y credenciales reales nunca se versionan en el repositorio. Usar secret stores/variables de entorno con mínimo privilegio.

### 6. Cambios destructivos requieren protección
Borrados, migraciones destructivas y operaciones difíciles de revertir requieren evaluación explícita, backup cuando corresponda y plan de rollback antes de PROD.

### 7. Separación de responsabilidades de datos
- Git: conocimiento curado, reglas, skills, código y artefactos versionables.
- PostgreSQL: estado vivo e histórico estructurado.
- Drive/object storage: archivos originales/pesados.
- pgvector/RAG: índice derivado y reconstruible.

No crear una segunda fuente de verdad accidental.

### 8. Trazabilidad
Todo cambio realizado por un agente debe poder responder qué cambió, por qué, quién/qué lo produjo y cómo volver atrás cuando sea relevante.

## Regla de diseño
Un no negociable crítico debería evolucionar desde:

`acuerdo conversacional -> regla persistente -> test/check automático -> enforcement de infraestructura`

Cuanto mayor sea el riesgo de incumplimiento, menos debe depender del comportamiento voluntario del modelo.

## Aplicación al Memory Curator
Memory Curator decide qué conocimiento merece persistir, pero no es dueño de estos guardrails. Si propone un cambio en Git, debe respetar branch/PR/review. Si el conocimiento corresponde a otra capa, debe enrutarlo allí respetando sus controles.

## Aplicación a proyectos futuros
Los proyectos que nazcan dentro del ecosistema MatiOS/Agentis heredan estos guardrails por defecto. Las excepciones deben ser explícitas, justificadas y aprobadas.
