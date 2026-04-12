---
name: stock-analysis
description: Análisis fundamental de empresas cotizadas con enfoque value y dividendos. Úsalo para valorar empresas por DCF, múltiplos y dividendos, calcular margen de seguridad, comparar con el sector y decidir precio de compra/venta. Triggers: "analizar empresa", "valorar", "DCF", "margen de seguridad", "PER", "precio objetivo", "tesis de inversión".
---

# Stock Analysis — Análisis Fundamental

Análisis de empresas cotizadas con enfoque value investing y dividend growth investing.

## Flujo de análisis

1. **Verificar** si ya existe ficha en `inversiones/análisis/` (Grep por ticker o nombre)
2. Si no existe → crear desde `plantillas/Ficha de empresa.md`
3. Completar secciones en este orden: datos fundamentales → valoración → riesgos → tesis

## Valoración por múltiplos

### Múltiplos clave por tipo de empresa

| Tipo | Múltiplos prioritarios | PER razonable |
|------|----------------------|--------------|
| Crecimiento | PEG, EV/Ventas, P/FCF | 20-35x |
| Value | PER, EV/EBITDA, P/VL | 8-15x |
| Dividendo | P/FCF, Payout, Yield | 10-18x |
| Utilities/REITs | P/FFO, EV/EBITDA, Yield | 12-20x |

### Señales de valor

- PER < media histórica empresa y < media sector → posible infravaloración
- P/FCF < 15 en empresa con ROIC > 15% → atractivo
- EV/EBITDA < 8 en sector no cíclico → valor
- Yield > 4% con payout < 60% y FCF creciente → dividendo sostenible

## DCF simplificado

```
Valor intrínseco = FCF_0 × (1+g)/(WACC-g)  [modelo Gordon para empresas maduras]

Parámetros típicos:
- g (crecimiento perpetuo): 2-3%
- WACC: 8-10% (ajustar por riesgo país y apalancamiento)
- Margen de seguridad mínimo: 25-30%
```

Para el DCF a 10 años:
1. Proyectar FCF años 1-5 con tasa g1 (alta)
2. Proyectar FCF años 6-10 con tasa g2 (moderada)
3. Valor terminal con g perpetua
4. Descontar todo al WACC
5. Dividir por acciones para obtener valor por acción

## Análisis de dividendo (Dividend Growth Investing)

- **Yield on Cost (YOC)** = Dividendo actual / Precio de compra
- **CAGR dividendo** mínimo deseable: >5% en 5 años
- **Payout FCF** < 70% para sostenibilidad
- **Años consecutivos de crecimiento** > 10 → Dividend Achiever
- Revisar historial en recesiones: ¿recortó dividendo en 2008/2020?

## Análisis de calidad del negocio (checklist)

- [ ] ROIC > WACC (crea valor para el accionista)
- [ ] Ventaja competitiva identificable (moat)
- [ ] Deuda neta/EBITDA < 3x
- [ ] FCF positivo los últimos 5 años
- [ ] Crecimiento BPA consistente
- [ ] Gestión alineada con accionistas (insider ownership, recompras)

## Comparativa sectorial

Siempre comparar métricas vs.:
1. Media histórica de la propia empresa (5-10 años)
2. Competidores directos
3. Media del sector

## Precio de compra y venta

- **Precio de compra** = Valor intrínseco × (1 − margen_seguridad)
- **Stop loss** = Precio de compra × 0.85 (máximo -15% en value)
- **Precio objetivo venta** = Valor intrínseco × 1.0 (llega a valor justo)
- **Alerta de rotación** = cuando otra empresa tiene margen seguridad >20pp superior

## Guardar el análisis

Siempre en `inversiones/análisis/[Ticker] - [Empresa].md`
Enlazar desde `inversiones/cartera/Cartera actual.md`
