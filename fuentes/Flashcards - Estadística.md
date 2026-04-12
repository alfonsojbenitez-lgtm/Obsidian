---
title: Flashcards — Estadística
tags:
  - fuente
  - estadística
  - flashcard
  - tarjeta
---

# Flashcards — Estadística

Tarjetas de repaso para métodos estadísticos usados en el análisis del ensayo [[GALIAT - Ficha del ensayo]].

---

## Conceptos básicos

¿Qué es un ensayo clínico aleatorizado (RCT)?
?
Estudio experimental en el que los participantes son asignados aleatoriamente a grupos (intervención vs. control) para evaluar el efecto de una intervención, minimizando sesgos de selección.

¿Qué es el diseño cluster randomized trial?
?
Ensayo en el que la unidad de aleatorización es un grupo (cluster) en lugar del individuo. En GALIAT, la unidad fueron las **familias** (250 familias, no individuos).

¿Qué diferencia hay entre ITT y per-protocol?
?
- **ITT (Intención de tratar):** analiza a todos los participantes según el grupo asignado, independientemente del cumplimiento. Más conservador, evita sesgo de selección.
- **Per-protocol:** solo analiza los que completaron el estudio según el protocolo. Puede sobreestimar el efecto.

---

## Medidas de efecto

¿Qué es el Rate Ratio (RR)?
?
Cociente entre la tasa de incidencia del grupo intervención y la tasa del grupo control.
- RR < 1 → la intervención reduce el evento
- RR = 1 → sin efecto
- En GALIAT: RR síndrome metabólico = **0,32** (IC 95%: 0,13–0,79)

¿Qué es el Odds Ratio proporcional?
?
Medida de efecto usada en modelos de regresión ordinal. Indica cuánto más probable es estar en una categoría superior de la variable ordinal en el grupo intervención vs. control.
En GALIAT: OR componentes SMet = **0,58** (IC 95%: 0,42–0,82)

¿Qué es el IC 95%?
?
Intervalo de confianza al 95%: rango de valores dentro del cual se espera que esté el verdadero parámetro poblacional con un 95% de probabilidad. Si no incluye el 1 (para RR/OR) o el 0 (para diferencias), el resultado es estadísticamente significativo.

---

## Análisis de componentes principales (PCA)

¿Para qué se usa PCA en estudios dietéticos?
?
Para identificar **patrones dietéticos** a partir de múltiples variables de consumo de alimentos. Reduce la dimensionalidad y agrupa alimentos que se consumen juntos en "patrones" interpretables.
En GALIAT: se identificaron 5 patrones que explicaron el **30,1% de la varianza**.

¿Qué es la varianza explicada en PCA?
?
Porcentaje de la variabilidad total de los datos capturada por cada componente principal. La suma de varianzas de todos los componentes = 100%. Se retienen los componentes con autovalor > 1 (criterio de Kaiser).

---

## Síndrome metabólico

¿Cuáles son los criterios NCEP-ATP III para síndrome metabólico?
?
Presencia de **≥3** de los siguientes:
1. Circunferencia abdominal >102 cm (hombres) / >88 cm (mujeres)
2. Triglicéridos ≥150 mg/dL
3. HDL <40 mg/dL (hombres) / <50 mg/dL (mujeres)
4. Presión arterial ≥130/85 mmHg
5. Glucosa en ayunas ≥100 mg/dL

---

## Stata

¿Cómo se ajusta por cluster en Stata?
?
Usando la opción `vce(cluster clustervariable)` en los comandos de regresión:
```stata
regress outcome intervention, vce(cluster familyid)
logistic outcome intervention, vce(cluster familyid)
```

¿Cómo se hace una regresión de Poisson para calcular RR en Stata?
?
```stata
poisson outcome intervention, irr vce(cluster familyid)
```
La opción `irr` muestra Incidence Rate Ratios (equivalentes al RR).

¿Cómo se ajustan variables confusoras en Stata?
?
Añadiéndolas como covariables en el modelo:
```stata
regress outcome intervention age sex bmi, vce(cluster familyid)
```
