# Código fuente Bloque Addendum B - Importancia de la codificación en PowerShell

**Conversión a UTF con BOM**
```powershell

$origen = ".\AddendumB_Diagnostico_persistencia_O365.ps1"
$destino = ".\AddendumB_Diagnostico_persistencia_O365_UTF8BOM.ps1"

$contenido = Get-Content -Path $origen -Raw -Encoding UTF8

$utf8BOM = New-Object System.Text.UTF8Encoding($true)

[System.IO.File]::WriteAllText($destino, $contenido, $utf8BOM)

<#>
Nota importante: en Windows PowerShell 5.1, -Encoding UTF8 en Set-Content/Out-File escribe con BOM por defecto (al revés que en PS7, donde tendrías que forzar -Encoding utf8BOM)
#>
```