---
name: equipo-max
description: Orquesta un equipo de agentes de máxima calidad sin restricción de costo (todos con el mejor modelo y thinking alto) - jefe que investiga y planifica, constructores que implementan con pruebas, revisor independiente y verificación final. Usar cuando el usuario escriba /equipo-max o pida "la mejor calidad", "sin importar el costo" o "con el mejor modelo".
---

# Protocolo del Orquestador (calidad máxima)

Principio: **calidad por encima de costo**. Todos los agentes usan el mejor modelo (`Model: pro`).
Se gasta lo que haga falta en investigar, probar y revisar. Lo que no se hace es
saltarse verificaciones para ir más rápido.

| Agente | Modelo | Para qué |
|---|---|---|
| `jefe-max` | `pro` | Investigar, evaluar alternativas, planificar |
| `constructor-max` | `pro` | Implementar con pruebas y autoverificación |
| `revisor-max` | `pro` | Revisión independiente de cumplimiento y calidad |

## 0. Triage

- **Ambiguo** (falta información que cambia el diseño): pregunta al usuario **antes** de planificar.
- **Trivial** (1–2 archivos, sin decisiones): igual pasa por un constructor y un revisor; omite el jefe.
- **Normal**: flujo completo.

## 1. Preparar

- `<slug>` corto; crea `.equipo/<slug>/` con `tareas/`, `reportes/`, `revisiones/`.
- `PEDIDO.md` con el pedido textual. Si hay contexto relevante (stack, restricciones), inclúyelo.
- Marca el inicio del consumo: `python <scripts>/consumo.py --ahora` y anótalo en `PROGRESO.md`
  junto a la tabla `ID | estado | intentos | nota`.

## 2. Planificar → `jefe-max`

`invoke_subagent`: `TypeName: jefe-max`, `Model: pro`, `Workspace: inherit`:
> "Investiga y planifica `.equipo/<slug>/PEDIDO.md`. Escribe `PLAN.md` y las tarjetas en `.equipo/<slug>/tareas/`."

Si trae preguntas bloqueantes, pásalas al usuario. Si no, copia la tabla de tareas a `PROGRESO.md`.

## 3. Construir → `constructor-max` (por olas)

Todas las tareas de una ola en **una sola llamada** a `invoke_subagent`, un spec por tarea:
`TypeName: constructor-max`, `Model: pro`, `Role: <Enfoque de la tarjeta>`, `Workspace: inherit`,
`Prompt`: "Ejecuta `.equipo/<slug>/tareas/Txx.md`. Reporte en `.equipo/<slug>/reportes/Txx.md`."
La ola siguiente empieza con la actual aprobada. `BLOQUEADO` → paso 5.

## 4. Revisar → `revisor-max` (cada tarea)

Al terminar cada constructor: `TypeName: revisor-max`, `Model: pro`:
> "Revisa `Txx`: tarjeta `.equipo/<slug>/tareas/Txx.md`, reporte `.equipo/<slug>/reportes/Txx.md`. Escribe `.equipo/<slug>/revisiones/Txx.md`."

- `APROBADO` → marca hecha.
- `RECHAZADO` → `send_message` al **mismo** constructor (conserva contexto): "Corrige las desviaciones de
  `revisiones/Txx.md`." Y revisa de nuevo. Máximo **3 rechazos** por tarea.

## 5. Escalar

Tras 3 rechazos o un `BLOQUEADO`: `jefe-max` re-planifica solo esa tarea (reescribe o divide la tarjeta).
Si vuelve a fallar, detente y pregunta al usuario.

## 6. Cierre (obligatorio, no se omite)

1. **Revisión final**: `revisor-max` contra `PLAN.md`, con build/tests/lint de todo el proyecto → `revisiones/FINAL.md`.
2. **Revisión cruzada** (cambios delicados o grandes): segundo `revisor-max` con otro enfoque
   ("seguridad y casos borde" vs. "mantenibilidad y pruebas") revisando el diff completo.
3. Si algo falla, crea tareas de corrección (vía jefe si requieren diseño) y repite 3–4.
4. Genera el consumo: `python <scripts>/consumo.py --desde <inicio> --modelo-principal <tu modelo> --salida .equipo/<slug>/CONSUMO.md`.
5. Responde al usuario: qué se hizo, `git diff --stat`, resultado de verificación, reintentos, observaciones
   fuera de alcance reportadas por los constructores y, al final, la tabla de consumo tal cual la imprime el script.

Scripts: `.agents/skills/equipo-max/scripts/` (proyecto) o `~/.gemini/config/skills/equipo-max/scripts/` (global).

## Reglas

- **Siempre `Model: pro`** explícito en cada subagente (incluidos `browser` e investigación).
- Para implementar usa `constructor-max` con `Role`; no uses `self` ni `define_subagent`.
- Mensajes entre agentes = rutas + una línea; el detalle vive en `.equipo/`.
- Nunca des por cerrada una tarea sin revisión aprobada y verificación corrida de verdad.
- Mata (`manage_subagents`) a los constructores aprobados cuando ya no los necesites.
