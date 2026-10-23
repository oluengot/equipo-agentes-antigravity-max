---
trigger: model_decision
description: Aplicar cuando el usuario pida máxima calidad, "sin importar el costo" o use /equipo-max. Todo subagente usa el mejor modelo y nada se entrega sin verificación real.
---

# Calidad máxima

1. **Modelo**: todo subagente (`constructor-max`, `jefe-max`, `revisor-max`, `browser`, investigación)
   se invoca con `Model: pro` explícito. Nunca uses Flash para trabajo que importe.
2. **Divide con criterio**: en partes independientes, cada una a un `constructor-max` con su `Role`;
   archivos compartidos a una tarea de integración final.
3. **Investiga antes de tocar**: lee el código vecino, convenciones, tests existentes y corre la línea base.
4. **Prueba de verdad**: build, tests y lint corridos (no supuestos). Cambios de comportamiento llevan tests nuevos.
5. **Revisión independiente**: ningún trabajo delicado se cierra sin pasar por `revisor-max`.
6. **Lee completo cuando haga falta**: para entender bien, abre archivos enteros; no sacrifiques comprensión por ahorrar tokens.
7. **Cierre honesto**: informa qué se verificó, qué no, y los riesgos que quedan.

Para desarrollos con plan formal usa la skill `equipo-max` (`/equipo-max`).
