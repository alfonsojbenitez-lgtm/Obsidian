---
name: project-status
description: Revisa el estado de todos los proyectos activos del vault y genera un informe de situación. Úsalo cuando el usuario quiera saber en qué punto está cada proyecto, qué está bloqueado o cuáles necesitan atención.
---

# Project Status — Estado de proyectos

Genera un informe de situación de todos los proyectos activos.

## Pasos

1. **Listar proyectos**
   - `proyectos/GALIAT/` — ensayo clínico NCT02391701
   - `proyectos/SERGAS/` — trabajo clínico
   - `proyectos/IA/` — investigación IA
   - Cualquier `.md` en `proyectos/` con `status: activo` en frontmatter

2. **Para cada proyecto, leer**:
   - Nota principal del proyecto (`GALIAT.md`, `SERGAS.md`, `IA.md`)
   - Buscar `- [ ]` (tareas pendientes) y `- [x]` (completadas)
   - Identificar la fecha de última modificación
   - Detectar bloqueos: tareas con `#bloqueado` o menciones a "esperando" / "pendiente de"

3. **Revisar análisis estadísticos** en `estadisticas/`
   - Listar análisis vinculados a cada proyecto
   - Indicar si están en progreso o completados

4. **Calcular indicadores**:
   - % completado = tareas cerradas / (abiertas + cerradas)
   - Días sin actividad = hoy − fecha última modificación

5. **Presentar informe**

## Formato de salida

```
## Estado de proyectos — [fecha]

### GALIAT
**Estado:** [Activo / En pausa / Completado]
**Progreso:** [N tareas cerradas / N total] ([%]%)
**Última actividad:** [N días]
**Próximo paso:** [acción concreta]
**Bloqueos:** [si los hay]
**Análisis vinculados:** [[análisis 1]], [[análisis 2]]

---

### SERGAS
[mismo formato]

---

### IA
[mismo formato]

---

## Resumen ejecutivo
- Proyecto más activo: [nombre]
- Proyecto más estancado: [nombre] ([N] días sin actividad)
- Total tareas pendientes: [N]
- Requieren atención inmediata: [lista]
```

## Reglas

- No modificar ningún archivo
- Si un proyecto lleva más de 14 días sin actividad, marcarlo como "⚠ estancado"
- Incluir enlace wikilink a cada nota de proyecto en el informe
- Ordenar proyectos por urgencia (más bloqueado o más tiempo sin actividad primero)
- Máximo 500 palabras en el informe para no saturar el contexto
