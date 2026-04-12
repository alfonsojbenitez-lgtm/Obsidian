---
name: obsidian-bases
description: Crea y edita archivos Obsidian Bases (.base) con vistas, filtros, fórmulas y resúmenes. Úsalo al trabajar con archivos .base, crear vistas dinámicas de notas tipo base de datos, o cuando el usuario mencione Bases, vistas de tabla, tarjetas, filtros o fórmulas en Obsidian.
---

# Obsidian Bases

Los archivos `.base` son vistas dinámicas de notas del vault definidas en YAML. Funcionan como bases de datos ligeras sobre tus notas.

## Flujo de trabajo

1. Crea el archivo `.base` con YAML válido
2. Define el alcance con filtros para seleccionar qué notas aparecen
3. Añade fórmulas opcionales para propiedades calculadas
4. Configura vistas (tabla, tarjetas, lista, mapa)
5. Valida la sintaxis YAML
6. Verifica en Obsidian que la vista se renderiza correctamente

## Estructura del esquema

```yaml
filters: <filtro global>
formulas:
  nombre_formula: "<expresión>"
properties:
  nombre_propiedad:
    label: "Etiqueta"
    hidden: false
summaries:
  nombre_propiedad: <tipo>
views:
  - type: table
    name: "Nombre de vista"
    ...
```

## Filtros

```yaml
# Filtro simple
filters: 'status == "activo"'

# AND (todos los campos requeridos)
filters:
  and:
    - 'tag == "proyecto"'
    - 'status != "archivado"'

# OR
filters:
  or:
    - 'priority == "alta"'
    - 'due < today()'

# NOT
filters:
  not: 'status == "completado"'

# Anidado
filters:
  and:
    - 'type == "tarea"'
    - or:
        - 'priority == "alta"'
        - 'due < today()'
```

Operadores: `==`, `!=`, `>`, `<`, `>=`, `<=`, `&&`, `||`, `!`

## Propiedades de archivo

```yaml
file.name        # nombre con extensión
file.basename    # nombre sin extensión
file.path        # ruta completa en el vault
file.folder      # carpeta contenedora
file.ext         # extensión
file.size        # tamaño en bytes
file.ctime       # fecha de creación
file.mtime       # fecha de modificación
file.tags        # array de tags
file.links       # array de enlaces salientes
file.backlinks   # array de backlinks
file.embeds      # array de embeds
file.properties  # todo el frontmatter
```

## Fórmulas

```yaml
formulas:
  total: "precio * cantidad"
  icono_estado: 'if(completado, "✅", "⏳")'
  fecha_creacion: 'file.ctime.format("YYYY-MM-DD")'
  dias_transcurridos: '(now() - file.ctime).days'
  prioridad_num: 'if(prioridad == "alta", 3, if(prioridad == "media", 2, 1))'
```

## Funciones disponibles

| Función | Firma | Uso |
|---------|-------|-----|
| `date()` | `date(string): date` | Parsea string a fecha |
| `now()` | `now(): date` | Fecha y hora actual |
| `today()` | `today(): date` | Fecha actual (00:00:00) |
| `if()` | `if(condición, verdadero, falso?)` | Condicional |
| `duration()` | `duration(string): duration` | Parsea duración |
| `file()` | `file(ruta): file` | Obtiene objeto de archivo |
| `link()` | `link(ruta, display?): Link` | Crea enlace |

**Nota sobre Duration:** Restar fechas devuelve Duration, no número. Accede a `.days`, `.hours`, `.minutes`, `.seconds`.

## Tipos de vista

```yaml
views:
  # Tabla
  - type: table
    name: "Todas las notas"
    properties: [file.name, status, due, priority]
    sort:
      - property: due
        direction: asc

  # Tarjetas
  - type: cards
    name: "Vista de tarjetas"
    cover: imagen
    properties: [file.name, status, descripcion]

  # Lista
  - type: list
    name: "Lista simple"
    properties: [file.name, status]
```

## Resúmenes

```yaml
summaries:
  precio: sum        # Para números: average, min, max, sum, range, median, stddev
  due: earliest      # Para fechas: earliest, latest, range
  completado: checked # Para booleanos: checked, unchecked
  status: unique     # Para cualquier tipo: empty, filled, unique
```

## La palabra clave `this`

`this` refiere al archivo base actual:
- En vista principal: el archivo `.base` en sí
- Embebido en una nota: la nota que lo contiene
- En barra lateral: el archivo activo

## Ejemplos completos

### Rastreador de tareas

```yaml
filters:
  and:
    - 'type == "tarea"'
    - 'status != "archivado"'
formulas:
  vencida: 'due < today() && status != "completado"'
  icono: 'if(status == "completado", "✅", if(vencida, "🔴", "⏳"))'
views:
  - type: table
    name: "Tareas activas"
    properties: [icono, file.name, due, priority, status]
    sort:
      - property: due
        direction: asc
summaries:
  status: filled
```

### Lista de lectura

```yaml
filters: 'type == "libro"'
views:
  - type: cards
    name: "Por leer"
    cover: portada
    properties: [file.name, autor, rating, status]
```

## Errores comunes

- Sintaxis YAML inválida (verifica las comillas)
- Referencia a propiedades que no existen en las notas
- Usar Duration como número directamente (accede a `.days` primero)
- Fórmulas que referencian otras fórmulas no declaradas antes
