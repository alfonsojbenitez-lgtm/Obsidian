---
name: weekly-review
description: Realiza la revisión semanal del vault de Obsidian procesando el inbox, revisando proyectos activos y preparando la semana siguiente. Úsalo los viernes o el fin de semana, o cuando el usuario diga "revisión semanal", "procesar inbox", "cerrar la semana" o "preparar la semana".
---

# Weekly Review

Guía la revisión semanal completa: procesa el inbox, actualiza proyectos y prepara la semana siguiente.

## Flujo de trabajo

### 1. Leer el estado actual
- Lista el contenido de `inbox/`
- Lee la nota semanal actual en `notas-diarias/YYYY-WNN.md`
- Lista proyectos activos en `proyectos/`

### 2. Procesar inbox
Para cada nota en `inbox/`:
- ¿Es accionable? → mueve a `proyectos/` o añade tarea al proyecto correspondiente
- ¿Es referencia? → mueve a `fuentes/` o `búsquedas/`
- ¿Es sobre una persona? → añade a `personal/[Contacto].md`
- ¿Es un análisis? → mueve a `estadisticas/`
- ¿No sirve? → indicar al usuario que la elimine

### 3. Revisar proyectos activos
Para cada proyecto en `proyectos/`:
- ¿Tiene tareas pendientes sin completar?
- ¿Lleva más de 7 días sin actualizar?
- ¿Hay bloqueos?

Especial atención a:
- [[GALIAT - Huella hídrica]] — proyecto estadístico activo
- Emails pendientes de acción en `proyectos/GALIAT/emails/`

### 4. Crear nota semanal
Si no existe `notas-diarias/YYYY-WNN.md`:
- Crearla con la plantilla `Nota semanal`
- Rellenar el estado de proyectos
- Añadir agenda de la semana siguiente desde Google Calendar

### 5. Preparar semana siguiente
- Listar las 3 prioridades principales
- Identificar tareas arrastradas de la semana anterior
- Sugerir qué proyectos necesitan atención urgente

## Formato de salida al usuario

```
## Revisión semanal — Semana WNN

### Inbox procesado
- [N] notas movidas a su destino
- [N] notas pendientes de decisión

### Proyectos
- ✅ GALIAT Huella hídrica — [estado]
- ⚠️ [Proyecto estancado]

### Prioridades semana siguiente
1.
2.
3.
```

## Reglas
- No eliminar notas — solo indicar al usuario cuáles puede eliminar
- Si hay correos en `proyectos/GALIAT/emails/` con tareas `[ ]` sin completar, destacarlos
- La revisión no debe tardar más de 10 minutos — ser conciso
