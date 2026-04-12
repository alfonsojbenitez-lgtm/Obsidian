---
name: skill-creator
description: Crea nuevas skills de Claude Code para el vault de Obsidian. El usuario describe lo que quiere que haga la skill y este skill genera el archivo SKILL.md con la estructura, frontmatter y contenido correctos, guardándolo en .claude/skills/.
---

# Crear una nueva skill

Cuando el usuario invoque `/skill-creator`, ayúdale a crear una skill bien estructurada para su vault.

## Proceso conversacional

1. **Entender el objetivo**
   - Si el usuario ya describió la skill, úsalo como base
   - Si la descripción es vaga, haz máximo 2 preguntas de clarificación:
     - ¿Qué desencadena esta skill? (¿qué hace el usuario para invocarla?)
     - ¿Qué debe producir? (¿modifica archivos, responde, crea algo?)

2. **Determinar el tipo de skill**
   - **Referencia**: conocimiento que Claude aplica pasivamente (guías de estilo, convenciones)
   - **Tarea**: acción específica que el usuario invoca directamente con `/nombre`

3. **Generar el SKILL.md**

## Estructura requerida de SKILL.md

```markdown
---
name: nombre-en-kebab-case
description: [Una oración que describe CUÁNDO usarla y QUÉ hace. Incluye triggers clave para que Claude la cargue automáticamente cuando sea relevante.]
---

# [Título descriptivo]

[Contexto de 1-2 oraciones: por qué existe esta skill]

## [Sección principal]

[Contenido de la skill...]
```

## Reglas de calidad

**Frontmatter:**
- `name`: kebab-case, sin espacios, descriptivo
- `description`: empieza por el trigger ("Úsalo cuando...", "Crea...", "Gestiona..."), incluye palabras clave que activarán la carga automática

**Contenido:**
- Empieza con el flujo de trabajo o los pasos principales
- Usa ejemplos concretos con bloques de código cuando aplique
- Sé específico sobre rutas del vault (`notas-diarias/`, `proyectos/`)
- Incluye restricciones explícitas (qué NO hacer)
- Mantén bajo 300 líneas — las skills concisas se siguen mejor

**Lo que evitar:**
- Instrucciones genéricas que aplican a todo
- Pasos obvios que Claude haría de todas formas
- Repetir información que ya está en CLAUDE.md

## Guardar la skill

Después de generar el contenido:
1. Determina el nombre del directorio: `.claude/skills/{name}/`
2. Escribe el archivo en: `.claude/skills/{name}/SKILL.md`
3. Confirma al usuario la ruta creada y cómo invocarla (`/{name}`)

## Ejemplo de skill bien escrita

```markdown
---
name: nota-reunion
description: Crea una nota estructurada para reuniones en proyectos/reuniones/. Úsalo cuando el usuario mencione una reunión, llamada, o quiera tomar notas de una conversación.
---

# Crear nota de reunión

## Pasos
1. Pregunta: nombre del proyecto, participantes, fecha
2. Crea el archivo en `proyectos/reuniones/YYYY-MM-DD-{proyecto}.md`
3. Usa la plantilla siguiente

## Plantilla
[...]
```
