# Instala el equipo de agentes de MAXIMA CALIDAD (orquestador-max, jefe-max, constructor-max,
# revisor-max + skill /equipo-max) en Antigravity. Convive con el equipo economico (nombres distintos).
#
#   Global (todos los proyectos):  .\instalar.ps1
#   Solo un proyecto:              .\instalar.ps1 -Proyecto "C:\ruta\al\proyecto"

param(
    [string]$Proyecto
)

$ErrorActionPreference = 'Stop'
$origen = Join-Path $PSScriptRoot 'plantilla\.agents'

if ($Proyecto) {
    if (-not (Test-Path $Proyecto)) { throw "No existe la carpeta del proyecto: $Proyecto" }
    $destAgentes = Join-Path $Proyecto '.agents\agents'
    $destSkills  = Join-Path $Proyecto '.agents\skills'
    $destReglas  = Join-Path $Proyecto '.agents\rules'
} else {
    $base = Join-Path $HOME '.gemini\config'
    $destAgentes = Join-Path $base 'agents'
    $destSkills  = Join-Path $base 'skills'
    $destReglas  = Join-Path $base 'rules'
}

New-Item -ItemType Directory -Force $destAgentes, $destSkills, $destReglas | Out-Null
Copy-Item (Join-Path $origen 'agents\*.md') $destAgentes -Force
Copy-Item (Join-Path $origen 'skills\equipo-max') $destSkills -Recurse -Force
Copy-Item (Join-Path $origen 'rules\*.md') $destReglas -Force

Write-Host "Agentes instalados en: $destAgentes"
Write-Host "Skill /equipo-max instalada en: $destSkills\equipo-max"
Write-Host "Regla calidad-maxima instalada en: $destReglas"
if ($Proyecto) {
    Write-Host "Sugerencia: agrega '.equipo/' al .gitignore del proyecto."
}
Write-Host "Reinicia Antigravity (o abre una conversacion nueva) para que los detecte."
