# Coaching remoto: WhatsApp para actuar, web para ver

## Decisión

La experiencia cotidiana de MatiOS será conversacional. El alumno pregunta, ejecuta y registra por WhatsApp; la web funciona como apoyo visual para fichas, planificación, historial y evolución. Ambos canales consumen la misma fuente de datos.

## Componentes

- **Router:** detecta intención y activa el mínimo de skills.
- **Client Coaching:** mantiene el estado conversacional, convierte mensajes en eventos y coordina aprobaciones.
- **Training:** arma rutinas desde fichas canónicas, adapta sesiones y analiza progresión.
- **Nutrition:** arma menú, meal prep y lista de compras desde recetas e inventario.
- **Health/Mobility:** aporta restricciones y reglas de escalamiento sin diagnosticar.
- **Revisor profesional:** aprueba nuevas versiones y cambios materiales.
- **PostgreSQL:** conserva perfiles, versiones, eventos, series, comidas, revisiones y progreso.
- **Git:** conserva conocimiento curado, esquemas, recetas, ejercicios y reglas.
- **Índice vectorial:** ayuda a recuperar conocimiento de Git; no reemplaza la fuente de verdad.

## Regla de escritura única

Un mensaje genera un evento canónico. WhatsApp confirma el registro y la web proyecta ese evento; no se crean copias independientes por canal.

```text
“Hice 60x8, 65x8, 70x8 y 75x7; última RPE 9”
    -> parser conversacional
    -> cuatro registros de serie
    -> resumen por WhatsApp
    -> historial y gráfico web
```

Guardar también el texto original, la interpretación y el nivel de confianza para corregir errores sin perder trazabilidad.

## Separación entre conocimiento e histórico

Git contiene qué significa un ejercicio, cómo se prescribe, cómo se arma una rutina y cómo se calcula una compra. PostgreSQL contiene qué plan recibió cada alumno, qué hizo, qué comió, quién aprobó y qué cambió con el tiempo.

## Aprobación

La IA puede crear borradores y ejecutar ajustes previstos. Una rutina o plan alimentario individual nuevo no se entrega hasta estar `approved`. Los cambios materiales crean otra versión; no se sobrescribe la anterior.

## Entrega inicial

1. Onboarding y consentimiento.
2. Propuesta de rutina y alimentación.
3. Revisión profesional.
4. Plan semanal aprobado.
5. Sesión guiada y registro por WhatsApp.
6. Resumen web.
7. Check-in y nueva propuesta cuando corresponda.

## Fuera del primer MVP

Agenda, cobros, facturación, comunidad y aplicación nativa pueden agregarse después. El primer producto debe demostrar acompañamiento, adherencia y decisiones mejores con menos fricción.
