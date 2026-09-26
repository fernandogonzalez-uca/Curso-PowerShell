# ============================================================
# Diagnóstico de persistencia de sesión Microsoft 365 / Office
# No modifica credenciales ni configuración.
# ============================================================

$ErrorActionPreference = "SilentlyContinue"

$fecha = Get-Date -Format "yyyyMMdd_HHmmss"
$carpeta = "$env:USERPROFILE\Desktop\Diagnostico_Office_$fecha"

New-Item -Path $carpeta -ItemType Directory -Force | Out-Null

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " DIAGNÓSTICO MICROSOFT 365 / OFFICE" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------
# 1. Información básica del equipo
# ------------------------------------------------------------

Write-Host "[1/8] Información del equipo..." -ForegroundColor Yellow

Get-ComputerInfo |
    Select-Object `
        WindowsProductName,
        WindowsVersion,
        OsBuildNumber,
        CsName,
        CsDomain,
        CsPartOfDomain |
    Out-File "$carpeta\01_Equipo.txt" -Encoding UTF8

# ------------------------------------------------------------
# 2. Usuario actual
# ------------------------------------------------------------

Write-Host "[2/8] Usuario actual..." -ForegroundColor Yellow

@"
Usuario Windows : $env:USERNAME
Dominio         : $env:USERDOMAIN
UPN             : $env:USERDNSDOMAIN
Equipo          : $env:COMPUTERNAME
Fecha           : $(Get-Date)
"@ | Out-File "$carpeta\02_Usuario.txt" -Encoding UTF8

whoami /all |    Out-File "$carpeta\02_Whoami.txt" -Encoding UTF8

# ------------------------------------------------------------
# 3. Estado Microsoft Entra ID / Azure AD
# ------------------------------------------------------------

Write-Host "[3/8] Comprobando dsregcmd..." -ForegroundColor Yellow

dsregcmd /status |    Out-File "$carpeta\03_Dsregcmd.txt" -Encoding UTF8

# ------------------------------------------------------------
# 4. Comprobar Web Account Manager / AAD Broker
# ------------------------------------------------------------

Write-Host "[4/8] Componentes de autenticación Windows..." -ForegroundColor Yellow

Get-AppxPackage -AllUsers Microsoft.AAD.BrokerPlugin |    Select-Object Name, PackageFullName, Status |    Format-List |    Out-File "$carpeta\04_AAD_BrokerPlugin.txt" -Encoding UTF8

Get-AppxPackage -AllUsers Microsoft.AccountsControl |    Select-Object Name, PackageFullName, Status |    Format-List |    Out-File "$carpeta\04_AccountsControl.txt" -Encoding UTF8

# ------------------------------------------------------------
# 5. Credenciales almacenadas
# ------------------------------------------------------------

Write-Host "[5/8] Analizando credenciales almacenadas..." -ForegroundColor Yellow

cmdkey /list |    Out-File "$carpeta\05_Credenciales.txt" -Encoding UTF8

# ------------------------------------------------------------
# 6. Instalación/versiones de Office
# ------------------------------------------------------------

Write-Host "[6/8] Información de Office..." -ForegroundColor Yellow

$officePaths = @(
    "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
)

foreach ($path in $officePaths) {

    if (Test-Path $path) {

        Get-ItemProperty $path |
            Select-Object `
                ClientVersionToReport,
                VersionToReport,
                ProductReleaseIds,
                Platform,
                UpdateChannel |
            Format-List |
            Out-File "$carpeta\06_Office.txt" -Append -Encoding UTF8
    }
}

# ------------------------------------------------------------
# 7. Registro de cuentas de Windows
# ------------------------------------------------------------

Write-Host "[7/8] Registro de cuentas Windows..." -ForegroundColor Yellow

$regPaths = @(
    "HKCU:\Software\Microsoft\IdentityCRL",
    "HKCU:\Software\Microsoft\Office\16.0\Common\Identity",
    "HKCU:\Software\Microsoft\Office\16.0\Common\SignIn"
)

foreach ($path in $regPaths) {

    "`n===== $path =====" |
        Out-File "$carpeta\07_Registro_Identidad.txt" -Append -Encoding UTF8

    if (Test-Path $path) {

        Get-ItemProperty $path |
            Format-List * |
            Out-File "$carpeta\07_Registro_Identidad.txt" -Append -Encoding UTF8
    }
}

# ------------------------------------------------------------
# 8. Eventos recientes relacionados con autenticación
# ------------------------------------------------------------

Write-Host "[8/8] Buscando eventos de autenticación..." -ForegroundColor Yellow

$logs = @(
    "Microsoft-Windows-AAD/Operational",
    "Microsoft-Windows-User Device Registration/Admin"
)

foreach ($log in $logs) {

    try {

        Get-WinEvent -LogName $log -MaxEvents 100 |
            Where-Object {
                $_.LevelDisplayName -in @("Error","Warning")
            } |
            Select-Object TimeCreated, Id, LevelDisplayName, Message |
            Format-List |
            Out-File "$carpeta\08_Eventos_Autenticacion.txt" -Append -Encoding UTF8
    }
    catch {
        # El registro puede no existir en algunas versiones de Windows.
    }
}

# ------------------------------------------------------------
# Crear ZIP
# ------------------------------------------------------------

Write-Host ""
Write-Host "Generando archivo ZIP..." -ForegroundColor Yellow

$zip = "$env:USERPROFILE\Desktop\Diagnostico_Office_$fecha.zip"

Compress-Archive `
    -Path "$carpeta\*" `
    -DestinationPath $zip `
    -Force

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host " DIAGNÓSTICO FINALIZADO" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Carpeta:" -ForegroundColor Cyan
Write-Host $carpeta
Write-Host ""
Write-Host "ZIP:" -ForegroundColor Cyan
Write-Host $zip
Write-Host ""
Write-Host "No se ha modificado ninguna configuración."
Write-Host ""
