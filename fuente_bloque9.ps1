# Ejemplo 1 - Uso de $PSScriptRootGet

$rutaDatos = Join-Path -Path $PSScriptRoot -ChildPath 'Temp\informe.csv'

Write-Host "Ruta completa : $rutaDatos"
Write-Host "Carpeta       : $(Split-Path -Path $rutaDatos -Parent)"
Write-Host "Archivo       : $(Split-Path -Path $rutaDatos -Leaf)"

Write-Host "El valor de `$PSScriptRoot es $PSScriptRoot"

Write-Host "La ExecutionPolicy activa en la sesión es:"
Get-ExecutionPolicy

