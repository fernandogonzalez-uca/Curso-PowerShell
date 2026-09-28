<#
.SYNOPSIS
    Ejemplo 2 del módulo PS2EXE: script con parámetros de entrada.

.DESCRIPTION
    Demuestra que el ejecutable generado por PS2EXE admite parámetros de
    línea de comandos exactamente igual que el script .ps1 original,
    incluyendo tipado y valores por defecto.

.PARAMETER Nombre
    Nombre de la persona a saludar.

.PARAMETER Veces
    Número de veces que se repite el saludo. Por defecto, 1.

.EXAMPLE
    .\ScriptConParametros.ps1 -Nombre "Fernando" -Veces 3

.EXAMPLE
    Saludador.exe -Nombre "Fernando" -Veces 3
#>

param(
    [Parameter(Mandatory = $true, HelpMessage = "Nombre de la persona a saludar")]
    [string]$Nombre,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 20)]
    [int]$Veces = 1
)

Write-Host "==============================================" -ForegroundColor Green
Write-Host " Módulo PS2EXE - Ejemplo 2: Parámetros" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host ""

for ($i = 1; $i -le $Veces; $i++) {
    Write-Host "[$i/$Veces] ¡Hola, $Nombre! Este saludo viene de un ejecutable generado con PS2EXE."
}

Write-Host ""
Write-Host "Consejo: prueba a ejecutar el .exe sin parámetros para ver el mensaje de error"
Write-Host "         que PowerShell genera automáticamente al faltar un parámetro obligatorio."
Write-Host ""

Read-Host "Pulsa Intro para salir"
