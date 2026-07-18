# MatiOS 🤖

Sistema Operativo de Mati - Tu agente personal de vida.

## Descripción

MatiOS es un asistente inteligente que aprende tus preferencias y hábitos para ayudarte en tu día a día. Comienza con el seguimiento de nutrición, registrando lo que comes y recomendando comidas basadas en tus preferencias y tu historial.

## Objetivo Principal

> Escribo desde DEV qué comí, MatiOS lo registra y luego puede usar ese dato junto con mis preferencias para recomendarme la próxima comida.

## Estructura del Proyecto

```
matios/
├── src/                      # Código fuente principal
│   ├── api/                  # API FastAPI
│   ├── core/                 # Lógica central
│   ├── db/                   # Modelos y migraciones
│   └── services/             # Servicios de negocio
├── prompts/                  # Prompts para Codex/LLMs
├── scripts/                  # Scripts de utilidad
├── docker/                   # Configuración Docker
├── tests/                    # Tests unitarios
├── config/                   # Configuración
└── docs/                     # Documentación
```

## Stack Tecnológico

- **Backend**: Python 3.11+
- **API**: FastAPI
- **Base de datos**: PostgreSQL + pgvector
- **Contenedorización**: Docker & Docker Compose
- **Integración**: Telegram (DEV)
- **Automatización**: n8n (futuro)

## Roadmap

1. ✅ Inicializar estructura
2. ⬜ Docker Compose (PostgreSQL + pgvector)
3. ⬜ API mínima (registrar comidas)
4. ⬜ Integración Telegram DEV
5. ⬜ Sistema de preferencias con pgvector
6. ⬜ Motor de recomendaciones
7. ⬜ Automatización con n8n

## Guía Rápida

Consulta [MatiOS-Guia-de-Inicio.md](./MatiOS-Guia-de-Inicio.md) para instrucciones detalladas de configuración.

---

**Mantra**: Un recorrido completo y pequeño vale más que veinte carpetas sin funcionamiento.
