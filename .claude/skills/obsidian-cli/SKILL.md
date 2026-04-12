---
name: obsidian-cli
description: Interactúa con vaults de Obsidian usando el CLI de Obsidian para leer, crear, buscar y gestionar notas, tareas, propiedades y más. También soporta desarrollo de plugins y temas con comandos para recargar plugins, ejecutar JavaScript, capturar errores, tomar capturas de pantalla e inspeccionar el DOM.
---

# Obsidian CLI

El CLI de Obsidian permite interactuar con instancias de Obsidian en ejecución desde la línea de comandos.

## Sintaxis general

- Los parámetros usan notación `=` con valores entre comillas para espacios
- Las flags son interruptores booleanos sin valor
- Los saltos de línea usan `\n` y las tabulaciones usan `\t`

```bash
obsidian <comando> [parámetros] [flags]
```

## Apuntando a archivos

```bash
# Por nombre (resolución estilo wikilink)
obsidian read file="Mi Nota"

# Por ruta relativa al vault
obsidian read path="carpeta/subcarpeta/nota.md"
```

## Apuntando a un vault específico

```bash
# El vault debe ser el primer parámetro
obsidian read vault="Mi Vault" file="Nota"

# Sin vault: usa el vault enfocado más recientemente
```

## Operaciones principales

### Lectura y escritura

```bash
obsidian read file="Nombre de nota"
obsidian create file="Nueva nota" content="Contenido inicial"
obsidian append file="Nota existente" content="Texto adicional\n"
obsidian overwrite file="Nota" content="Contenido completo nuevo"
```

### Búsqueda

```bash
obsidian search query="término de búsqueda"
obsidian search query="tag:#proyecto" limit=20
obsidian search query="path:proyectos/ status:activo"
```

### Notas diarias

```bash
obsidian daily:open
obsidian daily:append content="- Tarea completada\n"
obsidian daily:read
```

### Propiedades (frontmatter)

```bash
obsidian property:get file="Nota" key="status"
obsidian property:set file="Nota" key="status" value="completado"
obsidian property:list file="Nota"
```

### Tareas

```bash
obsidian tasks:list file="Nota"
obsidian tasks:complete file="Nota" line=5
obsidian tasks:search query="pendiente"
```

### Tags

```bash
obsidian tags:list file="Nota"
obsidian tags:search tag="proyecto"
```

### Backlinks

```bash
obsidian backlinks:list file="Nota"
```

## Desarrollo de plugins

```bash
# Recargar un plugin
obsidian plugin:reload id=nombre-del-plugin

# Ver errores de consola
obsidian dev:errors

# Ejecutar JavaScript
obsidian dev:eval code="app.vault.getName()"

# Captura de pantalla
obsidian dev:screenshot path="captura.png"

# Inspeccionar DOM
obsidian dev:dom selector=".workspace-leaf"

# Emulación móvil
obsidian dev:mobile toggle
```

## Ayuda

```bash
# Ver todos los comandos disponibles
obsidian help

# Ayuda de un comando específico
obsidian help read
```

## Referencias

- [Repositorio Obsidian CLI](https://github.com/obsidian-cli/obsidian-cli)
- [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)
