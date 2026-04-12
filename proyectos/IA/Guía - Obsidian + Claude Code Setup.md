---
title: "Guía de configuración: Obsidian + Claude Code"
tags:
  - IA
  - obsidian
  - claude-code
  - configuración
  - guía
created: 2026-04-04
---

# Guía de configuración: Obsidian + Claude Code

> [!abstract] Objetivo
> Configurar un vault de Obsidian como segundo cerebro clínico-investigador, integrado con Claude Code como asistente de IA, con backups automáticos, sincronización en la nube y skills especializadas.

---

## Fase 1 — Prerequisitos

### 1.1 Software necesario

Instalar antes de empezar:

- **Obsidian** — descargar desde obsidian.md
- **Claude Code** — CLI de Anthropic (`npm install -g @anthropic-ai/claude`)
- **Git** — git-scm.com (necesario para obsidian-git y Claude Code)
- **VS Code** (opcional pero recomendado como editor externo)

### 1.2 Crear el vault

1. Abrir Obsidian → **Crear nuevo vault**
2. Elegir carpeta raíz (ej: `C:/Users/[usuario]/Obsidian`)
3. Abrir la carpeta del vault en VS Code o terminal

---

## Fase 2 — Estructura de carpetas

Crear manualmente o con Claude Code las siguientes carpetas:

```
vault/
├── inbox/          → Captura sin procesar (revisar semanalmente)
├── notas-diarias/  → Daily notes, braindumps, tareas del día
├── proyectos/      → Un .md por proyecto activo
│   ├── GALIAT/
│   ├── SERGAS/
│   └── IA/
├── estadisticas/   → Análisis estadísticos (R, Stata)
├── búsquedas/      → Literatura científica y búsquedas
├── fuentes/        → PDFs, cheatsheets, referencias
├── personal/       → Notas de contactos
└── plantillas/     → Templates reutilizables
```

---

## Fase 3 — Plugins de Obsidian

### 3.1 Activar plugins del núcleo

En **Configuración → Plugins del núcleo**, activar:
- Templates
- Daily notes
- Backlinks
- Graph view
- Outline

### 3.2 Instalar plugins de la comunidad

**Configuración → Plugins de la comunidad → Explorar**

| Plugin | ID para buscar | Para qué |
|--------|---------------|----------|
| Dataview | `dataview` | Consultas dinámicas sobre notas |
| Templater | `templater-obsidian` | Templates con lógica y fechas dinámicas |
| Periodic Notes | `periodic-notes` | Notas diarias/semanales/mensuales |
| Calendar | `calendar` | Vista de calendario en sidebar |
| QuickAdd | `quickadd` | Captura rápida de notas |
| Obsidian Git | `obsidian-git` | Backup automático con Git |
| Remotely Save | `remotely-save` | Sincronización OneDrive/Google Drive |
| Kanban | `obsidian-kanban` | Tableros de proyecto |
| Linter | `obsidian-linter` | Formateo automático de notas |
| Excalidraw | `obsidian-excalidraw-plugin` | Diagramas y bocetos |
| Text Generator | `obsidian-textgenerator-plugin` | IA directamente en Obsidian |
| Spaced Repetition | `obsidian-spaced-repetition` | Flashcards para estudio |
| Table Editor | `table-editor-obsidian` | Edición cómoda de tablas |

---

## Fase 4 — Configuración de plugins

### 4.1 Obsidian Git

Editar `.obsidian/plugins/obsidian-git/data.json`:

```json
{
  "commitMessage": "vault: backup automático {{date}}",
  "commitDateFormat": "YYYY-MM-DD HH:mm:ss",
  "autoSaveInterval": 10,
  "autoBackupAfterFileChange": true,
  "syncMethod": "rebase",
  "showStatusBar": true,
  "disablePopupsForNoChanges": true
}
```

Inicializar el repositorio Git en la carpeta del vault:

```bash
cd [ruta-vault]
git config user.email "[email]"
git config user.name "[nombre]"
git init
git add .gitignore
git commit -m "chore: inicializar vault"
git add .
git commit -m "feat: commit inicial del vault"
```

### 4.2 .gitignore

Crear `.gitignore` en la raíz del vault:

```gitignore
# Estado local de Obsidian
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache

# Plugins con secretos
.obsidian/plugins/remotely-save/data.json
.obsidian/plugins/obsidian-textgenerator-plugin/data.json

# Sistema
.DS_Store
Thumbs.db
desktop.ini
*.tmp

# Claude (conversaciones locales)
.claude/projects/
```

### 4.3 Obsidian Linter

Editar `.obsidian/plugins/obsidian-linter/data.json`, configurar:

