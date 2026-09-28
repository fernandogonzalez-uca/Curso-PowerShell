<#
.SYNOPSIS
    Ejemplo 1 del módulo PS2EXE: script minimo para demostrar el flujo completo
    de conversión de un .ps1 a un .exe.

.DESCRIPTION
    Este script no recibe parámetros y no requiere ninguna dependencia externa.
    Su único objetivo es servir de "hola mundo" para la primera conversión con
    PS2EXE, de forma que el alumno vea el proceso completo sin distracciones.
#>

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Módulo PS2EXE - Ejemplo 1: Hola Mundo" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este script se está ejecutando desde:"
if ($MyInvocation.MyCommand.Path) {
    Write-Host "  $($MyInvocation.MyCommand.Path)"
} else {
    Write-Host "  (ejecutándose ya como ejecutable generado por PS2EXE)"
}
Write-Host ""
Write-Host "Fecha y hora actual: $(Get-Date)"
Write-Host "Usuario actual     : $($env:USERNAME)"
Write-Host "Equipo             : $($env:COMPUTERNAME)"
Write-Host ""

# Mantiene la ventana abierta al ejecutar el .exe con doble clic
Read-Host "Pulsa Intro para salir"
