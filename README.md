# Equipo de agentes de máxima calidad para Antigravity

Variante de [`Equipo Agentes Antigravity`](../Equipo%20Agentes%20Antigravity/README.md) donde **el
costo no importa**: todos los agentes usan el mejor modelo (`pro` = Gemini 4 Argon) con thinking alto,
y el flujo agrega investigación profunda, pruebas obligatorias y revisión independiente.

## Equipo

```
Usuario
  └─ ORQUESTADOR-MAX (selector: Gemini 4 Argon · High)
       ├─ JEFE-MAX         pro → investiga, compara alternativas, plan + tarjetas + plan de pruebas
       ├─ CONSTRUCTOR-MAX  pro → implementa con casos borde, tests y autoverificación (paralelo por olas)
       └─ REVISOR-MAX      pro → revisión independiente: cumplimiento + calidad + intento adversarial
```

Flujo: triage → jefe investiga y planifica → constructores por olas → revisor por tarea
(hasta 3 rechazos, luego re-plan del jefe) → revisión final → revisión cruzada opcional
(seguridad/casos borde vs. mantenibilidad/pruebas) → resumen de consumo.

## Diferencias con la versión económica

| Aspecto | Económica (`/equipo`) | Máxima calidad (`/equipo-max`) |
|---|---|---|
| Constructores | Flash | **Pro** |
| Supervisor / revisor | Hereda (medio) | **Pro**, revisa también calidad y seguridad |
| Jefe | Pro, explora lo justo | Pro, investiga a fondo y compara alternativas |
| Tarjetas | Cerradas, "sin pensar" | Contrato claro + libertad de implementación |
| Pruebas | Opcional | Tarea de pruebas obligatoria |
| Rechazos por tarea | 2 | 3 |
| Cierre | Revisión final | Revisión final + cruzada si es delicado |
| Reglas de ahorro de contexto | Siempre activas | No se instalan (se lee completo si hace falta) |

Los nombres son distintos (`*-max`), así que ambos equipos conviven sin pisarse.

## Costo orientativo

Pro/Argon ($2/$10 por MTok hasta 30-nov-2026, $4/$20 desde el 1-dic). Un desarrollo mediano con este
equipo cuesta del orden de 3–6× el equipo económico. Se mide con `consumo.py` (se imprime al cierre).

## Archivos

| Archivo | Qué es |
|---|---|
| `plantilla/.agents/agents/*-max.md` | Orquestador, jefe, constructor y revisor |
| `plantilla/.agents/skills/equipo-max/` | Skill `/equipo-max` + `consumo.py` + `precios.json` |
| `plantilla/.agents/rules/calidad-maxima.md` | Regla (a demanda) que fuerza `Model: pro` y verificación real |
| `instalar.ps1` | Instala global (`~/.gemini/config`) o en un proyecto (`-Proyecto`) |

## Instalar y usar

```bash
powershell -ExecutionPolicy Bypass -File "C:/Users/oluengo/Desarrollos Cloude/Equipo Agentes Antigravity Max/instalar.ps1"
```

En Antigravity: elige **Gemini 4 Argon · High** en el selector, y escribe `/equipo-max <pedido>`
o "usa el equipo de máxima calidad". Seguimiento en `.equipo/<slug>/`.
