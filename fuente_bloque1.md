# Código fuente Bloque I1 - Introducción a PowerShell

**Ejemplos de Powershell 7**
```powershell
# Procesamiento masivo de equipos en paralelo
$servers | ForEach-Object -Parallel { Test-Connection -ComputerName $_ -Count 1 } -ThrottleLimit 20
```

```powershell
# En PowerShell 5.1 -peor rendimiento-
$servers | ForEach-Object { Test-Connection -ComputerName $_ -Count 1}
```

```powershell
New-Item -ItemType Directory -Path "C:\Logs" && Set-Location "C:\Logs"
# Intenta crear una carpeta y, si tiene éxito, entra en ella

Test-Connection -ComputerName "Servidor01" -Count 1 || Write-Warning "El servidor no responde"
# Intenta hacer un test de red y, si falla, muestra un aviso por consola
```

