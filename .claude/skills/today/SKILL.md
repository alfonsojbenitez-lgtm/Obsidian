---
name: today
description: Crea o actualiza la nota diaria de hoy en Obsidian. Lee el contexto reciente del vault, notas de ayer y proyectos activos para generar un punto de partida enfocado para el día. Úsalo al comenzar el día o para revisar el progreso.
---

# Nota diaria de hoy

Cuando el usuario invoque `/today`, genera o actualiza la nota diaria de hoy.

## Pasos

1. **Obtener fecha de hoy** en formato `YYYY-MM-DD`

2. **Leer contexto previo**
   - Busca la nota diaria de ayer o la más reciente en `notas-diarias/`
   - Extrae tareas no completadas (`- [ ]`) de los últimos 2-3 días
   - Lee proyectos activos en `proyectos/` para ver próximos pasos

3. **Verificar nota de hoy**
   - Si ya existe `notas-diarias/YYYY-MM-DD.md`, léela y actualízala
   - Si no existe, créala con la plantilla siguiente

4. **Crear/actualizar nota**

## Plantilla de nota diaria

```markdown
---
date: {{fecha}}
tags: [diario]
---

# {{fecha-legible}}

## Intención del día
<!-- ¿Cuál es el resultado más importante de hoy? -->

## Tareas

### Arrastradas
{{tareas-no-completadas-de-ayer}}

### De hoy
- [ ] 

## Proyectos en marcha
{{resumen-una-linea-por-proyecto-activo}}

## Notas y reflexiones

## Registro
<!-- Añade aquí durante el día -->
```

## Comportamiento

- **Si la nota ya existe**: Añade las tareas arrastradas al bloque "Arrastradas" si no están ya, sin sobrescribir lo que el usuario haya escrito
- **Si la nota no existe**: Crea el archivo completo con la plantilla rellena
- **Tareas arrastradas**: Solo incluye las `- [ ]` que no fueron completadas (`- [x]`), máximo 5
- **Proyectos**: Lista solo los proyectos con actividad en los últimos 7 días

## Ruta de archivo

Las notas diarias van en: `notas-diarias/YYYY-MM-DD.md`

## Al finalizar

Informa al usuario:
- Si la nota fue creada o actualizada
- Cuántas tareas arrastradas se encontraron
- Cualquier proyecto estancado que requiera atención
