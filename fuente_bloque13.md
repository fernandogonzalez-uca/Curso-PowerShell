# Código fuente Bloque XIII - Conversión a ejecutable #

**1 - El módulo PS2EXE**
```powershell
Install-Module -Name ps2exe -Scope CurrentUser
```

**2 - Conversión básica**
```powershell
Invoke-ps2exe -inputFile '.\PS2EXE_Ejemplos\01-HolaMundo\HolaMundo.ps1' -outputFile '.\PS2EXE_Ejemplos\01-HolaMundo\HolaMundo.exe'
```

```powershell
Invoke-ps2exe -inputFile ".\PS2EXE_Ejemplos\02-Parametros\ScriptConParametros.ps1" `
              -outputFile ".\PS2EXE_Ejemplos\02-Parametros\Saludador.exe"
```

```powershell
# Llamada al ejecutable
.\PS2EXE_Ejemplos\02-Parametros\Saludador.exe -Nombre "Fernando" -Veces 3
``` 


**3 - Ejecutables con (-noConsole)**
```powershell
Invoke-ps2exe -inputFile ".\PS2EXE_Ejemplos\03-Icono\ScriptConIcono.ps1" `
              -outputFile ".\PS2EXE_Ejemplos\03-Icono\HerramientaSilenciosa.exe" `
              -iconFile ".\PS2EXE_Ejemplos\03-Icono\icono_azul.ico" `
              -noConsole
```


**4 - Aplicación gráfica (Windows Forms)**
```powershell
Invoke-ps2exe -inputFile ".\PS2EXE_Ejemplos\04-GUI-WindowsForms\ScriptGUI.ps1" `
              -outputFile ".\PS2EXE_Ejemplos\04-GUI-WindowsForms\UtilidadEquipos.exe" `
              -iconFile ".\PS2EXE_Ejemplos\04-GUI-WindowsForms\icono_gui.ico" `
              -noConsole `
              -STA `
              -title "Utilidad de Equipos" `
              -product "Utilidad de Equipos - Curso PowerShell"
```

**5 - Metadatos completos, versión y elevación de privilegios**
```powershell
Invoke-ps2exe -inputFile ".\PS2EXE_Ejemplos\05-Metadatos-Completo\ScriptCompleto.ps1" `
              -outputFile ".\PS2EXE_Ejemplos\05-Metadatos-Completo\GestorSistema.exe" `
              -iconFile ".\PS2EXE_Ejemplos\05-Metadatos-Completo\icono_app.ico" `
              -requireAdmin `
              -title "Gestor del Sistema" `
              -description "Herramienta de mantenimiento para equipos del aula" `
              -company "Universidad - Curso de PowerShell" `
              -product "Gestor del Sistema" `
              -version "1.0.0.0" `
              -copyright "Material docente - Curso de PowerShell"
```

**6 - Firma digital: reducir los avisos de seguridad**
```powershell
$certificado = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
Set-AuthenticodeSignature -FilePath '.\MiScript.exe' -Certificate $certificado
```