```json
{
  "lintOnSave": true,
  "suppressMessageWhenNoChange": true,
  "displayChanged": false,
  "foldersToIgnore": ["plantillas", ".obsidian", ".claude"],
  "ruleConfigs": {
    "trailing-spaces": { "enabled": true },
    "consecutive-blank-lines": { "enabled": true },
    "heading-blank-lines": { "enabled": true, "bottom": true },
    "space-after-list-markers": { "enabled": true },
    "remove-multiple-spaces": { "enabled": true },
    "remove-link-spacing": { "enabled": true }
  }
}
```

### 4.4 Kanban

Editar `.obsidian/plugins/obsidian-kanban/data.json`:

```json
{
  "date-picker-week-start": 1,
  "date-format": "YYYY-MM-DD",
  "date-display-format": "DD/MM/YYYY",
  "show-checkboxes": true,
  "new-note-folder": "inbox",
  "new-note-template": "plantillas/Proyecto.md",
  "lane-width": 280,
  "show-relative-date": true
}
```

### 4.5 Text Generator (IA en Obsidian)

1. Instalar el plugin
2. Ir a **Configuración → Text Generator → LLM Provider → Anthropic**
3. Pegar la API key de Anthropic (desde console.anthropic.com)
4. El plugin guarda la key en almacenamiento seguro (no en `data.json`)

Editar `data.json` para ajustar modelo y rutas:

```json
{
  "selectedProvider": "Anthropic Legacy (Custom)",
  "stream": true,
  "promptsPath": "plantillas",
  "LLMProviderOptions": {
    "Anthropic Legacy (Custom)": {
      "model": "claude-sonnet-4-6",
      "streamable": true,
      "endpoint": "https://api.anthropic.com/v1/messages"
    }
  }
}
```

### 4.6 Remotely Save (sincronización)

Configurar desde la UI de Obsidian:
- **Configuración → Remotely Save**
- Seleccionar proveedor: **OneDrive (personal)** o Google Drive
- Autenticar con la cuenta correspondiente
- Activar sincronización automática

> [!warning] No editar `data.json` de Remotely Save — contiene tokens cifrados

### 4.7 Markdownlint (VS Code)

Crear `.markdownlint.json` en la raíz del vault:

```json
{
  "MD041": false,
  "MD013": false,
  "MD025": false,
  "MD034": false,
  "MD033": false
}
```

---

## Fase 5 — Configuración visual

### 5.1 Graph view

Editar `.obsidian/graph.json` para asignar colores por carpeta:

```json
{
  "colorGroups": [
    { "query": "path:proyectos/GALIAT", "color": { "a": 1, "rgb": 14408667 } },
    { "query": "path:proyectos/SERGAS", "color": { "a": 1, "rgb": 16744448 } },
    { "query": "path:proyectos/IA",     "color": { "a": 1, "rgb": 9699539 } },
    { "query": "path:estadisticas",     "color": { "a": 1, "rgb": 1681177 } },
    { "query": "path:personal",         "color": { "a": 1, "rgb": 16744272 } },
    { "query": "path:notas-diarias",    "color": { "a": 1, "rgb": 8947848 } },
    { "query": "path:inbox",            "color": { "a": 1, "rgb": 16711680 } }
  ],
  "showArrow": true,
  "showTags": true,
  "showOrphans": false
}
```

### 5.2 CSS personalizado

Crear `.obsidian/snippets/vault-custom.css` y activar en **Apariencia → Fragmentos CSS**:

```css
/* Colores de tags */
.tag[href="#GALIAT"]      { background-color: #1a6bb5; }
.tag[href="#pendiente"]   { background-color: #c0392b; }
.tag[href="#estadística"] { background-color: #27ae60; }
.tag[href="#reunión"]     { background-color: #e67e22; }

/* Dashboard a ancho completo */
.markdown-preview-view.mod-cm6 { max-width: 100% !important; }

/* Tareas completadas en tono suave */
.task-list-item.is-checked { opacity: 0.5; }
```

### 5.3 Atajos de teclado

Editar `.obsidian/hotkeys.json`:

```json
{
  "quickadd:run-quickadd": [{ "modifiers": ["Alt"], "key": "Q" }],
  "daily-notes": [{ "modifiers": ["Alt"], "key": "D" }],
  "periodic-notes:open-weekly-note": [{ "modifiers": ["Alt"], "key": "W" }],
  "insert-template": [{ "modifiers": ["Alt"], "key": "P" }]
}
```

---

## Fase 6 — Claude Code

### 6.1 Inicializar Claude Code en el vault

```bash
cd [ruta-vault]
claude
```

### 6.2 Crear CLAUDE.md

Crear `CLAUDE.md` en la raíz del vault con:

