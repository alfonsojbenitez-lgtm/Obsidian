---
name: context
description: Carga el contexto completo del vault de Obsidian al inicio de una sesión. Lee proyectos activos, notas recientes, prioridades actuales y el estado general del vault para establecer una base antes de otras tareas.
disable-model-invocation: false
---

# Cargar contexto del vault

Cuando el usuario invoque `/context`, realiza los siguientes pasos para construir una imagen completa del estado actual del vault.

## Pasos

1. **Leer estructura del vault**
   - Lista el contenido de las carpetas principales (`proyectos/`, `notas-diarias/`)
   - Identifica subcarpetas y su propósito

2. **Notas diarias recientes**
   - Lee las últimas 3-5 notas diarias de `notas-diarias/`
   - Extrae: tareas pendientes, ideas mencionadas, patrones recurrentes

3. **Proyectos activos**
   - Lista las notas de `proyectos/`
   - Para cada proyecto activo, lee su estado, próximos pasos y bloqueos

4. **Sintetizar contexto**
   - Resume qué está en marcha
   - Lista tareas urgentes o vencidas
   - Identifica hilos de pensamiento sin resolver
   - Señala proyectos estancados o sin actualizar

## Formato de salida

Presenta el contexto de forma concisa:

```
## Estado del vault — [fecha]

### Proyectos activos
- **[Proyecto]**: [estado en una línea] — próximo paso: [acción]

### Tareas pendientes
- [ ] [tarea] (de: [[nota origen]])

### Hilos abiertos
- [tema o idea sin resolver]

### Último registro: [fecha de la nota diaria más reciente]
```

## Notas de uso

- No modifiques ningún archivo durante `/context`
- Si no hay notas diarias recientes (>7 días), menciona que el vault parece inactivo
- Mantén el resumen bajo 300 palabras para no saturar el contexto
- Este skill prepara el terreno para `/today` y `/spark`
