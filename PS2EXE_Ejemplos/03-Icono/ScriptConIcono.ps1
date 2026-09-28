<#
.SYNOPSIS
    Ejemplo 3 del módulo PS2EXE: icono personalizado y ejecución sin consola.

.DESCRIPTION
    Este script está pensado para convertirse con el parámetro -noConsole,
    por lo que NO debe depender de Write-Host para informar al usuario:
    al ocultar la consola, esos mensajes nunca se verían.

    En su lugar, el script:
      1) Escribe un registro (log) de lo que hace en un fichero de texto,
         guardado en la MISMA CARPETA donde se encuentra el ejecutable
         (o el propio .ps1, si se ejecuta sin convertir).
      2) Muestra un MessageBox de Windows al finalizar, para que el usuario
         sepa que el proceso ha terminado y dónde consultar el detalle.

    Este contraste (con consola vs. sin consola) es un punto pedagógico
    clave: -noConsole no "silencia" el script, simplemente oculta la
    ventana; sigue siendo responsabilidad del programador informar al
    usuario por otro medio.

    NOTA TÉCNICA: cuando PS2EXE compila el script, $PSScriptRoot y
    $MyInvocation.MyCommand.Path pasan a apuntar a la ubicación del propio
    .exe en ejecución (no a un .ps1 temporal), por lo que sirven tal cual
    para calcular "la carpeta del ejecutable". Aun así, se añade una
    comprobación adicional basada en el proceso en curso como red de
    seguridad, por si en algún entorno esas variables llegaran vacías.
#>

Add-Type -AssemblyName System.Windows.Forms

# Carpeta donde se encuentra el ejecutable (o el .ps1, si no se ha convertido)
if ($PSScriptRoot) {
    $carpetaLog = $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    $carpetaLog = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
} else {
    # Red de seguridad: carpeta del propio proceso en ejecución (el .exe)
    $carpetaLog = Split-Path -Path ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName) -Parent
}

$ficheroLog = Join-Path -Path $carpetaLog -ChildPath "ejemplo3-log.txt"

function Escribir-Log {
    param([string]$Mensaje)
    $linea = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Mensaje
    Add-Content -Path $ficheroLog -Value $linea
}

Escribir-Log "Inicio del proceso (Ejemplo 3 - PS2EXE)"
Escribir-Log "Usuario: $($env:USERNAME) - Equipo: $($env:COMPUTERNAME)"

# Simulación de una tarea que en un caso real podría ser más costosa
Start-Sleep -Seconds 1
Escribir-Log "Tarea de ejemplo completada correctamente"

[System.Windows.Forms.MessageBox]::Show(
    "El proceso ha finalizado correctamente.`n`nConsulta el detalle en:`n$ficheroLog",
    "Herramienta Silenciosa - Curso PowerShell",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
) | Out-Null

Escribir-Log "Fin del proceso"
