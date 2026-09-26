$origen = ".\AddendumB_Diagnostico_persistencia_O365.ps1"
$destino = ".\AddendumB_Diagnostico_persistencia_O365_UTF8BOM.ps1"

$contenido = Get-Content -Path $origen -Raw -Encoding UTF8

$utf8BOM = New-Object System.Text.UTF8Encoding($true)

[System.IO.File]::WriteAllText($destino, $contenido, $utf8BOM)