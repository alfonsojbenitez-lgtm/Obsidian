---
name: portfolio-review
description: Revisión periódica de la cartera de inversión. Genera un informe de situación con alertas de concentración, rendimiento vs. objetivo, posiciones a vigilar y sugerencias de acción. Triggers: "revisar cartera", "revisión de inversiones", "estado de la cartera", "análisis mensual cartera", "qué tal va la cartera", "informe de cartera".
---

# Portfolio Review — Revisión periódica de la cartera

Genera un informe de situación completo de la cartera de inversión.

## Pasos del skill

### 1. Leer estado actual

Leer `inversiones/cartera/Cartera actual.md`:
- Tabla de posiciones (precios, valores, pesos, rentabilidades)
- Métricas globales (NAV, YTD, yield, beta)
- Alertas de concentración activas
- Movimientos recientes

Leer `inversiones/dividendos/Calendario de dividendos.md`:
- Dividendos cobrados en el año
- Yield on cost por posición

Leer `inversiones/escenarios/` (si existen escenarios activos):
- Escenarios vigentes y su probabilidad

### 2. Calcular métricas de rendimiento

**Rentabilidad:**
- Rentabilidad latente ponderada = Σ(peso_i × rent_latente_i)
- Mejores posiciones (top 3 por rentabilidad latente)
- Peores posiciones (bottom 3 por rentabilidad latente)
- Posiciones con pérdida > 20 %: candidatas a revisar tesis

**Dividendos:**
- Dividendos cobrados YTD en EUR
- Proyección anual = dividendos cobrados × (12 / meses transcurridos)
- Yield on cost de la cartera = dividendos anuales estimados / coste total
- Objetivo anual de dividendos (si está definido en la nota)

**Concentración:**
```
Por empresa:  max peso individual
Por sector:   distribución vs. límites
Por país:     distribución vs. límites
Beta cartera: estimación actual
```

### 3. Semáforo de posiciones

Para cada posición, asignar estado:

| Estado | Criterio |
|--------|----------|
| 🟢 Mantener | Tesis intacta, precio razonable, sin alertas |
| 🟡 Vigilar | Pérdida latente > 15 % o deterioro de fundamentales o peso > 10 % |
| 🔴 Revisar | Pérdida latente > 25 % o tesis rota o concentración extrema |
| ⭐ Añadir | Por debajo del precio objetivo con margen de seguridad > 20 % |

Aplicar automáticamente basándose en datos de la cartera:
- Pérdida latente > 25 %: 🔴 (RICK −42,6 %, JIN −30,6 %, COLD −21,4 %, GIS −20,3 %)
- Pérdida latente 15–25 %: 🟡 (DGE −20,7 %, SWKS −23,2 %)
- Posición con PyG > 50 %: ⭐ evaluar toma parcial de beneficios (LYB +57,5 %)

### 4. Sugerencias de acción

Basadas en reglas del skill `/portfolio-tracker`:
- **Recorte**: posición > 15 % → reducir hasta 10–12 %
- **Stop teórico**: posición con pérdida > 20 % sin catalizador → documentar plan
- **Añadir**: posición < 3 % de peso con tesis intacta → oportunidad de ampliar
- **Rotación**: si hay efectivo disponible > 2 % del NAV → identificar mejor oportunidad

Reglas adicionales:
- Si consumo básico > 28 %: no abrir nuevas posiciones en ese sector
- Si USD > 50 %: preferir próximas compras en EUR o GBP
- Si beta > 1,2: favorecer defensivas en próximas compras

### 5. Dividendos próximos

Listar los próximos 30–60 días de cobros esperados basados en frecuencias conocidas.

### 6. Generar informe

Guardar en `inversiones/cartera/Revisión YYYY-MM.md` con esta estructura:

```markdown
---
title: "Revisión de cartera YYYY-MM"
tags: [inversiones, revisión]
fecha: YYYY-MM-DD
nav: XX.XXX €
ytd: X,X %
---

# Revisión de cartera — [Mes YYYY]

## Resumen ejecutivo
[3–5 líneas con lo más relevante del período]

## Métricas clave
| Métrica | Valor | vs. anterior |
|---------|-------|:------------:|

## Semáforo de posiciones
| Empresa | Ticker | Estado | Rent. latente | Nota |

## Alertas activas
[Lista de alertas de concentración o riesgo]

## Dividendos
- Cobrados YTD: X.XXX €
- Proyección anual: X.XXX €
- Yield on cost est.: X,X %
- Próximos cobros: [lista]

## Sugerencias de acción
1. [Acción concreta con justificación]
2. ...

## Posiciones a documentar
[Posiciones sin ficha en inversiones/análisis/ — recordatorio]
```

### 7. Enlazar con nota diaria

Añadir enlace a la revisión en la nota diaria de hoy usando el CLI de Obsidian:
```
obsidian daily:append content="📊 Revisión de cartera completada → [[inversiones/cartera/Revisión YYYY-MM]]\n"
```

## Periodicidad recomendada

| Revisión | Frecuencia | Profundidad |
|----------|:----------:|-------------|
| Rápida | Semanal | Solo semáforo + alertas (sin guardar nota) |
| Completa | Mensual | Informe completo + nota en `inversiones/cartera/` |
| Profunda | Trimestral | Completa + actualizar fichas de empresa + escenarios |

Invocar con `/portfolio-review` → el skill pregunta qué tipo de revisión hacer si no se especifica.

## Reglas de decisión (resumen)

```
LYB > 15 %      → considera recorte parcial
RICK < -40 %    → revisar tesis o aceptar pérdida
JIN < -30 %     → monitorizar resultados Q2
EEUU > 50 %     → próximas compras en EUR/GBP/AUD
Consumo > 28 %  → no ampliar sector
Efectivo > 1k € → buscar oportunidad en watchlist
```
