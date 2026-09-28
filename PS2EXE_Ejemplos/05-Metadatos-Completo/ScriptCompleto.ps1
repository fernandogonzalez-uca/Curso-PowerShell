<#
.SYNOPSIS
    Ejemplo 5 del módulo PS2EXE: metadatos completos y elevación de privilegios.

.DESCRIPTION
    Script pensado para convertirse "a producción": con título, descripción,
    empresa, producto, versión y copyright, y con -requireAdmin porque
    simula una tarea de mantenimiento que necesitaría privilegios elevados.

    El script comprueba y muestra si se está ejecutando realmente como
    administrador, para que el alumno pueda verificar en clase que
    -requireAdmin ha funcionado como se espera.
#>

function Test-EsAdministrador {
    $usuarioActual = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($usuarioActual)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-Host "=====================================================" -ForegroundColor Magenta
Write-Host " Gestor del Sistema - Ejemplo 5 (Curso PowerShell)" -ForegroundColor Magenta
Write-Host "=====================================================" -ForegroundColor Magenta
Write-Host ""

$esAdmin = Test-EsAdministrador
if ($esAdmin) {
    Write-Host "[OK] El proceso se está ejecutando con privilegios de administrador." -ForegroundColor Green
} else {
    Write-Host "[AVISO] El proceso NO tiene privilegios de administrador." -ForegroundColor Yellow
    Write-Host "        Si has convertido este script con -requireAdmin, revisa la conversión."
}

Write-Host ""
Write-Host "-- Tareas de mantenimiento simuladas --"
Write-Host "1. Comprobando espacio en disco..."
Start-Sleep -Milliseconds 500
$disco = Get-PSDrive -Name C -ErrorAction SilentlyContinue
if ($disco) {
    $libreGB = [math]::Round($disco.Free / 1GB, 2)
    Write-Host "   Espacio libre en C: $libreGB GB"
}

Write-Host "2. Comprobando fecha y hora del sistema..."
Start-Sleep -Milliseconds 500
Write-Host "   Fecha/hora actual: $(Get-Date)"

Write-Host ""
Write-Host "Tareas de ejemplo finalizadas." -ForegroundColor Cyan
Write-Host ""

Read-Host "Pulsa Intro para salir"
