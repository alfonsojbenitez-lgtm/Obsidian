# CLAUDE.md — Vault de Obsidian

Este archivo configura el comportamiento de Claude Code en este vault. Aplica siempre que trabajes en este directorio.

## Contexto del vault

- Directorio raíz: `c:/Users/alfon/Obsidian/`
- Idioma de trabajo: español

### Estructura de carpetas

| Carpeta | Propósito |
| ------- | --------- |
| `inbox/` | Zona de descarga sin procesar — revisar semanalmente |
| `notas-diarias/` | Braindumps, reflexiones y tareas del día |
| `proyectos/` | Un archivo `.md` por proyecto activo |
| `búsquedas/` | Investigaciones, artículos, herramientas descubiertas |
| `personal/` | Notas sobre contactos y relaciones |
| `plantillas/` | Plantillas reutilizables (usar con Templater o core Templates) |
| `estadisticas/` | Análisis estadísticos, modelos y reportes vinculados a proyectos |
| `fuentes/` | Referencias estáticas, cheatsheets, documentación |
| `inversiones/` | Cartera de renta variable, análisis fundamental, dividendos y escenarios |

### Plantillas disponibles

- `plantillas/Nota diaria.md` — para notas diarias
- `plantillas/Proyecto.md` — para proyectos nuevos
- `plantillas/Contacto.md` — para personas en `personal/`
- `plantillas/Investigación.md` — para búsquedas activas
- `plantillas/Fuente.md` — para referencias en `fuentes/`
- `plantillas/Análisis estadístico.md` — para análisis en `estadisticas/`
- `plantillas/Subproyecto SERGAS.md` — para subproyectos en `proyectos/SERGAS/`
- `plantillas/Subproyecto IA.md` — para subproyectos en `proyectos/IA/`
- `plantillas/Ficha de empresa.md` — análisis fundamental de empresa en `inversiones/análisis/`
- `plantillas/Escenario de inversión.md` — análisis de escenario en `inversiones/escenarios/`
- `plantillas/Nota diaria (Templater).md` — nota diaria con fechas dinámicas
- `plantillas/Nota semanal.md` — revisión semanal
- `plantillas/Nota mensual.md` — revisión mensual

## Skills disponibles

Usa siempre los skills correspondientes al tipo de tarea. Están en `.claude/skills/`:

| Tarea | Skill a invocar |
| ----- | --------------- |
| Crear o editar notas `.md` | `/obsidian-markdown` |
| Crear o editar canvases `.canvas` | `/json-canvas` |
| Crear o editar bases `.base` | `/obsidian-bases` |
| Interactuar con Obsidian en ejecución | `/obsidian-cli` |
| Cargar contexto del vault al inicio de sesión | `/context` |
| Crear o actualizar la nota diaria | `/today` |
| Descubrir patrones en el vault | `/spark` |
| Crear nuevas skills | `/skill-creator` |
| Trabajar con R Software | `/r-workflow` |
| Capturar correos de Gmail al vault | `/gmail-capture` |
| Consultar agenda y capturar eventos | `/calendar-capture` |
| Gestionar sincronización con OneDrive | `/sync-status` |
| Revisión semanal y procesado de inbox | `/weekly-review` |
| Buscar en PubMed y guardar referencias | `/pubmed-search` |
| Crear nota de reunión rápida | `/meeting-note` |
| Resumen ejecutivo al inicio del día | `/daily-brief` |
| Ayuda con Stata v16 y análisis estadístico | `/stata-assistant` |
| Estado de todos los proyectos activos | `/project-status` |
| Gestionar y analizar la cartera de acciones | `/portfolio-tracker` |
| Análisis fundamental value y dividendos | `/stock-analysis` |
| Análisis de escenarios y sensibilidades | `/scenario-analysis` |
| Importar extracto CSV de Interactive Brokers | `/ib-import` |
| Calcular IRPF: plusvalías, dividendos, retenciones | `/irpf` |
| Revisión periódica de la cartera (mensual/trimestral) | `/portfolio-review` |

## Reglas para notas Markdown (`.md`)

- Usa siempre Obsidian Flavored Markdown, no Markdown estándar
- Incluye frontmatter YAML con al menos `title` y `tags`
- Enlaza notas relacionadas con wikilinks: `[[Nombre de nota]]`
- Usa embeds con `![[archivo]]` para transcluir contenido
- Usa callouts con `> [!tipo]` para resaltar información importante
- El resaltado es `==texto==`, los comentarios ocultos `%%texto%%`

## Reglas para Canvas (`.canvas`)

- Los archivos `.canvas` son JSON que sigue la especificación JSON Canvas 1.0
- Estructura raíz: `{ "nodes": [], "edges": [] }`
- Todos los nodos requieren: `id` (16 hex), `type`, `x`, `y`, `width`, `height`
- Tipos de nodo: `text`, `file`, `link`, `group`
- Los nodos de texto soportan Markdown y wikilinks en el campo `text`
- Los nodos de archivo usan rutas relativas al vault en el campo `file`
- Las aristas (`edges`) referencian IDs de nodos con `fromNode`/`toNode`
- Genera IDs únicos de 16 caracteres hexadecimales
- Deja al menos 50px de margen entre nodos

## Reglas para Bases (`.base`)

- Los archivos `.base` son YAML válido
- Definen vistas dinámicas sobre las notas del vault
- Estructura: `filters`, `formulas`, `properties`, `summaries`, `views`
- Tipos de vista: `table`, `cards`, `list`
- Las fórmulas usan expresiones con funciones: `if()`, `today()`, `now()`, `date()`
- Restar fechas da un objeto `Duration` — accede a `.days`, no uses directamente como número
- Verifica siempre que el YAML sea válido (sin errores de comillas ni sangría)

## Reglas para el CLI de Obsidian

- Usa el CLI solo cuando Obsidian esté en ejecución
- Sin vault especificado: opera en el vault enfocado más recientemente
- Referencia archivos por nombre (`file="Nombre"`) o ruta (`path="carpeta/nota.md"`)
- Para notas diarias: `obsidian daily:open`, `obsidian daily:append`, `obsidian daily:read`
- Para propiedades: `obsidian property:get/set file="Nota" key="campo"`
- Los saltos de línea en `content` usan `\n`

## Eficiencia de tokens

- Lee los archivos antes de escribir código o editar notas.
- Sé conciso en la salida; razona en profundidad internamente.
- Prefiere editar sobre reescribir archivos completos.
- No vuelvas a leer archivos ya leídos salvo que puedan haber cambiado.
- Verifica el resultado antes de declarar la tarea completada.
- Sin frases sycophánticas de apertura ni cierre ("¡Claro!", "¡Espero que ayude!", etc.).
- Soluciones simples y directas; sin sobre-ingeniería.
- Las instrucciones del usuario siempre prevalecen sobre este archivo.

## Comportamiento general

- Antes de crear una nota nueva, verifica si ya existe con `obsidian search` o `Grep`
- Cuando crees enlaces entre notas, usa wikilinks `[[]]`, nunca rutas Markdown estándar `[]()`
- Al trabajar con el vault por primera vez en una sesión, usa `/context` para cargar el estado actual
- No crees archivos de documentación extra (README, etc.) salvo que se pida explícitamente
