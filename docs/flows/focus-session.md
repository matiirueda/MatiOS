# Flujo n8n — Focus Session

## Objetivo
Convertir Telegram en una interfaz de ejecución acompañada: Mati dice qué necesita hacer, MatiOS divide la tarea y n8n sostiene el ritmo con timers y mensajes contextuales.

## Inicio
Telegram message -> MatiOS Core -> Router -> Focus Skill

## Pipeline
1. Crear `focus_session` en PostgreSQL.
2. Generar plan de pasos pequeños.
3. Persistir todos los pasos, pero mostrar solamente el actual.
4. Esperar respuesta de Mati.
5. Si responde `terminé`:
   - completar step actual;
   - decidir pausa;
   - si hay pausa, guardar `next_check_at` y crear espera/trigger n8n;
   - al vencer, recuperar sesión y enviar siguiente acción.
6. Si responde que está trabado:
   - Focus Skill subdivide el paso actual;
   - reemplazarlo por acciones más pequeñas.
7. Si no responde:
   - política configurable de nudges; evitar insistencia excesiva.
8. Al completar todos los pasos:
   - cerrar sesión;
   - registrar duración/resultados;
   - Memory Curator evalúa si hubo un aprendizaje estable que guardar.

## Eventos sugeridos
- focus_session_started
- focus_step_started
- focus_step_completed
- focus_break_started
- focus_break_completed
- focus_session_completed
- focus_session_abandoned

## Separación de responsabilidades
- Telegram: canal.
- MatiOS Core: entiende la conversación.
- Focus Skill: decide cómo partir y acompañar la tarea.
- PostgreSQL: mantiene el estado.
- n8n: timers, esperas y triggers.
- Memory Curator: decide qué aprendizaje persiste.

## Regla UX
Durante ejecución, nunca devolver un dashboard mental completo si una sola próxima acción es suficiente.