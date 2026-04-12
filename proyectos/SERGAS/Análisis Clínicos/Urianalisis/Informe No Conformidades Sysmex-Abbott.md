---
title: "Informe de No Conformidades: Integración de la Cadena de Urianalisis Sysmex en la Cadena Robótica General del Laboratorio (Abbott)"
tags:
  - SERGAS
  - laboratorio
  - urianalisis
  - no-conformidades
  - calidad
  - Sysmex
  - Abbott
date: 2026-04-07
autor: "Alfonso Javier Benítez Estévez. Especialista en Análisis Clínicos"
servicio: "Servicio de Análisis Clínicos — Área Sanitaria de Santiago de Compostela y Barbanza"
estado: borrador
---

# Informe de No Conformidades: Integración de la Cadena de Urianalisis Sysmex en la Cadena Robótica General del Laboratorio (Abbott)

**Servicio:** Servicio de Análisis Clínicos — Área Sanitaria de Santiago de Compostela y Barbanza  
**Fecha:** 7 de abril de 2026  
**Elaborado por:** Alfonso Javier Benítez Estévez. Especialista en Análisis Clínicos  
**Dirigido a:** Dirección de Procesos de Soporte / Área Sanitaria de Santiago de Compostela y Barbanza
**Carácter:** Confidencial — Uso interno

---

## 1. Introducción y objeto del informe

El presente informe tiene por objeto documentar las no conformidades técnicas y organizativas derivadas de la integración forzada de la cadena de urianalisis de Sysmex en la cadena robótica general del laboratorio de Abbott. Su finalidad es proporcionar a la Dirección una base técnica y bibliográfica que fundamente la toma de decisiones respecto a la organización del flujo de trabajo del urianalisis en nuestro laboratorio.

### 1.1 Descripción de los sistemas implicados

**Cadena de urianalisis Sysmex** (sistema integrado, diseñado como unidad funcional autónoma):

| Módulo | Función |
|--------|---------|
| UC-3500 (×2) | Análisis automatizado de tira reactiva de orina (tecnología CMOS) |
| UF-5000 | Citometría de flujo fluorescente para sedimento urinario |
| UD-10 | Microscopia digital automatizada para revisión confirmativa |

