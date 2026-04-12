---
name: ib-import
description: Importa el extracto CSV de Interactive Brokers y actualiza automáticamente Cartera actual.md y Calendario de dividendos.md. Triggers: "extracto IB", "importar cartera", "actualizar desde IB", "CSV Interactive Brokers", "extracto de actividad".
---

# IB Import — Importar extracto de Interactive Brokers

Actualiza la cartera automáticamente a partir del CSV de actividad de IB.

## Cómo exportar el CSV desde Interactive Brokers

1. Portal IB → **Reports → Activity** (o Flex Query)
2. Período: seleccionar el trimestre o año a importar
3. Formato: **CSV** (no PDF)
4. Guardar el archivo en `inversiones/extractos/YYYY-MM-DD_IB_actividad.csv`
5. Invocar `/ib-import` indicando el nombre del archivo

## Pasos del skill

### 1. Leer el extracto
- Leer el CSV desde `inversiones/extractos/` (el más reciente si no se indica otro)
- El CSV de IB tiene secciones separadas por encabezados como `Open Positions,Header,...` y `Trades,Header,...`
- Identificar las secciones relevantes:
  - `Open Positions` → posiciones actuales
  - `Trades` → operaciones del período
  - `Dividends` → dividendos cobrados
  - `Withholding Tax` → retenciones
  - `Deposits & Withdrawals` → entradas de capital

### 2. Extraer tipos de cambio del período
- Buscar en la sección `Base Currency Exchange Rate` o en los movimientos de Fórex
- Registrar: EUR/AUD, EUR/GBP, EUR/USD al cierre del período

### 3. Actualizar posiciones en `Cartera actual.md`
Para cada posición en `Open Positions`:
- Ticker, descripción, cantidad, precio medio (cost basis), precio cierre, divisa
- Calcular valor en EUR = cantidad × precio cierre × tipo de cambio
- Calcular rentabilidad latente = (precio actual − precio medio) / precio medio × 100
- Calcular peso = valor EUR / NAV total × 100
- Actualizar la tabla de posiciones completa
- Recalcular métricas globales (NAV, beta estimada, yield medio, concentración)

### 4. Registrar operaciones nuevas en movimientos recientes
Para cada `Trade` del período:
- Añadir fila en la tabla de movimientos si no existe ya
- Formato: Fecha | Compra/Venta | Empresa | Ticker | Acciones | Precio | Divisa | Motivo (pedir al usuario si no es obvio)
- Las posiciones cerradas en el período → mover a tabla "Posiciones cerradas"

### 5. Actualizar `Calendario de dividendos.md`
Para cada `Dividend` del período:
- Añadir fila con: fecha, empresa, ticker, acciones, importe/acción, divisa, total bruto
- Cruzar con `Withholding Tax` para calcular retención y total neto en EUR
- Actualizar total acumulado del año
- Detectar pagos PIL (Payment in Lieu) — marcarlos con nota

### 6. Verificar alertas de concentración
Tras actualizar:
- Avisar si alguna posición > 15 % del portfolio
- Avisar si algún sector > 30 %
- Avisar si algún país > 50 %
- Avisar si beta cartera > 1,3 o < 0,5

### 7. Confirmar al usuario
Mostrar resumen:
```
✅ Extracto importado: YYYY-MM-DD
📊 Posiciones actualizadas: N
💰 Dividendos añadidos: N (XXX € bruto / XXX € neto)
📈 NAV: XX.XXX € | YTD: X,X %
⚠️ Alertas: [lista si las hay]
```

## Formato CSV de IB — referencia de secciones

```
Statement,Header,Field,...
Statement,Data,...

Open Positions,Header,DataDiscriminator,Asset Category,Currency,Symbol,Quantity,Mult,Cost Price,Cost Basis,Close Price,Value,Unrealized P/L,...
Open Positions,Data,Lot,Stocks,USD,LYB,90,1,50.533,4548.00,79.60,7164.00,2616.00,...

Trades,Header,DataDiscriminator,Asset Category,Currency,Symbol,Date/Time,Quantity,T. Price,C. Price,Proceeds,Comm/Fee,Basis,Realized P/L,...
Trades,Data,Order,Stocks,USD,TROW,2026-04-02 04:00:00,-4,89.50,90.17,-358.00,-0.34,358.34,0.00,...

Dividends,Header,Currency,Date,Description,Amount
Dividends,Data,USD,2026-03-30,TROW(US74144T1088) Cash Dividend USD 1.30 per Share,52.00

Withholding Tax,Header,Currency,Date,Description,Amount
Withholding Tax,Data,USD,2026-03-30,TROW(US74144T1088) Cash Dividend - US Tax,-7.80
```

## Reglas importantes

- Nunca sobreescribir movimientos ya registrados — verificar duplicados por fecha+ticker
- Para PIL (Payment in Lieu): marcar explícitamente como "PIL — préstamo de valores SYEP"
- Las operaciones de Fórex (EUR.USD, EUR.GBP, etc.) no se registran como movimientos de acciones
- Si hay posiciones nuevas que no tienen ficha en `inversiones/análisis/`, señalarlo
- El tipo de cambio a usar para conversión EUR es el del cierre del período del extracto

## Guardar el extracto procesado

Tras importar, renombrar el CSV añadiendo sufijo `_importado`:
`inversiones/extractos/YYYY-MM-DD_IB_actividad_importado.csv`
