# Flujo — Captura y curación

## Principio

> Capture first, curate later.

Capturar una idea debe ser instantáneo. Convertirla en memoria permanente requiere clasificación y criterio.

## Flujo

```text
entrada cruda
  ↓
clasificar
  ↓
¿es reutilizable?
  ├─ no -> ignorar / dejar en sesión
  └─ sí
      ↓
   deduplicar
      ↓
   detectar conflicto
      ↓
   asignar estado
      ↓
   Git / PostgreSQL / propuesta
```

## Estados de conocimiento

- observed: apareció como observación;
- proposed: existe una propuesta de incorporación;
- validated: confirmado como conocimiento vigente;
- deprecated: conocimiento anterior reemplazado;
- rejected: hipótesis o propuesta descartada.

## Regla
No guardar conversaciones enteras por defecto. Guardar la versión destilada que pueda mejorar decisiones futuras.
