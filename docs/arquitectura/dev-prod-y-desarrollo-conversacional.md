# DEV/PROD y desarrollo conversacional

## Objetivo

MatiOS debe permitir que una idea hablada se convierta en una mejora probada y desplegable sin poner en riesgo producción.

## Entornos aislados

DEV y PROD deben estar completamente separados:

- bot/canal propio;
- base PostgreSQL propia;
- índice pgvector propio;
- workflows y credenciales propios;
- configuración, logs y almacenamiento propios.

La regla es que un fallo en DEV nunca pueda afectar PROD.

## Flujo ideal

```text
idea hablada
  ↓
captura y clasificación
  ↓
job en cola
  ↓
rama Git
  ↓
Codex implementa
  ↓
tests + evals
  ↓
deploy automático DEV
  ↓
prueba desde Telegram DEV
  ↓
aprobación explícita
  ↓
merge
  ↓
deploy PROD
  ↓
health check / rollback
```

## Estados de un trabajo

```text
queued
running
awaiting_review
deployed_dev
user_testing
approved
deployed_prod
failed
rolled_back
```

## Principios

- Automatizar la ejecución, gobernar la promoción.
- Producción no se modifica directamente.
- Un cambio nuevo se prueba primero en DEV.
- Las migraciones, prompts, skills y workflows deben estar versionados en Git.
- Una segunda idea puede quedar en cola mientras existe otro trabajo incompatible en ejecución.
- Todo comando con efecto lateral debe ser idempotente.

## Futuro

Cuando las evaluaciones y rollbacks sean suficientemente maduros, algunas promociones podrán automatizarse con políticas explícitas, sin eliminar trazabilidad ni separación de entornos.
