# Obsidian Knowledge OS — MatiOS + Agentis + estudio

## Objetivo

Usar Obsidian como la capa de conocimiento humano y operativo de Mati: un lugar durable, buscable y enlazable para proyectos, aprendizaje, facultad, decisiones, SOPs, ideas y contexto de Agentis.

Obsidian NO reemplaza GitHub, Graphify ni la documentación dentro de cada repo. La arquitectura deseada es:

`Repos/GitHub = source of truth técnico`  
`Obsidian = knowledge OS humano/transversal`  
`Graphify = grafo técnico consultable por agentes`  
`Archify = mapas visuales de arquitectura`  
`Claude/Codex/Gemini = trabajadores que leen/escriben sobre esas capas`

Regla: evitar duplicar la misma verdad en dos lugares. El conocimiento estable/transversal vive en Obsidian; el conocimiento necesario para construir/ejecutar un repo vive también dentro del repo.

## Decisión de arquitectura: un vault principal

Recomendación inicial: **un solo vault principal: `MatiOS`**.

No separar Facultad, Agentis, vida, aprendizaje y proyectos en vaults distintos salvo que aparezca una razón fuerte de seguridad, privacidad o tamaño. El valor de Obsidian aumenta cuando se pueden cruzar conceptos entre dominios.

Ejemplos de relaciones útiles:
- una materia de IA puede alimentar Agentis;
- un patrón aprendido en Galicia puede convertirse en principio técnico reutilizable sin copiar información confidencial;
- una investigación de APIs puede servir a Agentis, MATYOS y otros proyectos;
- una idea de contenido puede vincularse con Content Factory y con un proyecto comercial.

Separar por **carpetas, propiedades y links**, no por vaults.

## Estructura inicial propuesta

```text
MatiOS/
├── 00 Inbox/
├── 01 Home/
│   ├── Home.md
│   ├── Today.md
│   └── Dashboard.md
├── 10 Projects/
│   ├── Agentis/
│   ├── MATYOS/
│   ├── Casa/
│   └── Otros/
├── 20 Areas/
│   ├── Trabajo/
│   ├── Facultad/
│   ├── Finanzas/
│   ├── Hogar/
│   └── Aprendizaje/
├── 30 Knowledge/
│   ├── AI/
│   ├── n8n/
│   ├── APIs/
│   ├── CRM/
│   ├── Programming/
│   ├── Data/
│   └── Business/
├── 40 Resources/
│   ├── Repos/
│   ├── Papers/
│   ├── Cursos/
│   ├── Videos/
│   └── Tools/
├── 50 Decisions/
├── 60 Meetings/
├── 70 Daily/
├── 80 Templates/
└── 90 Archive/
```

Evitar crear una taxonomía enorme al inicio. Si algo no tiene lugar claro, va a `00 Inbox` y se procesa después.

## Proyecto/repo: qué va dónde

### Dentro del repo
Debe vivir todo lo necesario para que un agente o desarrollador pueda reconstruir y mantener el software sin depender de Obsidian:
- `README.md`
- `AGENTS.md`
- `CLAUDE.md` cuando corresponda
- `/docs/architecture.md`
- `/docs/specs/`
- contratos/interfaces
- setup/deploy
- tests y Definition of Done
- decisiones técnicas que afecten directamente al código

### En Obsidian
Debe vivir la capa humana/transversal:
- por qué hacemos el proyecto;
- problema de negocio;
- research de mercado;
- aprendizaje;
- decisiones de producto;
- ideas descartadas y por qué;
- pricing/posicionamiento;
- reuniones;
- checklist de revisión de Mati;
- links al repo, issues, PRs y documentación técnica;
- conexiones con otros proyectos/conocimientos.

Cada proyecto tiene una nota MOC (Map of Content), por ejemplo `10 Projects/Agentis/Agentis.md`.

## Nota de proyecto estándar

Propiedades sugeridas:

```yaml
---
type: project
status: active
area: business
repo: matiirueda/agentis
owner: Mati
created: 2026-09-10
review: weekly
---
```

Cuerpo:

```text
# Agentis

## Objetivo
## Estado actual
## Próxima acción
## Decisiones
## Arquitectura
## Mercado
## Aprendizajes
## Repos / links
## Personas / herramientas relacionadas
## Historial importante
```

## Conocimiento reutilizable

No guardar conocimiento sólo dentro del proyecto que lo originó si puede servir a otros.

Ejemplo:

`Agentis/Lead Engine` enlaza a `30 Knowledge/CRM/Lead Qualification.md`.

La nota de Lead Qualification contiene el conocimiento reusable y la nota del proyecto contiene cómo Agentis lo aplica.

Usar links `[[...]]` antes que copiar/pegar. Tags para estados/categorías amplias; links para relaciones semánticas reales.

## Facultad

La facultad puede vivir en el mismo vault:

```text
20 Areas/Facultad/
├── Carrera.md
├── Materias/
│   ├── Materia A/
│   │   ├── Materia A.md
│   │   ├── Clases/
│   │   ├── TP/
│   │   └── Examenes/
└── Conceptos/
```

Cuando un concepto sea generalizable, mover/crear su nota canónica en `30 Knowledge` y enlazarla desde la materia. Así el conocimiento deja de morir cuando termina la cursada.

## Daily notes e Inbox

El sistema debe ser rápido de usar.

