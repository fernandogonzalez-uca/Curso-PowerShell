# Código fuente Bloque XI - Cmdlets para Administradores #

**2 - Gestión de procesos **
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

Start-Process -FilePath 'notepad.exe'
Start-Process -FilePath 'powershell.exe' -Verb RunAs   # Como administrador

Stop-Process -Name 'notepad' -Force
```

**3 - Gestión de Servicios**
```powershell
Get-Service -Name 'Spooler'
Restart-Service -Name 'Spooler' -Force
Set-Service -Name 'Spooler' -StartupType Automatic
```

**4 - Información de Sistema y hardware con CIM**
```powershell
Get-CimInstance -ClassName Win32_OperatingSystem |
    Select-Object Caption, Version, LastBootUpTime

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" |
    Select-Object DeviceID,
        @{Name='LibreGB'; Expression={ [math]::Round($_.FreeSpace / 1GB, 2) }}
```

**5 - Comandos de red**
```powershell
Test-Connection -ComputerName 'PC-Aula01' -Count 2
Test-NetConnection -ComputerName 'SRV-DATOS' -Port 445
Get-NetIPConfiguration
Resolve-DnsName 'www.uca.es'
```


