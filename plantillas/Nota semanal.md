---
title: Semana <% tp.date.now("YYYY-[W]WW") %>
tags:
  - semanal
  - revisión
semana: <% tp.date.now("YYYY-[W]WW") %>
del: <% tp.date.now("YYYY-MM-DD", 1 - tp.date.now("d")) %>
al: <% tp.date.now("YYYY-MM-DD", 7 - tp.date.now("d")) %>
---

# Semana <% tp.date.now("WW") %> — <% tp.date.now("MMMM [de] YYYY", 0, "es") %>

*<% tp.date.now("DD/MM", 1 - tp.date.now("d")) %> – <% tp.date.now("DD/MM", 7 - tp.date.now("d")) %>*

---

## Prioridades de la semana

- [ ] 
- [ ] 
- [ ] 

## Proyectos activos

- [[GALIAT - Huella hídrica]] — %%estado%%

## Agenda

| Día | Eventos / Compromisos |
|-----|----------------------|
| Lunes | |
| Martes | |
| Miércoles | |
| Jueves | |
| Viernes | |

---

## Revisión semanal

### ¿Qué avancé esta semana?

### ¿Qué quedó pendiente?

### Inbox — procesar

%%Revisar inbox/ y mover cada nota a su destino%%
- [ ] Revisar [[inbox/README]]

### Próxima semana

- [ ] 

---
*← Semana anterior | [[<% tp.date.now("YYYY-[W]WW", 7) %>|Semana siguiente]] →*
