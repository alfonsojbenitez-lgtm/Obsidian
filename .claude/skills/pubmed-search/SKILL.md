---
name: pubmed-search
description: Busca artículos en PubMed y los guarda como notas estructuradas en el vault. Úsalo cuando el usuario quiera buscar bibliografía, encontrar artículos sobre un tema, revisar literatura científica o guardar referencias en el vault. Triggers: "busca en PubMed", "busca artículos sobre", "literatura sobre", "referencias de", "bibliografía de".
---

# PubMed Search

Búsqueda sistemática en PubMed con captura directa al vault de Obsidian.

## Flujo de trabajo

1. **Entender la búsqueda**
   - ¿Términos clave? ¿Autores? ¿Fecha?
   - ¿Proyecto al que pertenece? (para enlazar)
   - ¿Dónde guardar? (`fuentes/` para referencias, `búsquedas/` para investigación activa)

2. **Buscar con `search_articles`**
   - Usar sintaxis PubMed: `[Title]`, `[Author]`, `AND`, `OR`
   - Limitar por fecha si aplica
   - Máximo 20 resultados por búsqueda

3. **Obtener metadatos completos** con `get_article_metadata`
   - Leer abstract, autores, DOI, journal, año
   - Identificar artículos relevantes

4. **Guardar en el vault**
   - Artículo de referencia estática → `fuentes/`
   - Artículo en investigación activa → `búsquedas/`
   - Artículo del equipo GALIAT → `fuentes/GALIAT - [Título abreviado].md`

5. **Verificar duplicados** con Grep antes de crear

## Formato de nota de artículo

Nombre: `[Apellido primer autor] [Año] - [Título abreviado].md`

```markdown
---
title: "[Título completo]"
tags:
  - fuente
  - artículo
  - [tema]
pmid: "[PMID]"
doi: [DOI]
journal: [Journal]
año: [YYYY]
autores: "[Apellido1], [Apellido2] et al."
guardado: YYYY-MM-DD
---

# [Título]

> [Autores completos]
> *[Journal]*. [Año];[volumen]([número]):[páginas].
> DOI: [enlace DOI] · PMID: [PMID]

*Fuente: PubMed*

---

## Resumen

[Abstract traducido o resumido en español]

## Puntos clave

-
-

## Relevancia para el vault

%%Por qué es útil, a qué proyecto o búsqueda aplica%%

## Relacionado

%%Wikilinks a proyectos, análisis o búsquedas%%
```

## Queries útiles para el contexto del vault

```
# Dieta atlántica
Atlantic diet[Title] OR "Atlantic dietary pattern"[Title]

# Huella hídrica en alimentación
water footprint[Title] AND diet[Title]

# Síndrome metabólico y dieta
metabolic syndrome AND dietary intervention AND randomized[Publication Type]

# Por miembro del equipo
Calvo-Malvar M[Author]
Benitez-Estevez AJ[Author]
Gude F[Author]
Leis R[Author]

# Ensayos clínicos de nutrición
nutritional intervention AND "randomized controlled trial"[Publication Type]
```

## Reglas

- Siempre incluir atribución a PubMed y enlace DOI en las notas
- No guardar artículos irrelevantes — preguntar al usuario si hay duda
- Si un artículo cita publicaciones GALIAT, marcarlo con tag `cita-GALIAT`
- Máximo 10 notas por ejecución para no saturar el vault
