---
title: "GALIAT — Framework clo-author"
tags:
  - proyecto
  - GALIAT
  - IA
  - clo-author
  - investigación
status: activo
creado: 2026-04-07
proyecto-padre: "[[GALIAT]]"
---

# GALIAT — Framework clo-author

> [!info] Proyecto padre
> Este documento pertenece a [[GALIAT]]. Describe el entorno de investigación instalado en `C:\Users\alfon\GALIAT\`.

---

## ¿Qué es clo-author?

**clo-author** es un framework de investigación académica para Claude Code, adaptado del repositorio [hugosantanna/clo-author](https://github.com/hugosantanna/clo-author). Automatiza el pipeline completo de un artículo científico: desde la revisión de literatura hasta la preparación del paquete de replicación.

Está instalado en:

```
C:\Users\alfon\GALIAT\
```

> [!tip] Cómo abrirlo
> Abre **Claude Code** y navega a `C:\Users\alfon\GALIAT\` o ábrelo directamente como carpeta de trabajo. Claude cargará el `CLAUDE.md` automáticamente al iniciar la sesión.

---

## Comandos disponibles

| Comando | Para qué sirve |
|---------|---------------|
| `/discover interview` | Especificar la pregunta de investigación de forma guiada |
| `/discover lit [tema]` | Revisión de literatura (PubMed, Cochrane, cadenas de citas) |
| `/discover data [tema]` | Identificar fuentes de datos con grado de viabilidad |
| `/strategize [pregunta]` | Diseñar la estrategia estadística |
| `/strategize pap` | Generar plan de análisis previo (PAP) para OSF/PROSPERO |
| `/analyze [dataset]` | Pipeline completo de análisis en R |
| `/write [sección]` | Redactar secciones del manuscrito |
| `/review [archivo]` | Revisión interna de calidad |
| `/review [archivo] --peer [revista]` | Simular revisión por pares de una revista concreta |
| `/revise [informe]` | Gestionar respuesta a revisores (R&R) |
| `/talk create [modo]` | Crear presentación en Quarto RevealJS |
| `/submit target` | Recomendar revistas objetivo |
| `/submit final [revista]` | Paquete de replicación + puerta de calidad final |
| `/tools context` | Estado actual del proyecto |
| `/tools validate-bib` | Verificar integridad de la bibliografía |

---

## Pipeline de investigación

```
/discover → /strategize → /analyze → /write → /review → /submit
```

Cada fase tiene una **puerta de calidad** (score mínimo) antes de avanzar:

| Puerta | Score mínimo |
|--------|-------------|
| Commit | ≥ 80 / 100 |
| Revisión | ≥ 90 / 100 |
| Envío a revista | ≥ 95 / 100 (todos los componentes ≥ 80) |

---

## Estado actual del subproyecto Huella hídrica

> [!success] Discovery completado — 2026-04-07
> Se ha completado el `/discover interview`. La especificación de investigación está guardada en:
> `C:\Users\alfon\GALIAT\quality_reports\plans\research_spec.md`

### Pregunta de investigación

> ¿Una intervención basada en la Dieta Atlántica (ensayo GALIAT, NCT02391701) reduce la **huella hídrica** de la dieta de los participantes?

### Decisiones clave tomadas

- **Diseño:** Análisis secundario del dataset GALIAT 2014-2015 (N = 574, 250 familias)
- **Referencia:** Cambeses-Franco et al., *JAMA Network Open* 2024 (PMID 38324314) — mismos métodos aplicados al carbono
- **Modelo:** Mixed-effects linear model · familia como efecto aleatorio
- **Hipótesis:** Resultado nulo esperado (consistente con la huella de carbono)
- **Software:** Stata 16 / R (lme4 + mice)

### Próximo paso

```
/strategize pap
```

Generará el plan de análisis previo (PAP) para registro en OSF o PROSPERO. **Requiere aprobación del equipo** (Alfonso + Dra. Calvo + Gude) de la research spec antes de ejecutarlo.

---

## Estructura de archivos del proyecto

```
C:\Users\alfon\GALIAT\
├── CLAUDE.md                          ← Configuración del proyecto
├── MEMORY.md                          ← Memoria persistente entre sesiones
├── CHANGELOG.md                       ← Registro de actividad
├── Bibliography_base.bib              ← Bibliografía centralizada
├── .claude/
│   ├── skills/                        ← 10 comandos /discover /write /analyze...
│   ├── rules/                         ← Gobernanza, calidad, workflow
│   └── references/
│       ├── domain-profile.md          ← Perfil de campo (nutrición clínica/bioestadística)
│       └── journal-profiles.md        ← Revistas objetivo (AJCN, Clin Nutr, Nutrients...)
├── data/raw/                          ← Datos originales (nunca modificar)
├── data/cleaned/                      ← Datasets procesados (.rds)
├── scripts/                           ← Scripts R de análisis
├── paper/                             ← Manuscrito Quarto
└── quality_reports/
    ├── plans/research_spec.md         ← ✅ Especificación de investigación
    └── reviews/                       ← Informes de revisión
```

---

## Relacionado

- [[GALIAT]] — proyecto padre
- [[GALIAT - Huella hídrica]] — notas del subproyecto
- [[GALIAT - Bibliografía]] — publicaciones del ensayo
- [[GALIAT - Ficha del ensayo]] — diseño, participantes, variables
