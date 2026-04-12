---
name: scenario-analysis
description: Análisis de escenarios y sensibilidades para la cartera de inversión. Úsalo para evaluar el impacto de cambios macro (tipos, inflación, recesión, crecimiento) sobre las posiciones y estimar rentabilidades en distintos casos. Triggers: "escenario", "sensibilidad", "análisis de riesgo cartera", "qué pasa si", "tipos suben", "recesión", "impacto en cartera".
---

# Scenario Analysis — Análisis de Escenarios e Sensibilidad

Evalúa el impacto de cambios macroeconómicos y sectoriales sobre la cartera.

## Tipos de escenario

| Tipo | Descripción | Horizonte típico |
|------|-------------|-----------------|
| **Macro** | Cambios en tipos, inflación, crecimiento PIB | 12-24 meses |
| **Sectorial** | Impacto regulatorio, ciclo industrial, commodity | 6-18 meses |
| **Empresa** | Cambio de gestión, M&A, pérdida de negocio | Inmediato-12m |
| **Sistémico** | Recesión, crisis financiera, shock externo | Variable |

## Escenarios base a mantener siempre actualizados

1. **Caso base** — expectativas de consenso
2. **Caso optimista** — expansión económica, tipos bajos, múltiplos altos
3. **Caso pesimista** — recesión leve, contracción de márgenes
4. **Caso adverso** — recesión severa, crisis crediticia

## Análisis de sensibilidad por variable

Para cada variable, estimar impacto en rentabilidad esperada cartera:

### Tipos de interés (impacto en PER)
```
Relación aproximada: subida tipos 1% → contracción PER ~15% (empresas growth)
                     subida tipos 1% → contracción PER ~5% (value/dividendo)
Utilities y REITs: mayor sensibilidad a tipos (correlación negativa)
```

### Crecimiento de BPA
```
Rentabilidad esperada ≈ Yield + CAGR_BPA + Cambio_múltiplo
Si BPA crece 10% menos de lo estimado → restar de rentabilidad esperada
```

### Múltiplos (expansión/contracción)
```
Impacto = (PER_objetivo - PER_actual) / PER_actual
Contracción típica en recesión: -20% a -40% en múltiplos
```

## Pasos para crear un escenario

1. Verificar que no existe ya en `inversiones/escenarios/` (Grep)
2. Crear nota desde `plantillas/Escenario de inversión.md`
3. Para cada posición: estimar impacto en BPA y en múltiplo
4. Calcular rentabilidad ponderada de la cartera en ese escenario
5. Identificar las posiciones más vulnerables y más resilientes
6. Proponer acciones de cobertura o rotación si el escenario tiene >30% probabilidad

## Métricas de riesgo cartera

- **VaR 95% mensual** ≈ Volatilidad_cartera × 1.65 / √12
- **Drawdown máximo histórico** por posición (revisar 2008, 2020, 2022)
- **Correlación media** entre posiciones (ideal <0.6)
- **Beta ajustada** = Σ (Peso_i × Beta_i) — objetivo: 0.7-1.0

## Cobertura ante escenarios adversos

Estrategias a considerar (sin derivados complejos):
- Aumentar peso en **utilities y consumo básico** (baja beta)
- Reducir **growth** y aumentar **value** ante subida de tipos
- Mantener **dividendo creciente** como colchón de rentabilidad
- Elevar **liquidez** (efectivo) si probabilidad de caída >40%

## Guardar escenarios

En `inversiones/escenarios/[YYYY-MM] - [Nombre escenario].md`
Revisar y actualizar trimestralmente.
