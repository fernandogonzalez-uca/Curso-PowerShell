# Código fuente Bloque Addendum B - Importancia de la codificación en PowerShell

**Conversión a UTF con BOM**
```powershell
# Desde la propia consola -en ambas, 5.1 o 7.x es soportado-.
$contenido = Get-Content -Path ".\Diagnostico_persistencia_O365.ps1" -Raw -Encoding UTF8
Set-Content -Path ".\Diagnostico_persistencia_O365.ps1" -Value $contenido -Encoding UTF8

<#>
Nota importante: en Windows PowerShell 5.1, -Encoding UTF8 en Set-Content/Out-File escribe con BOM por defecto (al revés que en PS7, donde tendrías que forzar -Encoding utf8BOM)
#>
```