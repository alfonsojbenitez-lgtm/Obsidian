---
title: Dashboard
tags:
  - sistema
  - dashboard
cssclasses:
  - dashboard
---

# Dashboard

%%Esta nota es el punto de entrada al vault. Ábrela cada mañana.%%

---

## Tareas pendientes

```dataview
TASK
WHERE !completed
AND file.folder != "plantillas"
AND file.folder != "inbox"
SORT file.mtime DESC
LIMIT 20
```

---

## Proyectos activos

```dataview
TABLE status, file.mtime AS "Última actualización"
FROM "proyectos"
WHERE status = "activo"
AND file.name != "README"
SORT file.mtime DESC
```

---

## Análisis estadísticos en curso

```dataview
TABLE proyecto, tipo, estado
FROM "estadisticas"
WHERE estado = "en-curso"
SORT file.mtime DESC
```

---

## Correos pendientes de acción

```dataview
TASK
WHERE !completed
AND file.folder = "proyectos/GALIAT/emails"
SORT file.mtime DESC
```

---

## Notas recientes

```dataview
TABLE file.mtime AS "Modificada"
WHERE file.folder != "plantillas"
AND file.name != "Dashboard"
AND file.name != "README"
SORT file.mtime DESC
LIMIT 10
```

---

## Inbox

```dataview
LIST
FROM "inbox"
WHERE file.name != "README"
SORT file.ctime ASC
```

---

## Búsquedas activas

```dataview
TABLE estado
FROM "búsquedas"
WHERE estado = "en-curso"
SORT file.mtime DESC
```

---

## Accesos rápidos

- [[notas-diarias/]] — notas diarias
- [[proyectos/GALIAT/GALIAT]] — ensayo clínico
- [[proyectos/GALIAT/GALIAT - Huella hídrica]] — subproyecto activo
- [[proyectos/GALIAT/GALIAT - Bibliografía]] — referencias GALIAT
- [[proyectos/SERGAS/SERGAS]] — trabajo CHUS / SERGAS
- [[proyectos/IA/IA]] — inteligencia artificial
- [[inbox/README]] — procesar inbox
