# Código fuente Bloque XIII - Conversión a ejecutable #

**1 - El módulo PS2EXE**
```powershell
Install-Module -Name ps2exe -Scope CurrentUser
```

**2 - Conversión básica**
```powershell
Invoke-ps2exe -inputFile '.\MiScript.ps1' -outputFile '.\MiScript.exe'
```

```powershell
Invoke-ps2exe `
    -inputFile '.\InformeEquipos.ps1' `
    -outputFile '.\InformeEquipos.exe' `
    -iconFile '.\icono.ico' `
    -title 'Informe de Equipos - UCA' `
    -description 'Genera un informe de archivos grandes en una carpeta' `
    -company 'Universidad de Cádiz' `
    -version '1.0.0.0'
```

**3 - Ejecutables con interfaz gráfica (-noConsole)**
```powershell
Add-Type -AssemblyName System.Windows.Forms

$formulario = New-Object System.Windows.Forms.Form
$formulario.Text = 'Preparación de equipo - UCA'
# ... controles del formulario (botones, etiquetas, campos de texto) ...
[void]$formulario.ShowDialog()
Invoke-ps2exe -inputFile '.\AsistentePreparacionEquipo.ps1' `
    -outputFile '.\AsistenteEquipo.exe' -noConsole
```


**4 - Ejecutables que requieran permisos de administrador**
```powershell
Invoke-ps2exe -inputFile '.\LimpiarTemp.ps1' -outputFile '.\LimpiarTemp.exe' -requireAdmin
```

**5 - Pasar parámetros al ejecutable ya generado**
```powershell
# Contenido de LimpiarTemp.ps1 antes de convertirlo:
param(
    [string]$Carpeta = 'C:\Temp'
)
Remove-Item -Path "$Carpeta\*" -Recurse -Force
# Una vez convertido, se invoca igual que cualquier otro programa de línea de comandos:
.\LimpiarTemp.exe -Carpeta 'D:\Temporal'
```

**6 - Firma digital: reducir los avisos de seguridad**
```powershell
$certificado = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
Set-AuthenticodeSignature -FilePath '.\MiScript.exe' -Certificate $certificado
```

