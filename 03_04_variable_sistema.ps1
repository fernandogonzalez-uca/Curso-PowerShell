# Información básica del equipo
$equipo = $env:COMPUTERNAME
$fecha  = Get-Date
$fecha2 = Get-Date -Format "dd/MM/yyyy HH:mm:ss"


Write-Host "Este script se ha ejecutado en el equipo $equipo el $fecha"
Write-Host "Este script se ha ejecutado en el equipo $equipo el $fecha2"
