---
name: gmail-capture
description: Busca correos en Gmail y los guarda como notas estructuradas en el vault de Obsidian. Úsalo cuando el usuario quiera capturar, archivar o procesar correos electrónicos de Gmail en el vault. Triggers: "busca correos de", "guarda este correo", "captura emails de", "correos de GALIAT", "emails sin procesar".
---

# Gmail Capture

Captura correos de Gmail y los convierte en notas Obsidian estructuradas, guardándolas en la carpeta correcta según el contenido.

## Flujo de trabajo

1. **Entender qué buscar** — si el usuario no especifica, pregunta:
   - ¿Remitente, asunto o palabra clave?
   - ¿Cuántos correos / desde qué fecha?
   - ¿Dónde guardarlos? (inbox / proyecto concreto)

2. **Buscar en Gmail** con `gmail_search_messages` usando la query apropiada

3. **Leer cada mensaje** con `gmail_read_message` para obtener cuerpo completo

4. **Crear la nota** en la carpeta correcta según estas reglas:
   - Correo sobre proyecto conocido → `proyectos/[Proyecto]/`
   - Correo sin clasificar → `inbox/`
   - Correo de contacto conocido → añadir sección en `personal/[Contacto].md`

5. **Confirmar** al usuario qué se guardó y dónde

## Queries Gmail útiles

```
# Por proyecto
subject:GALIAT
from:mariadelmar.calvo.malvar@sergas.es

# No leídos
is:unread

# Con adjuntos
has:attachment

# Rango de fechas
after:2024/01/01 before:2024/12/31

# Combinados
subject:GALIAT after:2024/01/01

# Por remitente y sin leer
from:ejemplo@gmail.com is:unread
```

## Formato de nota generada

Guardar en `inbox/` o en la carpeta del proyecto con nombre:
`YYYY-MM-DD - [Asunto abreviado].md`

```markdown
---
title: "[Asunto]"
tags:
  - email
  - inbox
de: "[remitente]"
fecha: YYYY-MM-DD
proyecto: "[[Proyecto]]"  # si aplica
---

# [Asunto]

**De:** [nombre] <email>
**Para:** [destinatarios]
**Fecha:** DD de mes de YYYY, HH:MM
**Hilo:** [número de mensajes si es hilo]

---

## Contenido

[Cuerpo del correo]

---

## Acciones

- [ ] %%Qué hay que hacer con este correo%%

## Relacionado

%%Wikilinks a notas, proyectos o contactos relevantes%%
```

## Reglas

- Nunca guardar datos sensibles como contraseñas o información bancaria
- Si el correo tiene adjuntos, mencionarlos en la nota pero no descargarlos
- Si el remitente coincide con alguien en `personal/`, añadir wikilink
- Si el asunto menciona un proyecto del vault, enlazarlo automáticamente
- Máximo 20 correos por ejecución — paginar si hay más
- Los correos ya procesados no se duplican: verificar con Grep antes de crear

## Proyectos y contactos conocidos del vault

| Palabra clave en correo | Destino |
|------------------------|---------|
| GALIAT, dieta atlántica, huella hídrica | `proyectos/GALIAT/` + tag `GALIAT` |
| Mar Calvo, mariadelmar.calvo | [[Dra. Mar Calvo]] |
| Juan Sanchez, sánchez-castro | [[Juan Sanchez]] |
| Francisco Gude, gude | [[Francisco Gude]] |
| Rosaura Leis, leis | [[Rosaura Leis]] |
| Alfonso Nahum | [[Alfonso Nahum Benitez]] |

## Después de capturar

- Mover de `inbox/` al destino definitivo cuando se procese
- Seguir el protocolo de [[inbox/README]]
