# Módulo de entrenamiento MatiOS

Fuente de verdad para ejercicios, rutinas y criterios de progresión. Los registros personales (cargas, repeticiones, esfuerzo, dolor y adherencia) pertenecen a PostgreSQL; Git conserva solamente conocimiento curado y plantillas versionadas.

## Estructura

- `ejercicios/`: una ficha por ejercicio, preparada para texto, video y variantes.
- `rutinas/`: planes base reutilizables. Una rutina asignada a una persona debe convertirse en una versión fechada.
- `guias/`: reglas para progresar, adaptar tiempo disponible y actuar ante molestias.
- `esquemas/`: contratos para que WhatsApp, la web y la base de datos hablen el mismo idioma.

## Circuito operativo

1. Training combina fichas y dosis para crear una versión `draft`.
2. Matías o su socio revisan y aprueban la versión.
3. Client Coaching guía por WhatsApp un ejercicio por vez.
4. Cada mensaje se convierte en series y eventos estructurados.
5. La web proyecta esos mismos datos como rutina, historial y progreso.

Ver `guias/aprobacion-profesional.md`, `guias/coaching-conversacional-whatsapp.md` y `esquemas/rutina.schema.yaml`.

## Principios

1. Explicar cada movimiento para una persona que nunca entrenó.
2. Registrar lo realmente realizado, no solamente lo planificado.
3. Adaptar sin perder el objetivo principal de la rutina.
4. Tratar dolor y síntomas como señales para detener, modificar o escalar; nunca diagnosticar.
5. Mantener las decisiones importantes explicables y revisables por el entrenador.
6. Los videos propios de MatiOS complementan la explicación escrita, pero no la reemplazan.

## Estado de una ficha

- `borrador`: estructura creada, pendiente de revisión.
- `revisado`: técnica y redacción revisadas por Matías y su socio.
- `grabado`: contiene video propio aprobado.
- `publicado`: disponible para usuarios.

## Flujo de publicación de videos

1. Grabar una demostración completa y otra toma cercana si existe un detalle técnico importante.
2. Revisar ejecución, audio, encuadre y seguridad.
3. Publicar el archivo en el almacenamiento de medios.
4. Completar `video_url`, `video_duracion_segundos` y `video_version` en la ficha.
5. Verificar reproducción en web y WhatsApp antes de marcarla como `publicado`.
