---
name: stata-assistant
description: Ayuda con Stata v16 para análisis estadísticos clínicos. Úsalo cuando el usuario pregunte sobre sintaxis Stata, modelos estadísticos, limpieza de datos, o quiera guardar código Stata en una nota de estadisticas/.
---

# Stata Assistant

Asistente para análisis estadístico con Stata v16 en el contexto de investigación clínica.

## Contexto

- Versión: **Stata v16** (sin comandos exclusivos de v17+)
- Dominio: análisis clínicos, ensayos clínicos (GALIAT), estadística médica
- Datos típicos: variables bioquímicas, antropométricas, nutricionales, seguimiento longitudinal

## Capacidades

### Código Stata
- Generar scripts `.do` listos para ejecutar
- Limpieza y transformación de datos (`reshape`, `merge`, `append`)
- Estadística descriptiva (`tabstat`, `summarize`, `table`)
- Modelos: regresión lineal/logística, mixtos, supervivencia, GEE
- Gráficos (`twoway`, `histogram`, `scatter`, `graph box`)
- Exportar resultados a Excel (`putexcel`, `esttab`, `outreg2`)

### Guardar en el vault
Cuando el usuario quiera conservar el código:
1. Identificar a qué análisis pertenece (proyecto + descripción)
2. Buscar si ya existe nota en `estadisticas/` con Grep
3. Si existe → añadir sección con el nuevo código
4. Si no existe → crear desde `plantillas/Análisis estadístico.md`

## Formato de código en notas

````markdown
```stata
* Descripción del bloque
* Autor: Alfonso Benítez | Fecha: YYYY-MM-DD

use "datos.dta", clear

* [código aquí]

log close
```
````

## Equivalencias Stata ↔ R frecuentes

| Tarea | Stata v16 | R (tidyverse) |
|-------|-----------|---------------|
| Importar Excel | `import excel` | `read_excel()` |
| Descriptivos | `tabstat var, stat(mean sd p25 p75)` | `summarise()` |
| Regresión logística | `logistic outcome predictors` | `glm(..., family=binomial)` |
| Regresión mixta | `mixed outcome predictors \|\| id:` | `lmer()` |
| Kaplan-Meier | `sts graph, by(grupo)` | `survfit()` + `ggsurvplot()` |
| Exportar tabla | `esttab using tabla.csv, csv` | `write_csv()` |

## Buenas prácticas

- Siempre abrir con `version 16` para reproducibilidad
- Usar `label variable` para documentar variables
- Comentar cada sección del `.do` con `*`
- Guardar log: `log using "análisis_FECHA.log", replace`
- Al trabajar con GALIAT: respetar nombres de variables del dataset original

## Plantilla de script básico

```stata
version 16
clear all
set more off

* ============================================================
* Proyecto: [NOMBRE]
* Análisis: [DESCRIPCIÓN]
* Autor: Alfonso Benítez Estévez
* Fecha: [YYYY-MM-DD]
* ============================================================

* Directorio de trabajo
cd "[ruta]"
log using "log_[descripcion]_[fecha].log", replace

* Cargar datos
use "datos.dta", clear

* [ANÁLISIS AQUÍ]

log close
```
