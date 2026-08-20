# Aprobación profesional y versiones

## Objetivo

La IA prepara y adapta; Matías y su socio revisan las decisiones individuales relevantes. El alumno recibe solamente versiones aprobadas.

## Estados

1. `draft`: propuesta editable, todavía no asignable.
2. `pending_review`: lista para revisión y bloqueada para evitar cambios silenciosos.
3. `approved`: versión vigente y entregable.
4. `changes_requested`: vuelve a edición con comentarios concretos.
5. `rejected`: no debe asignarse.
6. `superseded`: fue reemplazada por otra versión aprobada.

## Resumen para revisar

Presentar en una sola vista:

- alumno, objetivo, experiencia, disponibilidad y equipamiento;
- antecedentes, molestias y deportes relevantes;
- división y frecuencia por patrón o músculo;
- ejercicios, series semanales, repeticiones, RPE/RIR y descanso;
- progresión, sustituciones y criterio de adaptación;
- diferencias frente a la versión anterior;
- supuestos o información faltante;
- alertas y motivos que requieren criterio profesional.

## Cambios que requieren nueva aprobación

- nuevo plan o cambio de objetivo;
- nueva frecuencia o división;
- cambio de un ejercicio principal no previsto como sustitución;
- aumento material del volumen o intensidad;
- regreso después de lesión, enfermedad o pausa prolongada;
- aparición de dolor recurrente o nueva restricción;
- metas nutricionales individualizadas o restricciones clínicas.

Cambiar el orden, acortar una sesión según la guía o usar una alternativa previamente aprobada no crea por sí solo una nueva versión.

## Auditoría

Guardar propuesta, decisión, `reviewer_id`, fecha, comentario, versión anterior y hash del contenido. Nunca sobrescribir una versión aprobada: crear una nueva.
