---
name: meeting-note
description: Crea notas de reunión estructuradas en Obsidian a partir del calendario o descripción del usuario. Úsalo cuando el usuario mencione una reunión, llamada, videoconferencia, o quiera preparar o documentar una reunión. Triggers: "nota de reunión", "reunión con", "preparar reunión", "documentar reunión", "llamada con".
---

# Meeting Note

Crea notas de reunión rápidas vinculadas al calendario y al proyecto correspondiente.

## Flujo de trabajo

1. **Obtener datos de la reunión**
   - Si hay evento en Google Calendar → leer con `gcal_list_events` (q: nombre reunión)
   - Si el usuario describe la reunión → preguntar: fecha, participantes, proyecto

2. **Identificar destino**
   - Reunión de GALIAT → `proyectos/GALIAT/reuniones/`
   - Reunión sin proyecto claro → `inbox/`

3. **Verificar duplicados** con Grep por fecha y participantes

4. **Crear la nota** con el formato siguiente

5. **Actualizar el proyecto** — añadir referencia a la reunión en la nota del proyecto correspondiente

## Formato de nota

Nombre: `YYYY-MM-DD - Reunión [tema o participantes].md`

```markdown
---
title: "Reunión [tema]"
tags:
  - reunión
  - [proyecto]
fecha: YYYY-MM-DD
hora: HH:MM–HH:MM
lugar: "[presencial / videollamada / teléfono]"
proyecto: "[[Proyecto]]"
participantes:
  - "[[Contacto1]]"
  - "[[Contacto2]]"
---

# Reunión — [Tema]

**Fecha:** DD de mes de YYYY, HH:MM–HH:MM
**Lugar:** [ubicación o plataforma]
**Participantes:** [[Contacto1]] · [[Contacto2]]

---

## Orden del día

- [ ] 
- [ ] 

## Notas

%%Tomar durante la reunión%%

## Acuerdos y decisiones

- 

## Acciones

- [ ] [responsable] — [acción] — [fecha límite]

## Próxima reunión

%%Fecha y temas pendientes%%

## Relacionado

%%Wikilinks a análisis, correos o documentos tratados%%
```

## Reuniones frecuentes del vault

| Tipo de reunión | Destino | Participantes habituales |
|----------------|---------|------------------------|
| GALIAT estadística | `proyectos/GALIAT/reuniones/` | [[Dra. Mar Calvo]] · [[Francisco Gude]] |
| GALIAT huella hídrica | `proyectos/GALIAT/reuniones/` | [[Dra. Mar Calvo]] |
| Equipo completo GALIAT | `proyectos/GALIAT/reuniones/` | [[Dra. Mar Calvo]] · [[Juan Sanchez]] · [[Francisco Gude]] · [[Rosaura Leis]] · [[Alfonso Nahum Benitez]] |

## Reglas

- Ignorar eventos de radioafición (DMR, BrandMeister, TeamCampa)
- Si la reunión tiene adjuntos mencionados → anotarlos en "Relacionado"
- Después de crear la nota, actualizar el proyecto padre con el wikilink a la reunión
- Si hay compromisos adquiridos → añadirlos también a `personal/[Contacto].md`