Este sistema resuelve en un único paso el urianalisis completo —tira reactiva + sedimento urinario—, cubriendo desde el cribado inicial hasta la confirmación microscópica, con criterios de verificación algorítmica integrada [[1](#ref1),[2](#ref2)].

**Cadena robótica general Abbott** (plataforma de bioquímica e inmunoquímica de alto volumen): sistema de automatización total del laboratorio (TLA) con módulo de preanalítica, pistas magnéticas de transporte, módulos analíticos y almacenamiento posanalítico refrigerado. En nuestro caso concreto, también se ha integrado los estudios de hematimetría y velocidad de sedimentación globular, de coagulación, de fraccionamiento de las hemoglobinas glicadas, de alergía, etc, tanto los de caracter rutinario como los urgentes.

### 1.2 Contexto clínico: características especiales de la muestra de orina

A diferencia de la sangre y el suero, la orina es una muestra biológica intrínsecamente inestable:

- **Carece de sistemas tampón eficaces** (ausencia de proteínas, albúmina y glucosa en concentración significativa).
- **El pH y la osmolalidad pueden ser extremos**, lo que favorece la lisis celular y la degeneración morfológica de los elementos formes.
- **Los elementos celulares** (hematíes, leucocitos, células epiteliales renales, cilindros) carecen del entorno protector que proporciona el plasma. Su conservación morfológica es tiempo y temperatura-dependiente.

Estas características imponen requisitos preanalíticos radicalmente distintos a los de cualquier otra muestra del laboratorio y hacen que la integración en una cadena diseñada para muestras de suero/plasma genere incompatibilidades estructurales.

---

## 2. No conformidades identificadas

### NC-01 — Retraso en el procesamiento de la muestra de orina: cuellos de botella en la cadena Abbott

**Descripción:** La integración de la muestra de orina en la cadena robótica de Abbott impone tiempos de espera derivados de los cuellos de botella propios de una plataforma de alto volumen diseñada para sangre, suero y plasma. La orina queda en cola junto al resto de muestras, sin que se le haya otorgado una prioridad diferenciada.

**Impacto clínico-analítico:**

**a) Degradación de los elementos formes del sedimento urinario**

Los elementos formes de la orina —hematíes, leucocitos, células epiteliales renales, cilindros— son altamente susceptibles a la lisis y degeneración morfológica en función del tiempo transcurrido desde la micción. La orina carece de glucosa y proteínas en concentración suficiente para mantener la viabilidad celular. Los pH extremos (< 5,5 o > 7,5) y las osmolalidades extremas aceleran la lisis de hematíes y leucocitos, produciendo resultados falsamente negativos en el recuento de elementos formes [[3](#ref3),[4](#ref4)].

La literatura establece de forma consistente que el análisis del sedimento urinario debe realizarse preferiblemente en la primera hora tras la recogida de la muestra, y en todo caso antes de las 2 horas si la muestra se mantiene a temperatura ambiente. Los retrasos superiores a este umbral comprometen la validez de los resultados del sedimento urinario con independencia del sistema analítico empleado.

**b) Sobrecrecimiento bacteriano**

A temperatura ambiente, el crecimiento bacteriano progresa exponencialmente, modificando el pH de la orina y acelerando la degeneración celular. Esto interfiere con el recuento automatizado de bacterias del UF-5000 (parámetros BACT-info y flags grampositivo/gramnegativo), que ha demostrado una elevada fiabilidad en condiciones de procesamiento adecuadas [[5](#ref5)], pero cuya validez queda comprometida ante muestras con sobrecrecimiento bacteriano in vitro.

**c) Precipitación de cristales**

Los cambios de temperatura y el envejecimiento de la muestra favorecen la precipitación in vitro de cristales de oxalato cálcico, fosfatos amónicos magnésicos (estruvita) y uratos, según el pH de la muestra [[6](#ref6)]. Esto genera falsos positivos en la cristaluria, con el consiguiente riesgo de interpretaciones clínicas erróneas (diagnóstico incorrecto de litiasis renal o nefropatía por oxalatos).

**Clasificación:** No conformidad mayor — impacto directo sobre la calidad del resultado analítico.

---

### NC-02 — Sobrecarga del sistema de almacenamiento en frío de la cadena Abbott

**Descripción:** La inclusión de muestras de orina en el circuito de la cadena Abbott obliga a ampliar la capacidad del almacenamiento refrigerado posanalítico, ya que la orina debe conservarse en frío (4 °C) para ralentizar la degradación celular y el sobrecrecimiento bacteriano.

**Impacto organizativo:**

- Las muestras de orina representan un volumen diario entre 1000-1300 contenedores, lo que reduce la capacidad efectiva del almacenamiento posanalítico del resto de las muestras.
- La orina no puede almacenarse durante períodos prolongados sin riesgo de degeneración, a diferencia del suero o el plasma, que pueden mantenerse refrigerados para repetición de determinaciones durante días [[7](#ref7)].
- La saturación del almacenamiento posanalítico puede comprometer la disponibilidad de muestras de suero/plasma para repeticiones urgentes o pruebas adicionales. En nuestro caso, las muestras de orina se desechan a los 3 días, tiempo insuficiente para cubrir las necesidades asistenciales del fin de semana: las muestras recogidas el viernes quedan eliminadas el lunes, imposibilitando la repetición de determinaciones cuando el clínico lo requiere.

**Clasificación:** No conformidad menor/moderada — impacto organizativo y de capacidad.

---

### NC-03 — Necesidad de centrifugado externo de muestras de orina para determinaciones bioquímicas en Abbott

**Descripción:** Las determinaciones bioquímicas en orina (proteinuria, creatinina, sodio, potasio, osmolalidad, microalbuminuria, etc.) que se realizan en los módulos analíticos de Abbott requieren muestra sin partículas en suspensión. Sin embargo, la cadena Sysmex trabaja con orina sin centrifugar (análisis de sedimento en muestra nativa), por lo que las muestras destinadas a bioquímica deben ser centrifugadas. Por motivos que se desconoce, las muestras de orina para realizar procedimientos bioquímicos no pueden centrifugarse con las centrífugas integradas en la cadena de Abbott. Esto supone la manipulación manual de muestras por parte de los técnicos especialistas de laboratorio.

**Procedimiento actual (manual):**

1. Clasificación y expulsión de las muestras por el módulo IOM-6 de la cadena Abbott.
2. Retaponado manual del tubo.
3. Centrifugación en centrífugas externas a la cadena.
4. Destaponado manual del tubo centrifugado.
5. Reintroducción por el módulo IOM-6 de la cadena Abbott.

**Impacto clínico-organizativo:**

- Ruptura de la cadena de custodia automatizada, con riesgo de error de identificación de muestra en el proceso manual.
- Incremento del tiempo de respuesta (TAT) para las determinaciones bioquímicas en orina.
- Aumento de la carga de trabajo manual del personal técnico.
- Riesgo de exposición biológica del personal durante la manipulación de muestras abiertas.
- Incumplimiento del principio de automatización total del laboratorio (TLA) que persigue la cadena Abbott [[8](#ref8)].

**Clasificación:** No conformidad mayor — impacto sobre seguridad del paciente, seguridad del personal y calidad analítica.

---

### NC-04 — Fallos en la integración informática entre los sistemas de información de Sysmex y Abbott

**Descripción:** Los sistemas de información del middleware de Sysmex y el sistema de información del laboratorio (LIS) vinculado a la cadena Abbott no se integran correctamente. Como consecuencia:

**a)** Las incidencias registradas sobre muestras de orina (escasa cantidad, errores de lectura de etiquetas, errores de pipeteo, etc.) **no se transmiten al LIS**, y las peticiones aparecen como finalizadas cuando en realidad no lo están.

**b)** Las muestras bloqueadas por incidencias quedan retenidas en el sistema Sysmex, pero la cadena Abbott las considera como completadas. Transcurridos 3 días desde la recogida, estas muestras son sometidas a disposición final (eliminación) **sin haber sido procesadas ni informadas**, sin que se genere ninguna alerta en el LIS.

**Impacto clínico:**

- Resultados analíticos no disponibles para el clínico, con informes de petición marcados erróneamente como completados.
- Riesgo de demorar el diagnóstico de patologías urinarias urgentes (infecciones urinarias, nefropatías glomerulares, hematuria macroscópica).
- Ausencia de trazabilidad completa del resultado analítico, incumpliendo los requisitos de la norma ISO 15189.
- La literatura subraya que la interoperabilidad del middleware con el LIS es un requisito crítico de calidad en la automatización total del laboratorio [[8](#ref8)].

**Clasificación:** No conformidad crítica — impacto directo sobre la seguridad del paciente y el cumplimiento normativo.

---

### NC-05 — Ausencia de sistema de homogeneización adecuado para muestras de orina en la cadena Abbott

**Descripción:** La cadena robótica de Abbott está diseñada y optimizada para muestras de suero y plasma, cuya composición es relativamente homogénea. Las muestras de orina con alta celularidad (piurias intensas) o elevado contenido en mucina tienden a sedimentar con rapidez, formando gradientes de concentración dentro del tubo.

**Impacto analítico:**

- La pipeta de aspiración de la cadena Abbott tomará la muestra desde la parte superior del tubo, donde la concentración de elementos formes será menor que en el fondo, generando **falsos negativos en el recuento celular**.
- El sistema de homogeneización de la cadena Sysmex está específicamente diseñado para muestras de orina, con un protocolo de agitación suave que garantiza la resuspensión de los elementos formes antes de la aspiración sin provocar lisis celular adicional.
- Ni la cadena Sysmex ni la cadena Abbott poseen un sistema de homogeinización de las muestras ya sedimentadas que solucionen dicho problema [[2](#ref2)].

**Clasificación:** No conformidad mayor — impacto directo sobre la calidad analítica del sedimento.

---

### NC-06 — Riesgo para la seguridad del paciente por retraso en resultados urgentes

**Descripción:** Los retrasos acumulados por los cuellos de botella de la cadena Abbott, el procesamiento externo y los fallos de comunicación informática tienen un impacto diferencial sobre las solicitudes urgentes de urianalisis.

**Escenarios de riesgo clínico:**

- **Bacteriemia/urosepsis:** La detección precoz de bacteriuria masiva con gram-negativo (flags del UF-5000) es crítica en pacientes con sospecha de urosepsis. El UF-5000 ha demostrado alta sensibilidad y especificidad para la detección y orientación del germen en la infección urinaria [[5](#ref5)], pero este valor diagnóstico queda anulado si el TAT es inaceptable.
- **Hematuria macroscópica:** La diferenciación entre hematuria glomerular y no glomerular mediante el parámetro URD del UF-5000 [[9](#ref9)] pierde fiabilidad con muestras degradadas.
- **Urgencias pediátricas y nefrológicas:** En patologías que cursan con cilindros celulares (nefritis, síndrome nefrótico activo), el retraso en el procesamiento puede imposibilitar la detección de cilindros, que se disuelven rápidamente en pH alcalino.

**Clasificación:** No conformidad crítica — impacto directo sobre la seguridad del paciente.

---

### NC-07 — Riesgo de incumplimiento de los requisitos de acreditación ISO 15189 / ENAC

**Descripción:** La norma UNE-EN ISO 15189:2022(es) exige que el laboratorio garantice la estabilidad de las muestras durante todo el proceso preanalítico y analítico, y que los procedimientos documentados reflejen los tiempos máximos admisibles entre la recogida y el análisis para cada tipo de muestra.

**Aspectos potencialmente incumplidos:**

- **Cláusula 7.2 (Procesos preanalíticos):** No existe un procedimiento documentado que establezca el tiempo máximo admisible entre la recogida y el análisis de la orina en el contexto de la cadena Abbott, ni criterios de rechazo por degradación.
- **Cláusula 7.4 (Informe de resultados):** Los fallos de comunicación entre Sysmex y Abbott generan informes con estados por incidencias incorrectos, lo que incumple el requisito de trazabilidad completa del resultado.
- **Cláusula 8.7 (No conformidades):** La situación descrita constituye per se una serie de no conformidades que deben quedar documentadas en el sistema de gestión de calidad.

**Clasificación:** No conformidad mayor — riesgo de pérdida de acreditación ENAC.

---

### NC-08 — Incremento de la carga de trabajo manual y riesgo de error humano

**Descripción:** La integración forzada de la orina en la cadena Abbott requiere múltiples intervenciones manuales (retaponado, centrifugado externo, destaponado, reintroducción) que no existían en el flujo de trabajo autónomo de la cadena Sysmex.

**Impacto:**

- **Error de identificación de muestra:** Cada manipulación manual es una oportunidad de intercambio o pérdida de identificación, vertido accidental de la muestra, etc. Los sistemas automatizados reducen el error de identificación respecto al trabajo manual en una proporción estimada de 10:1.
- **Aumento del tiempo de respuesta (TAT):** El centrifugado externo añade entre 10 y 20 minutos al TAT de cada muestra de orina que requiera bioquímica.
- **Exposición biológica:** La manipulación de muestras abiertas en el proceso de retaponado/destaponado incrementa el riesgo de exposición a material biológico potencialmente infeccioso (ITU por gérmenes multirresistentes, hepatitis B/C).
- **Ineficiencia organizativa:** Se pierde el principal beneficio de la automatización total —la reducción del tiempo de trabajo manual—, documentado en la literatura como uno de los objetivos primarios de los sistemas TLA [[8](#ref8)].

**Clasificación:** No conformidad moderada — impacto sobre eficiencia, seguridad laboral y riesgo de error.

---

## 3. Resumen de no conformidades

| N.º | No conformidad | Clasificación | Impacto principal |
|-----|---------------|---------------|-------------------|
| NC-01 | Retrasos en procesamiento — degradación de muestra | **Mayor** | Calidad analítica |
| NC-02 | Sobrecarga almacenamiento en frío | Menor/Moderada | Organización |
| NC-03 | Centrifugado externo para bioquímica en orina | **Mayor** | Seguridad / TAT |
| NC-04 | Fallos integración informática Sysmex-Abbott | **Crítica** | Seguridad del paciente |
| NC-05 | Ausencia de homogeneización adecuada | **Mayor** | Calidad analítica |
| NC-06 | Retraso en resultados urgentes | **Crítica** | Seguridad del paciente |
| NC-07 | Riesgo incumplimiento ISO 15189 / ENAC | **Mayor** | Acreditación |
| NC-08 | Incremento trabajo manual — error humano | Moderada | Seguridad laboral / TAT |

---

## 4. Propuestas de mejora y recomendaciones

### 4.1 Recomendación principal: segregación del flujo de orina

La medida más eficiente desde el punto de vista técnico es **mantener la cadena Sysmex como circuito independiente y autónomo** para el procesamiento de orina, desvinculándola de la cadena Abbott. Esta configuración es la que corresponde al diseño original de ambos fabricantes y la que garantiza:

- Procesamiento inmediato de la muestra de orina tras su recepción.
- Ausencia de cuellos de botella.
- Homogeneización específica para orina.
- Integración directa con el LIS mediante el middleware propio de Sysmex.

### 4.2 Si la integración es ineludible: medidas de mitigación

En caso de que la integración deba mantenerse por razones organizativas o de espacio, se proponen las siguientes medidas de mitigación, con carácter de mínimos:

1. **Priorización absoluta de muestras de orina** en la cola de la cadena Abbott, con un carril dedicado o tiempo máximo de espera de 30 minutos desde la recepción.
2. **Establecimiento de criterios documentados de tiempo máximo** entre recogida y análisis (≤ 1 hora a temperatura ambiente; ≤ 4 horas a 4 °C) y protocolo de rechazo de muestras fuera de especificación.
3. **Instalación de una centrifuga integrada en la cadena** para las muestras de orina destinadas a bioquímica, eliminando el proceso manual externo.
4. **Instalación de una nevera integrada en la cadena** para aumentar la capacidad de almacenamiento en frío y ampliar el tiempo de conservación de las muestras de orina de 3 a 4 días. El intervalo de viernes a lunes equivale a 3 días, lo que provoca que muestras recogidas el viernes ya estén eliminadas el lunes cuando surge la necesidad de repetir alguna determinación. Un mínimo de 4 días garantizaría la disponibilidad de la muestra durante todo el fin de semana.
5. **Resolución urgente de los fallos de integración informática** entre Sysmex y Abbott, con participación del proveedor de middleware, garantizando la transmisión de incidencias al LIS y la generación de alertas automáticas para muestras no procesadas.
6. **Validación del sistema de homogeneización** de la cadena Abbott para muestras de orina o incorporación de un módulo de mezcla específico antes de la aspiración.
7. **Documentación de la situación como no conformidad** en el sistema de gestión de calidad del laboratorio, con apertura de acciones correctivas para NC-04, NC-06 y NC-07.

### 4.3 Consideraciones sobre la implementación de criterios de verificación inteligente

La literatura reciente demuestra que los sistemas de verificación automática (autoverificación) basados en reglas de revisión mejoran significativamente el rendimiento diagnóstico de la cadena integrada Sysmex UC-3500/UF-5000 [[2](#ref2)], aumentando la especificidad para leucocitos y hematíes e incrementando la fiabilidad de los resultados de cilindros y células tubulares renales. Estos criterios de verificación están diseñados para el sistema integrado y **no son trasladables al entorno de la cadena Abbott**.

---

## 5. Conclusiones

La integración forzada de la cadena de urianalisis Sysmex (UC-3500/UF-5000/UD-10) en la cadena robótica general del laboratorio de Abbott genera ocho no conformidades documentadas, dos de ellas de carácter crítico por su impacto directo sobre la seguridad del paciente. La causa raíz de la mayoría de estas no conformidades reside en la incompatibilidad de diseño entre un sistema específicamente concebido para la muestra de orina y una plataforma de automatización total diseñada para muestras de suero y plasma.

La recomendación técnica desde la Unidad de Líquidos Biológicos siempre ha sido la **segregación de los flujos de trabajo**, manteniendo la cadena Sysmex como unidad funcional autónoma ubicada dónde se instaló inicialmente y como fue presentado el proyecto original de Abbott. Este consistía en instalar un clasificador-destaponador dedicado junto a la cadena Sysmex, para detectar incidencias, clasificar las muestras y destaponarlas. Según se vayan recibiendo las muestras de orina desde los puntos de extracción periféricos se trasladarán estas lo antes posible para comenzar con su procesamiento. Una vez finalizado el análisis en la cadena de Sysmex, las muestras o bien se archivarán en la cámara refrigerada anexa a la Unidad o bien se trasladarán a la cadena para la realización de las determinaciones bioquímicas pertinentes.

En tanto no sea posible implementar la solución propuesta, se propone la adopción inmediata de las medidas de mitigación descritas en el apartado 4.2, con especial urgencia para la resolución de los fallos de integración informática (NC-04) y el establecimiento de criterios documentados de tiempo máximo de procesamiento (NC-07).

Se solicita a la Dirección que este informe quede registrado en el sistema de gestión de calidad del Hospital y que se inicie el procedimiento de apertura de acciones correctivas correspondiente.

---

## 6. Bibliografía

<a name="ref1"></a>
**[1]** Chen Y, Zhang Z, Lin Z, Wu Y, Zhao Y, Wang G, Jing J. Sysmex UF-5000 Automatic Urine Sediment Analyzer Can Improve the Accuracy of Epithelial Cell Detection. *Ann Clin Lab Sci.* 2021;51(4):562-569. PMID: 34452897.

<a name="ref2"></a>
**[2]** Oyaert M, Maghari S, Speeckaert M, Delanghe J. Improving clinical performance of urine sediment analysis by implementation of intelligent verification criteria. *Clin Chem Lab Med.* 2022;60(11):1772-1779. [DOI: 10.1515/cclm-2022-0617](https://doi.org/10.1515/cclm-2022-0617). PMID: 36069776.

<a name="ref3"></a>
**[3]** Tanaka S, Murakami K, Sakatani T et al. Effects of Different Voided Urine Sample Storage Time, Temperature, and Preservatives on Analysis with Multiplex Bead-Based Oncuria Bladder Cancer Immunoassay. *Diagnostics (Basel).* 2025;15(2):138. [DOI: 10.3390/diagnostics15020138](https://doi.org/10.3390/diagnostics15020138). PMID: 39857022.

<a name="ref4"></a>
**[4]** Herrington W, Illingworth N, Staplin N et al. Effect of Processing Delay and Storage Conditions on Urine Albumin-to-Creatinine Ratio. *Clin J Am Soc Nephrol.* 2016;11(10):1794-1801. [DOI: 10.2215/CJN.13341215](https://doi.org/10.2215/CJN.13341215). PMID: 27654930.

<a name="ref5"></a>
**[5]** Enko D, Stelzer I, Böckl M et al. Comparison of the reliability of Gram-negative and Gram-positive flags of the Sysmex UF-5000 with manual Gram stain and urine culture results. *Clin Chem Lab Med.* 2021;59(3):619-624. [DOI: 10.1515/cclm-2020-1263](https://doi.org/10.1515/cclm-2020-1263). PMID: 33068381.

<a name="ref6"></a>
**[6]** Albasan H, Lulich JP, Osborne CA et al. Effects of storage time and temperature on pH, specific gravity, and crystal formation in urine samples from dogs and cats. *J Am Vet Med Assoc.* 2003;222(2):176-9. [DOI: 10.2460/javma.2003.222.176](https://doi.org/10.2460/javma.2003.222.176). PMID: 12555980.

<a name="ref7"></a>
**[7]** Bezuidenhout K, Rensburg MA, Hudson CL, Essack Y, Davids MR. The influence of storage time and temperature on the measurement of serum, plasma and urine osmolality. *Ann Clin Biochem.* 2016;53(Pt 4):452-8. [DOI: 10.1177/0004563215602028](https://doi.org/10.1177/0004563215602028). PMID: 26462927.

<a name="ref8"></a>
**[8]** Armbruster DA, Overcash DR, Reyes J. Clinical Chemistry Laboratory Automation in the 21st Century — Amat Victoria curam. *Clin Biochem Rev.* 2014;35(3):143-53. PMID: 25336760.

<a name="ref9"></a>
**[9]** Cho H, Yoo J, Kim H et al. Diagnostic Characteristics of Urinary Red Blood Cell Distribution Incorporated in UF-5000 for Differentiation of Glomerular and Non-Glomerular Hematuria. *Ann Lab Med.* 2022;42(2):160-168. [DOI: 10.3343/alm.2022.42.2.160](https://doi.org/10.3343/alm.2022.42.2.160). PMID: 34635609.

---
