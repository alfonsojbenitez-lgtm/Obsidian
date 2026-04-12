---
name: json-canvas
description: Crea y edita archivos JSON Canvas (.canvas) con nodos, aristas, grupos y conexiones. Úsalo al trabajar con archivos .canvas, crear canvases visuales, mapas mentales, diagramas de flujo, o cuando el usuario mencione Canvas en Obsidian.
---

# JSON Canvas

Los archivos `.canvas` siguen la especificación JSON Canvas 1.0. Contienen dos arrays opcionales en el nivel raíz: `nodes` y `edges`.

## Estructura base

```json
{
  "nodes": [],
  "edges": []
}
```

## Tipos de nodos

Todos los nodos requieren: `id`, `type`, `x`, `y`, `width`, `height`

### Nodo de texto

```json
{
  "id": "a1b2c3d4e5f6a7b8",
  "type": "text",
  "x": 0,
  "y": 0,
  "width": 300,
  "height": 200,
  "text": "# Título\n\nContenido con **Markdown** y [[wikilinks]]"
}
```

### Nodo de archivo

```json
{
  "id": "b2c3d4e5f6a7b8c9",
  "type": "file",
  "x": 350,
  "y": 0,
  "width": 300,
  "height": 200,
  "file": "carpeta/mi-nota.md",
  "subpath": "#sección-específica"
}
```

### Nodo de enlace externo

```json
{
  "id": "c3d4e5f6a7b8c9d0",
  "type": "link",
  "x": 700,
  "y": 0,
  "width": 300,
  "height": 150,
  "url": "https://example.com"
}
```

### Nodo de grupo

```json
{
  "id": "d4e5f6a7b8c9d0e1",
  "type": "group",
  "x": -50,
  "y": -50,
  "width": 800,
  "height": 400,
  "label": "Nombre del grupo",
  "background": "carpeta/fondo.png",
  "backgroundStyle": "cover"
}
```

## Aristas (conexiones)

```json
{
  "id": "e5f6a7b8c9d0e1f2",
  "fromNode": "a1b2c3d4e5f6a7b8",
  "toNode": "b2c3d4e5f6a7b8c9",
  "fromSide": "right",
  "toSide": "left",
  "fromEnd": "none",
  "toEnd": "arrow",
  "label": "etiqueta opcional",
  "color": "1"
}
```

Valores válidos para `fromSide`/`toSide`: `top`, `right`, `bottom`, `left`
Valores válidos para `fromEnd`/`toEnd`: `none`, `arrow`

## Sistema de colores

```
"1" = rojo
"2" = naranja
"3" = amarillo
"4" = verde
"5" = cian
"6" = púrpura
"#HEX" = color personalizado (ej: "#ff6b6b")
```

## Generación de IDs

Los IDs deben ser únicos, de 16 caracteres hexadecimales:

```javascript
// En JavaScript
const id = Math.random().toString(16).slice(2, 18).padEnd(16, '0');
```

## Flujo de trabajo

1. **Crear canvas nuevo**: Empieza con estructura mínima `{ "nodes": [], "edges": [] }`
2. **Añadir nodos**: Genera IDs únicos, posiciona sin solapamientos
3. **Conectar con aristas**: Las aristas referencian IDs de nodos existentes
4. **Verificar integridad**: Todos los `fromNode`/`toNode` deben resolver a IDs existentes

## Diseño de layout

- Deja al menos 50px de margen entre nodos
- Los grupos deben contener nodos dentro de sus límites
- Posiciona nodos relacionados cerca entre sí
- Usa un tamaño mínimo de 100x60px por nodo

## Ejemplo completo: mapa conceptual

```json
{
  "nodes": [
    {
      "id": "0000000000000001",
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 200,
      "height": 80,
      "text": "# Idea central",
      "color": "4"
    },
    {
      "id": "0000000000000002",
      "type": "text",
      "x": 300,
      "y": -100,
      "width": 200,
      "height": 80,
      "text": "Subtema A"
    },
    {
      "id": "0000000000000003",
      "type": "text",
      "x": 300,
      "y": 100,
      "width": 200,
      "height": 80,
      "text": "Subtema B"
    }
  ],
  "edges": [
    {
      "id": "0000000000000004",
      "fromNode": "0000000000000001",
      "toNode": "0000000000000002",
      "fromSide": "right",
      "toSide": "left"
    },
    {
      "id": "0000000000000005",
      "fromNode": "0000000000000001",
      "toNode": "0000000000000003",
      "fromSide": "right",
      "toSide": "left"
    }
  ]
}
```

## Validaciones requeridas

- IDs únicos en todos los objetos
- Las aristas referencian nodos existentes
- Campos requeridos por tipo presentes
- JSON válido (sin comas finales, comillas correctas)

## Referencias

- [Especificación JSON Canvas](https://jsoncanvas.org)
- [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)
