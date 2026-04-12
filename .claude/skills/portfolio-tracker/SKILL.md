---
name: portfolio-tracker
description: Gestiona y analiza la cartera de inversión en acciones. Úsalo para actualizar posiciones, calcular pesos, rentabilidades, métricas de riesgo y distribuciones. Triggers: "actualizar cartera", "peso de", "rentabilidad cartera", "añadir posición", "rotación", "cartera de acciones".
---

# Portfolio Tracker

Gestión cuantitativa de la cartera de renta variable (value + dividendos).

## Pasos para actualizar la cartera

1. Leer `inversiones/cartera/Cartera actual.md`
2. Aplicar los cambios indicados (nueva posición, rotación, actualización de precios)
3. Recalcular pesos, rentabilidades latentes y métricas globales
4. Actualizar la tabla de movimientos recientes
5. Si hay nueva empresa → crear ficha en `inversiones/análisis/` desde `plantillas/Ficha de empresa.md`

## Métricas que calcular siempre

### Por posición
- **Peso (%)** = Valor posición / Valor total cartera × 100
- **Rentabilidad latente (%)** = (Precio actual − Precio medio) / Precio medio × 100
- **Contribución a rentabilidad** = Peso × Rentabilidad latente

### Cartera global
- **Rentabilidad ponderada** = Σ (Peso_i × Rentabilidad_i)
- **Rentabilidad por dividendo media** = Σ (Peso_i × Yield_i)
- **Beta cartera** = Σ (Peso_i × Beta_i)
- **Concentración** = mayor posición individual (alerta si >15%)

## Análisis de riesgo

| Métrica | Umbral de alerta |
|---------|-----------------|
| Peso máximo por empresa | >15% |
| Peso máximo por sector | >30% |
| Peso máximo por país | >50% |
| Correlación media cartera | >0.7 |
| Beta cartera | >1.3 o <0.5 |

## Reglas de la cartera

- Informar siempre del impacto en concentración antes de añadir posición
- Si una rotación reduce yield medio >0.5%, señalarlo explícitamente
- Comparar siempre margen de seguridad actual vs. precio de entrada
- Para posiciones >10% del portfolio, hacer mención al riesgo de concentración

## Fuentes de datos para actualizar precios

- Yahoo Finance, Google Finance, Investing.com, Morningstar
- Para dividendos: Simply Wall St, Dividend.com, página IR de la empresa

## Archivos clave

- `inversiones/cartera/Cartera actual.md` — tabla maestra de posiciones
- `inversiones/análisis/[Empresa].md` — ficha detallada por empresa
- `inversiones/dividendos/Calendario de dividendos.md` — registro de cobros
