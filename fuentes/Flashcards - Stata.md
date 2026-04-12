---
title: Flashcards — Stata v16
tags:
  - fuente
  - estadística
  - flashcard
  - tarjeta
  - R
---

# Flashcards — Stata v16

Comandos esenciales de Stata para el análisis estadístico del ensayo [[GALIAT - Ficha del ensayo]].

---

## Exploración de datos

¿Cómo se describen las variables en Stata?
?
```stata
describe          * estructura del dataset
codebook var      * información detallada de una variable
summarize var     * estadísticos descriptivos
tabulate var      * frecuencias (variables categóricas)
histogram var     * distribución
```

¿Cómo se detectan valores missing en Stata?
?
```stata
misstable summarize          * resumen de missings
misstable patterns           * patrones de missings
count if missing(var)        * contar missings de una variable
```

---

## Regresión lineal

¿Sintaxis de regresión lineal ajustada por cluster?
?
```stata
regress outcome intervention covar1 covar2, vce(cluster id_familia)
```

¿Cómo se interpreta el coeficiente en regresión lineal?
?
Es la diferencia media en la variable dependiente entre grupos, manteniendo constantes las covariables. Si `intervention` es 0/1, el coeficiente es la diferencia ajustada entre intervención y control.

---

## Regresión logística

¿Sintaxis de regresión logística con OR?
?
```stata
logistic outcome intervention covar1 covar2, vce(cluster id_familia)
```
Muestra directamente OR con IC 95%.

¿Cómo obtener RR en lugar de OR?
?
```stata
* Poisson modificado (más robusto para outcomes frecuentes)
poisson outcome intervention covar1, irr vce(cluster id_familia)

* O log-binomial
glm outcome intervention covar1, family(binomial) link(log) vce(cluster id_familia) eform
```

---

## Modelos mixtos

¿Cuándo usar mixed en Stata?
?
Cuando hay estructura jerárquica (ej: individuos dentro de familias). Permite efectos aleatorios a nivel de cluster.
```stata
mixed outcome intervention || id_familia:
```

---

## Gestión de datos

¿Cómo recodificar una variable en Stata?
?
```stata
recode var (1/3=1 "Bajo") (4/6=2 "Medio") (7/10=3 "Alto"), gen(var_cat)
```

¿Cómo generar variables dummy en Stata?
?
```stata
tabulate var, gen(dummy_)    * genera dummy_1, dummy_2...
* O manualmente:
gen dummy = (var == valor)
```

¿Cómo hacer merge de datasets en Stata?
?
```stata
* 1:1 (una observación por ID en ambos)
merge 1:1 id using "archivo2.dta"

* 1:m (un registro en master, varios en using)
merge 1:m id using "archivo2.dta"
```

---

## Exportar resultados

¿Cómo exportar tablas a Excel desde Stata?
?
```stata
* Con putexcel
putexcel set "resultados.xlsx", replace
putexcel A1 = "Variable" B1 = "Coef" C1 = "IC 95%"

* Con estout (más potente)
ssc install estout
eststo: regress outcome intervention
esttab using "tabla.xlsx", replace ci
```
