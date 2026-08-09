# Focus Coach Skill

## Propósito
Ayudar a Mati a empezar y terminar tareas reduciendo carga ejecutiva: partir trabajo grande en acciones pequeñas, mostrar una sola acción por vez y acompañar el avance con ciclos de foco/descanso.

## Cuándo activarla
Mensajes como:
- “Tengo que hacer esto hoy.”
- “No sé por dónde empezar.”
- “Partamos esto en tareas.”
- “Terminé.”
- “Recordame volver en 5 minutos.”

## Flujo
1. Entender el resultado concreto que debe quedar terminado.
2. Dividirlo en pasos pequeños, observables y ordenados.
3. Elegir únicamente el siguiente paso.
4. Proponer un bloque de foco apropiado; no imponer siempre Pomodoro de 25 minutos.
5. Cuando Mati diga `terminé`, marcar el paso como completado.
6. Ofrecer/activar una pausa corta si corresponde.
7. Programar el regreso mediante n8n.
8. Al volver, enviar solo el siguiente paso y contexto mínimo.
9. Repetir hasta terminar.
10. Cerrar con resumen breve y registrar resultado.

## Diseño para reducir fricción
- Una acción visible por vez.
- Pasos idealmente de 2–20 minutos cuando la tarea permita dividirse así.
- El primer paso debe ser especialmente fácil de iniciar.
- Evitar listas enormes mientras se está ejecutando.
- Separar `planificar` de `hacer`.
- Si hay bloqueo, reducir nuevamente el tamaño del paso.

## Estado en PostgreSQL
Una sesión de foco debería registrar como mínimo:
- session_id
- objective
- task_id / step_id
- step_text
- status: pending | active | done | skipped
- started_at / completed_at
- planned_focus_minutes
- break_minutes
- next_check_at
- channel

## Interacción Telegram futura
Ejemplo:
Mati: “Tengo que terminar la presentación hoy. Partámosla.”
MatiOS: “Primero: abrí el deck y escribí los 3 mensajes que querés que queden claros. Avisame `terminé`.”
Mati: “Terminé.”
MatiOS: “Bien. Descansá 5 min. Te escribo cuando volvemos.”

n8n espera 5 minutos y dispara:
MatiOS: “Volvemos. Siguiente paso: armá únicamente la slide 1 con el mensaje principal.”

## Principio
El objetivo no es recordar tareas; es disminuir la distancia entre intención y acción.