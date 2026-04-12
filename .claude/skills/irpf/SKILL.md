---
name: irpf
description: Calcula plusvalías, minusvalías y rendimientos de capital mobiliario de la cartera para la declaración del IRPF español. Aplica reglas FIFO, conversión a EUR y compensación de pérdidas. Triggers: "IRPF", "declaración de la renta", "plusvalías", "minusvalías", "ganancias realizadas", "base del ahorro", "retenciones fiscales", "declarar inversiones".
---

# IRPF — Declaración de la renta: inversiones

Calcula la base imponible del ahorro para la Agencia Tributaria española (AEAT) a partir de los datos de la cartera y el extracto IB.

## Marco fiscal español (IRPF 2025/2026)

### Tipo de renta: Base del ahorro
Tanto dividendos como plusvalías tributan en la **base del ahorro** (art. 46 LIRPF):

| Tramo base del ahorro | Tipo |
|-----------------------|:----:|
| Hasta 6.000 € | 19 % |
| 6.001 € – 50.000 € | 21 % |
| 50.001 € – 200.000 € | 23 % |
| 200.001 € – 300.000 € | 27 % |
| Más de 300.000 € | 28 % |

### Compensación de pérdidas
- Pérdidas por transmisión compensan ganancias por transmisión (sin límite)
- Exceso de pérdidas compensa rendimientos (dividendos) hasta el **25 %** de éstos
- Exceso no compensado: arrastra 4 años

### Conversión a EUR (tipo de cambio obligatorio)
- Usar el **tipo de cambio BCE** del día de la operación (compra y venta por separado)
- IB ya proporciona la base de coste en EUR en el extracto
- Para retenciones en origen: convertir al tipo del día del cobro

### Método FIFO (First In, First Out)
- Para acciones del mismo emisor: las primeras compradas son las primeras vendidas
- IB aplica FIFO por defecto, pero verificar si se ha configurado otro método

### Deducción por doble imposición internacional
- Las retenciones en origen (withholding tax de EEUU, UK, AU) son deducibles
- Límite: el menor entre la retención pagada y lo que correspondería tributar en España
- Convenio EEUU-España: retención máxima sobre dividendos = 15 % (10 % para holdings)
- Convenio UK-España: 10 % dividendos ordinarios
- Australia: retención máxima 15 %

## Pasos del skill

### 1. Recopilar datos del ejercicio

Leer de `inversiones/cartera/Cartera actual.md`:
- Tabla de posiciones cerradas (plusvalías/minusvalías realizadas)
- Movimientos recientes (operaciones del año)

Leer de `inversiones/dividendos/Calendario de dividendos.md`:
- Dividendos cobrados en el ejercicio con retenciones
- Calcular total bruto y retenciones en EUR

Si hay extractos CSV en `inversiones/extractos/`, leerlos para datos precisos.

### 2. Calcular ganancias/pérdidas patrimoniales

Para cada posición cerrada en el año:
```
Ganancia/pérdida = (Precio venta × Acciones × TC_venta) − (Precio coste × Acciones × TC_compra) − Comisiones
```

Clasificar:
- **C/P**: posición mantenida < 1 año → tributación normal en base ahorro
- **L/P**: posición mantenida ≥ 1 año → tributación normal en base ahorro (mismo tipo desde 2015)

Presentar tabla:
| Empresa | Ticker | Fecha compra | Fecha venta | Coste (€) | Venta (€) | Comisiones (€) | G/P (€) | Plazo |
|---------|--------|:------------:|:-----------:|----------:|----------:|:--------------:|--------:|:-----:|

### 3. Calcular rendimientos de capital mobiliario (dividendos)

Para cada dividendo cobrado:
```
Rendimiento neto = Dividendo bruto en EUR − Retención en origen (hasta 15 %)
```

> [!warning] PIL (Payment in Lieu)
> Los pagos "in lieu" (SYEP de IB) tributan igual que dividendos ordinarios según criterio AEAT, pero verificar con asesor fiscal.

### 4. Calcular compensación

```
Base imponible bruta = Σ ganancias realizadas + Σ dividendos brutos
Compensación = Σ minusvalías del año (hasta cubrir ganancias)
Exceso pérdidas → compensa dividendos hasta 25%
Base imponible neta = Base bruta − Compensaciones
```

### 5. Calcular deducción por doble imposición

Para cada país con convenio:
- EEUU: min(retención pagada, dividendo × 15 %)
- UK: min(retención pagada, dividendo × 10 %)
- Australia: min(retención pagada, dividendo × 15 %)
- Alemania/Francia/Países Bajos/España: según convenio específico

### 6. Estimar cuota a pagar

```
Cuota IRPF = Base imponible neta × Tipo(tramo)
Retenciones en España ya practicadas (IB no practica en IBIE) = 0
Deducción doble imposición = Σ retenciones extranjeras (con límite)
Cuota a ingresar = Cuota IRPF − Deducción doble imposición
```

### 7. Generar informe

Guardar en `inversiones/fiscal/YYYY_IRPF_inversiones.md`:

```markdown
---
title: "IRPF YYYY — Inversiones"
tags: [inversiones, fiscal, irpf]
ejercicio: YYYY
---

## Ganancias y pérdidas patrimoniales
[tabla de operaciones cerradas]

## Rendimientos de capital mobiliario
[tabla de dividendos]

## Resumen fiscal
| Concepto | Importe (€) |
|----------|------------:|
| Ganancias realizadas | |
| Minusvalías realizadas | |
| Resultado neto transmisiones | |
| Dividendos brutos | |
| Compensación pérdidas vs. dividendos | |
| Base imponible del ahorro | |
| Cuota estimada | |
| Deducción doble imposición | |
| **Cuota neta estimada** | |
```

## Datos clave de la cartera para IRPF 2026

Del extracto IB (enero–abril 2026):

**Ganancias realizadas totales:**
- Acciones C/P: +446,13 USD (≈ +387,46 €)
- Acciones L/P: +45,25 USD (≈ +39,30 €)
- Fórex: +24,25 USD C/P (≈ +21,07 €)

**Pérdidas realizadas:**
- Acciones C/P: −55,66 USD (≈ −48,34 €)
- Acciones L/P: 0
- **Resultado neto transmisiones (período): +447,35 USD (≈ +388,52 €)**

**Dividendos cobrados:** 523,19 € bruto (enero–marzo 2026)
**Retenciones en origen:** −55,88 €

> [!warning] Datos parciales
> Este cálculo solo cubre enero–abril 2026. Para la declaración anual, ejecutar `/irpf` en enero de 2027 con el extracto completo del ejercicio.

## Notas importantes

- IBIE (Interactive Brokers Ireland) **no practica retención española** — el contribuyente debe autoliquidar
- Guardar el extracto anual IB como justificante documental (mínimo 4 años)
- Los dividendos marcados como PIL pueden requerir consulta vinculante DGT para confirmar tratamiento
- Consejo: solicitar el **Informe fiscal de Interactive Brokers** (disponible en el portal bajo Tax → Tax Forms) que consolida los datos anuales
