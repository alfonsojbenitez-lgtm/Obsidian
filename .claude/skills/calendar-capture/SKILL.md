---
name: calendar-capture
description: Consulta Google Calendar y guarda eventos como notas en el vault de Obsidian. Úsalo cuando el usuario quiera ver su agenda, capturar reuniones, crear notas de reunión, revisar próximos eventos o sincronizar el calendario con el vault. Triggers: "qué tengo esta semana", "captura mis eventos", "nota de reunión", "agenda de", "próximos eventos", "reunión con".
---

# Calendar Capture

Consulta Google Calendar y convierte eventos en notas estructuradas en Obsidian.

## Calendarios disponibles

| ID | Nombre | Tipo |
|----|--------|------|
| `alfonsojbenitez@gmail.com` | Principal | owner |
| `en.spain#holiday@group.v.calendar.google.com` | Holidays in Spain | lector |
| `es.spain#holiday@group.v.calendar.google.com` | Festivos en España | lector |
| `concejosdeasturias@gmail.com` | ACTIVIDADES CAMPA TORRES TEAM (Radio Club) | lector |
| `ht3jlfaac5lfd6263ulfh4tql8@group.calendar.google.com` | Phases of the Moon | lector |

**Por defecto:** usar `primary` (calendario principal).

## Flujo de trabajo

1. **Entender qué necesita el usuario:**
   - ¿Consulta de agenda? → listar eventos del período
   - ¿Nota de reunión? → crear nota estructurada del evento
   - ¿Guardar agenda semanal? → crear nota de semana en `notas-diarias/`

2. **Consultar con `gcal_list_events`** — parámetros clave:
   - `timeMin` / `timeMax` en formato `YYYY-MM-DDTHH:MM:SS`
   - `timeZone`: siempre `Europe/Madrid`
   - `q`: búsqueda por texto libre (ej: "GALIAT", "reunión")

3. **Crear la nota** según el tipo:
   - Reunión de trabajo → `proyectos/[Proyecto]/reuniones/`
   - Evento personal → `notas-diarias/` o `inbox/`
   - Agenda semanal → `notas-diarias/Semana YYYY-WNN.md`

4. **Confirmar** al usuario qué se guardó y dónde

## Formato de nota de reunión

Nombre: `YYYY-MM-DD - [Título del evento].md`

```markdown
---
title: "[Título]"
tags:
  - reunión
  - [proyecto]
fecha: YYYY-MM-DD
hora: HH:MM–HH:MM
lugar: "[ubicación o videoconferencia]"
proyecto: "[[Proyecto]]"
---

# [Título del evento]

**Fecha:** DD de mes de YYYY, HH:MM–HH:MM
**Lugar / Enlace:** [ubicación]
**Participantes:** [[Contacto1]] · [[Contacto2]]

---

## Orden del día

%%Completar antes de la reunión%%
- 

## Notas

%%Tomar durante la reunión%%

## Acuerdos y decisiones

- 

## Acciones

- [ ] [responsable] — [acción] — [fecha límite]

## Relacionado

%%Wikilinks a proyectos, análisis o documentos relevantes%%
```

## Formato de agenda semanal

```markdown
---
title: "Agenda — Semana del DD de mes"
tags:
  - agenda
  - semanal
semana: YYYY-WNN
---

# Agenda — Semana del DD al DD de mes de YYYY

## Lunes DD
- HH:MM [Evento]

## Martes DD
...
```

## Reglas

- Zona horaria siempre `Europe/Madrid`
- Eventos de radio club (TeamCampa, BrandMeister, DMR, EA1, EB1, EC1, EG1, AB1, indicativos de radioafición) → **nunca guardar**, ignorar siempre
- Eventos sin título o internos → ignorar
- Si el evento menciona a alguien del equipo GALIAT, añadir wikilink automáticamente
- No duplicar notas: verificar con Grep antes de crear

## Proyectos y contextos conocidos

| Palabra clave en evento | Destino / Acción |
|------------------------|-----------------|
| GALIAT, HBA1c, huella hídrica | `proyectos/GALIAT/reuniones/` + tag GALIAT |
| Mar Calvo, Juan Sanchez, Gude, Leis | Añadir wikilink al contacto |
| Radio, DMR, BrandMeister, TeamCampa, EA1, EB1, EC1, EG1, Diploma, PEANUT, YSFCAMPA | Radioafición — **ignorar siempre** |

## Consultas frecuentes

```
# Agenda de la semana actual
timeMin: hoy 00:00:00 / timeMax: domingo 23:59:59

# Próximos 30 días
timeMin: hoy / timeMax: hoy + 30 días

# Buscar reunión específica
q: "GALIAT"

# Solo calendario principal
calendarId: primary
```
