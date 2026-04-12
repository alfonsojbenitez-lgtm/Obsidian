---
name: spark
description: Escanea las notas recientes del vault en busca de patrones emergentes, ideas recurrentes y conexiones no evidentes. No resume ni lista, sino que sintetiza: identifica los clusters que están formándose en tu pensamiento. Úsalo cuando quieras descubrir qué estás realmente pensando.
---

# Sintetizar ideas emergentes del vault

Cuando el usuario invoque `/spark`, analiza el vault para revelar patrones de pensamiento que quizás el usuario no ha visto explícitamente.

## Filosofía

No resumir. No listar notas. **Identificar qué está cristalizando.**

La diferencia es importante:
- Resumir = decir qué dice cada nota
- Sintetizar = decir qué patrón forman juntas

## Pasos

1. **Recopilar material reciente**
   - Lee notas diarias de los últimos 14 días en `notas-diarias/`
   - Lee notas de `proyectos/` modificadas recientemente
   - Busca notas sin clasificar o con tags como `#idea`, `#pendiente`, `#reflexión`

2. **Buscar clusters**
   Identifica grupos de ideas que aparecen en múltiples lugares:
   - Palabras o frases que se repiten
   - Problemas mencionados más de una vez
   - Preguntas sin responder que reaparecen
   - Conexiones entre proyectos aparentemente distintos

3. **Identificar tensiones**
   ¿Hay contradicciones entre notas? ¿Decisiones que se posponen? ¿Compromisos que chocan entre sí?

4. **Detectar lo que falta**
   ¿Qué tema importante no aparece en las notas aunque debería? ¿Qué proyecto no tiene nota?

## Formato de salida

```
## Spark — {{fecha}}

### Lo que está emergiendo
[2-4 párrafos describiendo los patrones. Menciona notas específicas con [[wikilinks]]
como evidencia, pero el foco es el patrón, no la nota.]

### Tensiones activas
- [Tensión o contradicción identificada]

### Preguntas sin responder
- ¿[Pregunta que aparece implícita o explícitamente en las notas]?

### Un hilo que vale la pena tirar
[Una sola sugerencia concreta de dónde enfocar energía, basada en los patrones encontrados]
```

## Restricciones

- Máximo 400 palabras en la salida
- No inventes conexiones que no están en las notas
- Si hay pocas notas recientes (<5), indícalo y trabaja con lo que hay
- No guardes el output en el vault a menos que el usuario lo pida explícitamente
- Cita siempre las notas de origen con `[[wikilinks]]`