- Idioma de trabajo (español)
- Tabla de estructura de carpetas
- Tabla de plantillas disponibles
- Tabla de skills disponibles
- Reglas para notas `.md`, `.canvas`, `.base`
- Reglas para el CLI de Obsidian
- Comportamiento general (no duplicar notas, usar wikilinks, etc.)

> [!tip] Ver el archivo `CLAUDE.md` de este vault como plantilla de referencia

### 6.3 Configurar MCP servers

Ejecutar en terminal (requiere autenticación):

```bash
# Gmail
claude mcp add --transport http gmail "https://mcp.claude.ai/mcp/gmail"

# Google Calendar
claude mcp add --transport http google-calendar "https://mcp.claude.ai/mcp/google-calendar"

# PubMed
claude mcp add --transport http pubmed "https://mcp.claude.ai/mcp/pubmed"
```

> [!note] Los MCP servers de Claude.ai requieren autenticación con cuenta de Anthropic

### 6.4 Instalar skills

Crear la carpeta `.claude/skills/` y dentro una subcarpeta por skill con su `SKILL.md`.

**Skills recomendadas para entorno clínico-investigador:**

| Skill | Descripción |
|-------|-------------|
| `obsidian-markdown` | Reglas de Obsidian Flavored Markdown |
| `obsidian-cli` | Comandos CLI de Obsidian |
| `json-canvas` | Creación de Canvas |
| `obsidian-bases` | Creación de Bases |
| `context` | Carga contexto del vault al inicio de sesión |
| `today` | Crea/actualiza la nota diaria |
| `spark` | Descubre patrones en el vault |
| `weekly-review` | Revisión semanal + procesado inbox |
| `gmail-capture` | Captura correos de Gmail al vault |
| `calendar-capture` | Captura eventos del calendario |
| `pubmed-search` | Busca en PubMed y guarda referencias |
| `meeting-note` | Nota de reunión rápida |
| `r-workflow` | Asistente R Software / tidyverse |
| `stata-assistant` | Asistente Stata v16 |
| `daily-brief` | Resumen matutino del día |
| `project-status` | Informe de estado de proyectos |
| `skill-creator` | Crea nuevas skills |

Cada `SKILL.md` sigue esta estructura:

```markdown
---
name: nombre-en-kebab-case
description: Descripción clara con triggers para carga automática
---

# Título

## Pasos / Flujo de trabajo
[contenido]

## Reglas
[restricciones]
```

---

## Fase 7 — Plantillas

Crear en `plantillas/` al menos:

- `Nota diaria.md` — estructura del daily note
- `Nota diaria (Templater).md` — con fechas dinámicas `2026-04-04`
- `Proyecto.md` — ficha de proyecto con status, tareas y próximos pasos
- `Contacto.md` — perfil de persona con rol, email, proyectos relacionados
- `Investigación.md` — búsqueda activa con hipótesis y fuentes
- `Fuente.md` — referencia bibliográfica con DOI y resumen
- `Análisis estadístico.md` — análisis con software, datos, resultados
- `Nota semanal.md` — revisión semanal
- `Nota mensual.md` — revisión mensual

---

## Fase 8 — Dashboard

Crear `Dashboard.md` en la raíz con consultas Dataview:

````markdown
```dataview
TASK FROM "proyectos" WHERE !completed LIMIT 10
```

```dataview
TABLE status, next-step FROM "proyectos" WHERE status = "activo"
```
````

---

## Verificación final

Comprobar que todo funciona:

- [ ] Obsidian abre el vault correctamente
- [ ] Los plugins aparecen activos en **Configuración → Plugins de la comunidad**
- [ ] `git status` en el vault devuelve estado limpio
- [ ] Obsidian-git hace un commit de prueba (editar cualquier nota y esperar 10 min)
- [ ] Remotely Save sincroniza correctamente (icono en status bar)
- [ ] Text Generator responde al invocar con `Ctrl+J` (o el atajo configurado)
- [ ] Claude Code reconoce el `CLAUDE.md` al abrir sesión en el vault
- [ ] Una skill como `/context` funciona al invocarla

---

## Notas de mantenimiento

- **Actualizar plugins**: Obsidian → Configuración → Plugins de la comunidad → Buscar actualizaciones
- **Actualizar skills**: editar directamente los archivos `.claude/skills/*/SKILL.md`
- **Renovar API key**: Obsidian → Text Generator → Provider (si la key expira o se revoca)
- **Añadir remote Git**: `git remote add origin <url>` para backup externo en GitHub/GitLab

## Referencias

- [[CLAUDE.md]] — configuración activa del vault
- [[proyectos/IA/IA]] — proyecto de aplicación de IA en el laboratorio
- Documentación Obsidian: help.obsidian.md
- Documentación Claude Code: docs.anthropic.com/claude-code