Durante el día:
- idea rápida → Inbox;
- qué hice/aprendí → Daily;
- decisión importante → Decision note o nota del proyecto;
- concepto reusable → Knowledge.

No obligar a clasificar perfecto al capturar. Capturar primero, organizar después.

## Decisiones

Crear notas breves para decisiones importantes:

```yaml
---
type: decision
project: Agentis
status: accepted
date: 2026-09-10
---
```

```text
# Usar GHL como CRM prioritario

## Contexto
## Opciones
## Decisión
## Por qué
## Qué haría cambiar esta decisión
## Links / evidencia
```

Esto evita que Claude/Codex/Gemini vuelvan a discutir desde cero decisiones ya tomadas.

## Flujo con agentes

Objetivo futuro:

`Mati captura/decide → Obsidian guarda contexto humano → repo guarda contexto ejecutable → Graphify indexa proyecto → agente trabaja → PR/tests → docs repo se actualizan → Obsidian recibe aprendizaje/decisión/resumen → Mati revisa`

Los agentes pueden leer notas Markdown directamente si tienen acceso a la carpeta del vault. No hacer que dependan de un plugin propietario para el conocimiento esencial.

### Antes de una tarea
El Project Lead debe consultar:
1. `AGENTS.md` y docs del repo;
2. MOC del proyecto en Obsidian;
3. decisiones relacionadas;
4. Graphify si necesita navegar relaciones técnicas complejas.

### Después de una tarea importante
Debe actualizar:
1. código/tests;
2. documentación técnica del repo;
3. decisión/aprendizaje/estado en Obsidian si cambió conocimiento humano;
4. Archify si cambió arquitectura y el tamaño lo justifica;
5. Graphify/reindex cuando corresponda.

## Sincronización y backup

Separar conceptualmente **sync** de **backup/versionado**.

Opciones:
- Obsidian Sync: cómodo para PC + iPhone y cifrado end-to-end; usarlo si se prioriza simplicidad/móvil.
- Git: excelente como historial/versionado del Markdown y acceso por agentes/desarrollo.

Recomendación para Mati:
- comenzar con vault local + GitHub privado para versionado;
- si la experiencia iPhone con Git se vuelve frágil, usar Obsidian Sync para sincronización móvil y mantener Git como backup/versionado desde la PC;
- no forzar Obsidian Git en iPhone como pieza crítica si genera conflictos.

Nunca guardar tokens, passwords, claves API o secretos en el vault aunque el repo sea privado. Usar password manager/secrets manager y guardar sólo referencias.

## Plugins — política

Empezar con core de Obsidian y pocos plugins. Cada plugin aumenta complejidad y superficie de riesgo.

Primera fase:
- Daily Notes (core)
- Templates (core)
- Properties
- Search
- Backlinks
- Graph View
- Canvas si realmente aporta
- Obsidian Git en desktop si se decide Git desde Obsidian

Agregar luego sólo por dolor real: Dataview/Templater u otros pueden ser valiosos, pero no deben ser requisito para que el conocimiento siga siendo Markdown portable.

## Principios

1. Un vault principal hasta que exista razón fuerte para separar.
2. Markdown simple y portable como base.
3. Repo = verdad técnica ejecutable.
4. Obsidian = memoria humana/transversal.
5. Graphify = comprensión técnica para agentes.
6. Archify = visualización/explicación de arquitectura.
7. Links antes que duplicación.
8. Captura rápida; organización posterior.
9. Decisiones registradas para no reabrir debates sin nueva evidencia.
10. Knowledge reusable separado de la aplicación concreta del proyecto.
11. Ningún secreto dentro del vault.
12. Plugins mínimos; sistema útil incluso si todos desaparecen.

## Plan de instalación v0.1

1. Instalar Obsidian Desktop en la PC.
2. Crear vault local `MatiOS`.
3. Crear la estructura mínima: Inbox, Projects, Areas, Knowledge, Resources, Decisions, Daily, Templates, Archive.
4. Activar core plugins necesarios: Daily Notes, Templates, Backlinks, Search/Graph.
5. Crear `Home.md`, template de Project y template de Decision.
6. Migrar primero Agentis y la Facultad; no migrar toda la vida de golpe.
7. Inicializar el vault como repo Git privado y hacer el primer commit.
8. Probar durante una semana captura + búsqueda + links antes de instalar muchos plugins.
9. Conectar progresivamente Claude Code, Codex y Gemini al vault con permisos de lectura; escritura sólo mediante reglas/SOP y revisión humana.
10. Probar Graphify sobre el repo Agentis y evaluar si conviene indexar además una selección de documentos del vault.

## Pendientes de investigación/implementación

- [ ] Confirmar ubicación física del vault en la PC y estrategia PC+iPhone.
- [ ] Elegir GitHub privado vs Obsidian Sync + Git backup.
- [ ] Crear templates reales para Project, Decision, Learning, Meeting y Daily.
- [ ] Crear MOC de Agentis.
- [ ] Crear MOC de Facultad.
- [ ] Definir SOP de lectura/escritura de Obsidian para Claude/Codex/Gemini.
- [ ] Definir qué notas pueden editar agentes y cuáles requieren aprobación.
- [ ] Investigar integración MCP/CLI sólo si simplifica frente a acceso directo a Markdown.
- [ ] Evaluar Web Clipper para research.
- [ ] Diseñar backup independiente además de sync.
