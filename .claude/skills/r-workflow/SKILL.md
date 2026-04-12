---
name: r-workflow
description: Asiste con proyectos de R Software: crea scripts, ejecuta código, gestiona paquetes, genera documentos Quarto/RMarkdown y organiza proyectos tidyverse. Úsalo cuando el usuario mencione R, tidyverse, ggplot, dplyr, Quarto, RMarkdown, análisis de datos o modelos estadísticos.
---

# R Workflow

Skill para trabajar con R en Claude Code: escribir código, ejecutar scripts, gestionar paquetes y producir documentos reproducibles.

## Paquetes preferidos por tarea

| Tarea | Paquetes |
|-------|----------|
| Manipulación de datos | `dplyr`, `tidyr`, `data.table` |
| Visualización | `ggplot2`, `plotly`, `patchwork` |
| Importar datos | `readr` (CSV), `readxl` (Excel), `haven` (SPSS/Stata) |
| Fechas | `lubridate` |
| Texto | `stringr` |
| Iteración | `purrr` |
| Modelado | `tidymodels`, `broom`, `lme4` |
| Reportes | `quarto`, `rmarkdown` |

Siempre preferir tidyverse sobre base R salvo que haya una razón explícita (performance, dependencias).

## Ejecutar R desde Claude Code

```bash
# Ejecutar un script
Rscript ruta/al/script.R

# Ejecutar código inline
Rscript -e "library(dplyr); mtcars |> filter(cyl == 4) |> nrow()"

# Instalar paquetes
Rscript -e "install.packages('tidyverse', repos='https://cloud.r-project.org')"

# Renderizar Quarto
quarto render documento.qmd

# Renderizar RMarkdown
Rscript -e "rmarkdown::render('documento.Rmd')"
```

## Convenciones de código

- Usar el pipe nativo `|>` (R ≥ 4.1) en lugar de `%>%`
- Snake_case para nombres de variables y funciones
- Un espacio alrededor de operadores y después de comas
- Máximo 80 caracteres por línea
- Cargar todos los paquetes al inicio del script con `library()`

```r
# Correcto
datos_limpios <- datos_raw |>
  filter(!is.na(valor)) |>
  mutate(ratio = a / b)

# Evitar
datosLimpios<-datos_raw%>%filter(!is.na(valor))%>%mutate(ratio=a/b)
```

## Estructura de proyecto R

```
proyecto/
├── proyecto.Rproj
├── renv.lock              # control de versiones de paquetes
├── R/
│   ├── 01_importar.R
│   ├── 02_limpiar.R
│   ├── 03_analizar.R
│   └── funciones.R
├── data/
│   ├── raw/               # datos originales — nunca modificar
│   └── processed/
├── outputs/
│   ├── figuras/
│   └── tablas/
└── docs/
    └── reporte.qmd
```

## Plantilla de script R

```r
# Título del script
# Autor:
# Fecha: 2026-04-03
# Descripción: qué hace este script

library(dplyr)
library(ggplot2)
library(readr)

# --- Importar ---------------------------------------------------------------

datos <- read_csv("data/raw/archivo.csv")

# --- Limpiar ----------------------------------------------------------------

datos_limpios <- datos |>
  filter(!is.na(variable_clave)) |>
  mutate(
    nueva_col = case_when(
      condicion_a ~ "valor_a",
      condicion_b ~ "valor_b",
      .default    = "otro"
    )
  )

# --- Analizar ---------------------------------------------------------------

resumen <- datos_limpios |>
  group_by(categoria) |>
  summarise(
    n     = n(),
    media = mean(valor, na.rm = TRUE),
    .groups = "drop"
  )

# --- Exportar ---------------------------------------------------------------

write_csv(resumen, "data/processed/resumen.csv")
```

## Plantilla de documento Quarto

```yaml
---
title: "Título del análisis"
author: "Alfon"
date: today
format:
  html:
    toc: true
    code-fold: true
    theme: cosmo
execute:
  warning: false
  message: false
---
```

## Diagnóstico de errores comunes

| Error | Causa probable | Solución |
|-------|---------------|----------|
| `could not find function` | Paquete no cargado | Añadir `library(paquete)` al inicio |
| `object not found` | Variable no definida o typo | Verificar nombre y orden de ejecución |
| `no applicable method` | Tipo de objeto incorrecto | Verificar clase con `class(x)` |
| `NAs introduced by coercion` | Conversión de tipo fallida | Revisar los valores con `unique(x)` antes |
| `package not found` | No instalado | `install.packages("nombre")` |

## Guardar notas en el vault

- Análisis estadísticos completos → `estadisticas/` (plantilla: `Análisis estadístico`)
- Investigaciones sobre paquetes o técnicas → `búsquedas/`
- Cheatsheets y referencias estadísticas → `fuentes/`
- Scripts de proyectos activos → referenciar desde `proyectos/`
- Cada análisis en `estadisticas/` debe enlazar a su proyecto padre con `[[proyectos/NombreProyecto]]`
- Nombrar análisis como `YYYY-MM-DD - Nombre del análisis.md`
