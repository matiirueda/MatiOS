# MatiOS 🤖

Sistema operativo personal de Mati: memoria durable + agentes + automatización para ayudar a tomar mejores decisiones y ejecutar hábitos/proyectos sin depender de la memoria de una conversación.

## Visión
MatiOS no es solo un chatbot. El objetivo es construir un cerebro personal portable entre modelos y canales.

```text
Mati / canales
      ↓
MatiOS Core + Router
      ↓
Skills especializadas
      ↓
Git + PostgreSQL + pgvector
      ↓
Agentes / herramientas
      ↓
       n8n
```

## Fuentes de verdad
- **Git:** conocimiento estable y curado: preferencias, objetivos, rutinas, recetas, proyectos, decisiones y skills.
- **PostgreSQL:** eventos/históricos: comidas, entrenamientos, hábitos, sueño, mediciones, tareas y recordatorios.
- **pgvector:** índice semántico derivado para encontrar contexto; no es la fuente primaria.

## Agentes iniciales
- **MatiOS Core:** router y coordinador.
- **Health Coach:** hábitos, nutrición, entrenamiento, movilidad y skincare.
- **Agentis Coach:** ejecución del proyecto Agentis.
- **Life Admin:** agenda, tareas y recordatorios.
- **Memory Curator:** analiza la conversación reciente y decide qué guardar, actualizar, registrar como evento o ignorar.

## Skills
Las skills son procedimientos versionados que explican cómo resolver cada dominio y qué conocimiento consultar. Ver `skills/`.

## Flujo crítico de memoria
```text
conversación
   ↓
Memory Curator
   ↓
extraer + deduplicar + clasificar
   ↓
Git / PostgreSQL / ignorar / pedir confirmación
   ↓
reindexar pgvector
```

Esto permite que una conversación futura pueda reconstruir contexto leyendo MatiOS aunque la memoria del modelo sea limitada.

## Estructura conceptual
```text
MatiOS/
├── cerebro/                 # conocimiento personal curado
├── recetas/                 # recetario personal
├── skills/                  # procedimientos del cerebro
│   ├── router/
│   ├── memory/
│   ├── habits/
│   ├── nutrition/
│   ├── training/
│   ├── mobility/
│   ├── skincare/
│   ├── life-admin/
│   └── agentis/
├── docs/
│   ├── arquitectura-cerebro-matios.md
│   └── flows/memory-curator.md
├── src/                     # backend/API
├── prompts/
├── scripts/
├── docker/
├── tests/
└── config/
```

## Stack
- Python 3.11+
- FastAPI
- PostgreSQL + pgvector
- Docker / Docker Compose
- Telegram inicialmente como canal DEV
- n8n como orquestador futuro
- GitHub como memoria curada/versionada

## Camino de implementación
1. ✅ Estructura inicial y memoria curada en Git.
2. ✅ Skills iniciales y diseño de Memory Curator.
3. ⬜ PostgreSQL + pgvector.
4. ⬜ API mínima para eventos/memoria.
5. ⬜ Canal DEV (Telegram u otro).
6. ⬜ RAG sobre Git + DB.
7. ⬜ Implementar Memory Curator end-to-end.
8. ⬜ n8n: recordatorios, morning brief, cierre diario y triggers.
9. ⬜ Agentes coordinadores Health / Agentis / Life Admin.

## Principios
- Un recorrido completo y pequeño vale más que veinte carpetas sin funcionamiento.
- Pocos agentes, muchas skills pequeñas.
- Git para verdad; DB para historia; vector para búsqueda.
- No guardar conversaciones enteras: destilar aprendizajes.
- Reducir decisiones y aumentar repeticiones útiles.