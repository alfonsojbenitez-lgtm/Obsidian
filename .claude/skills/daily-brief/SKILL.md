---
name: daily-brief
description: Genera un resumen ejecutivo del día al inicio de la jornada. Úsalo por las mañanas para ver tareas pendientes, eventos del día y contexto de proyectos activos sin abrir cada nota individualmente.
---

# Daily Brief — Resumen de inicio de jornada

Genera un briefing conciso para empezar el día con foco.

## Pasos

1. **Leer la nota diaria de hoy** (`notas-diarias/YYYY-MM-DD.md`)
   - Si no existe, crearla desde `plantillas/Nota diaria.md`
   - Extraer tareas pendientes y notas del día anterior si las hay

2. **Revisar tareas pendientes del vault**
   - Grep por `- [ ]` en `proyectos/`, `inbox/`, `notas-diarias/` (últimos 7 días)
   - Agrupar por proyecto

3. **Consultar calendario** con `gcal_list_events`
   - Rango: hoy desde ahora hasta las 23:59
   - Ignorar eventos de radioafición
   - Mostrar: hora, título, participantes si los hay

4. **Revisar inbox/**
   - Contar notas sin procesar
   - Listar las 3 más recientes

5. **Presentar el brief**

## Formato de salida

```
## Brief del [día DD de mes] — [saludo según hora]

### Hoy en el calendario
- HH:MM — [evento]

### Tareas activas
**GALIAT**
- [ ] [tarea]

**SERGAS**
- [ ] [tarea]

**Sin proyecto**
- [ ] [tarea]

### Inbox ([N] notas)
- [[nota 1]]
- [[nota 2]]

### Foco sugerido
[Una sola acción más importante del día]
```

## Reglas

- Máximo 30 tareas totales — si hay más, mostrar solo las de proyectos activos
- No modificar ningún archivo durante el brief
- Si no hay nota diaria, crearla silenciosamente antes de continuar
- El "foco sugerido" es la tarea más urgente o bloqueante identificada
