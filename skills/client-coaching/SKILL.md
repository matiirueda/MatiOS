---
name: matios-client-coaching
description: Coordinar el acompañamiento remoto de clientes de MatiOS por WhatsApp y web. Usar al dar de alta un alumno, generar y enviar planes para revisión profesional, guiar una sesión ejercicio por ejercicio, registrar mensajes de entrenamiento o comida, ejecutar check-ins, detectar baja adherencia y decidir qué puede automatizarse o debe escalarse a los profesionales.
---

# Acompañamiento de clientes MatiOS

## Principio de interfaz

Usar WhatsApp para actuar y registrar; usar la web para explorar fichas, planificación e historial. No exigir que el alumno vuelva a cargar en la web lo que ya informó por conversación.

## Flujo

1. Identificar alumno, intención y estado actual: onboarding, planificación, sesión, comida, check-in o consulta.
2. Cargar solo las skills necesarias: Training, Nutrition, Mobility o Health.
3. Recuperar la última versión aprobada y los eventos recientes; no asumir que un borrador está vigente.
4. Convertir el mensaje natural en un evento estructurado y conservar el texto original para auditoría.
5. Ejecutar la siguiente acción permitida o crear una propuesta para revisión.
6. Responder primero con lo que el alumno necesita hacer ahora.
7. Actualizar el historial y la proyección de la web desde el mismo evento.

## Aprobación humana

- Enviar a revisión profesional toda rutina o plan nutricional individual nuevo.
- Reenviar cuando cambien objetivo, frecuencia, volumen relevante, ejercicios principales, metas nutricionales, restricciones o aparezcan síntomas que excedan ajustes previstos.
- Permitir sustituciones y reducciones ya autorizadas por la versión vigente.
- Registrar `reviewer_id`, decisión, fecha, comentarios y versión aprobada.
- No presentar decisiones clínicas como decisiones autónomas de la IA.

## Sesión por WhatsApp

1. Al recibir “¿qué tengo hoy?”, mostrar resumen y ofrecer comenzar.
2. Al comenzar, enviar solo el primer ejercicio con ficha visual, series, repeticiones, RPE/RIR y descanso.
3. Interpretar las series informadas, confirmarlas brevemente y guardarlas.
4. Proponer carga siguiente solo usando el plan y el historial disponible.
5. Enviar el próximo ejercicio hasta completar, pausar o abandonar la sesión.
6. Cerrar con resumen, progreso y cualquier punto que deban revisar los entrenadores.

Seguir `../../entrenamiento/guias/coaching-conversacional-whatsapp.md` y `../../entrenamiento/guias/aprobacion-profesional.md`.

## Alertas

Escalar dolor agudo o creciente, síntomas de alarma, cambios médicos, conductas alimentarias de riesgo, baja adherencia persistente, ausencia prolongada o una solicitud fuera del alcance acordado. Una alerta no sustituye atención médica ni diagnóstico.
