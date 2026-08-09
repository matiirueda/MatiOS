# ADR-0001 — DEV y PROD completamente aislados

## Estado
Aceptado.

## Contexto
MatiOS va a permitir crear y modificar funcionalidades desde conversaciones. Eso exige un entorno donde experimentar sin comprometer datos ni comportamiento estable.

## Decisión
DEV y PROD tendrán recursos separados: bot/canal, PostgreSQL, pgvector, credenciales, workflows, configuración y despliegues.

## Consecuencias
- Los cambios pueden desplegarse automáticamente en DEV.
- La promoción a PROD requiere una versión identificable y aprobación explícita en la etapa inicial.
- Los datos personales de PROD no se copian automáticamente a DEV; cuando haga falta se usan datos sintéticos o una copia sanitizada.
- Un fallo en DEV no debe afectar PROD.
