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


```powershell
# Solicitamos credenciales
$Cred = Get-Credential

Get-CimInstance Win32_OperatingSystem -ComputerName 'ADCAS4XX'
```



```powershell
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName "PC-AULA01" |
    Select-Object Caption, Version, LastBootUpTime

Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName "192.168.1.25" |
    Select-Object Caption, Version, LastBootUpTime
```

```powershell
Get-CimInstance -ClassName Win32_LogicalDisk `
    -ComputerName "PC-AULA01" `
    -Filter "DeviceID='C:'" |
    Select-Object DeviceID,
        @{Name='LibreGB'; Expression={
            [math]::Round($_.FreeSpace / 1GB, 2)
        }}
``` 

```powershell
Get-CimInstance -ClassName Win32_LogicalDisk `
    -ComputerName "192.168.1.25" `
    -Filter "DeviceID='C:'" |
    Select-Object DeviceID,
        @{Name='LibreGB'; Expression={
            [math]::Round($_.FreeSpace / 1GB, 2)
        }}
```


**5 - Comandos de red**
```powershell
# Envía 2 solicitudes de eco ICMP (ping) al equipo nasai1.uca.es y muestra el resultado de cada respuesta.
Test-Connection -ComputerName 'nasai1.uca.es' -Count 2

# Comprueba si desde tu equipo se puede abrir una conexión TCP al puerto 445 (SMB)
Test-NetConnection -ComputerName 'nasai1.uca.es' -Port 445

# Muestra un resumen de la configuración de red de cada interfaz del equipo.
# Similar a ipconfig /all
Get-NetIPConfiguration

# Hace una consulta DNS para el nombre www.uca.es y devuelve los registros que obtiene.
# Equivalente a nslookup
Resolve-DnsName 'www.uca.es'
```

```powershell
# Averiguar IP del adaptador físico de LAN
(Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' -and $_.PhysicalMediaType -eq '802.3' } |
    Get-NetIPAddress -AddressFamily IPv4).IPAddress
```

```powershell
# Averiguar velocidad de enlace de la red física
Get-NetAdapter -Physical |
    Where-Object { $_.Status -eq 'Up' -and $_.PhysicalMediaType -eq '802.3' } |
    Select-Object Name, LinkSpeed
```


**6 - Usuarios y grupos locales**
```powershell
Get-LocalUser
Get-LocalGroupMember -Group 'Administradores'

New-LocalUser -Name 'alumno' -NoPassword
Add-LocalGroupMember -Group 'Administradores' -Member 'alumno'
```

```powershell
$Password = Read-Host "Introduzca la contraseña" -AsSecureString
New-LocalUser -Name 'alumno2' -Password $Password
# PowerShell solicitará la contraseña de forma segura y no la mostrará en pantalla..
```
```powershell
# Si queremos establecer directamente una contraseña concreta

$Password = ConvertTo-SecureString 'P@ssw0rd123' -AsPlainText -Force
New-LocalUser -Name 'alumno3' -Password $Password
```


```powershell
# Podemos añadir información en la cuenta del usuario.

$Password = ConvertTo-SecureString 'P@ssw0rd123' -AsPlainText -Force
New-LocalUser `
    -Name 'alumno4' `
    -Password $Password `
    -FullName 'Usuario Alumno' `
    -Description 'Cuenta de usuario del aula'
```

```powershell
# Eliminamos las cuatro cuentas de usuarios creadas
Remove-LocalUser -Name 'alumno' -WhatIf
Remove-LocalUser -Name 'alumno' -Confirm
Remove-LocalUser -Name 'alumno2'
Remove-LocalUser -Name 'alumno3'
Remove-LocalUser -Name 'alumno4'
``` 


**7 - Active Directory**
```powershell
Import-Module ActiveDirectory

Get-ADUser -Filter "Department -eq 'Sistemas'"
Get-ADComputer -Filter * -SearchBase 'OU=AulasInformatica,DC=uca,DC=es'
```

**8 - Acceso y ejecución remota: PowerShell Remoting**
```powershell
Enable-PSRemoting -Force

# PowerShell Remoting está pensado, por defecto, para equipos unidos a un dominio (usa
# Kerberos para autenticar). En equipos en grupo de trabajo, hay que autorizar
# explícitamente a qué equipos se va a conectar, añadiéndolos a la lista de “hosts de
# confianza” en el equipo desde el que se lanza el comando.

Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'PC-Aula01,PC-Aula02' -Force
# Para todo el aula, con comodín (usar con precaución):
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*' -Force

# Además, sin dominio, hace falta indicar siempre una credencial local válida en el equipo de destino:

$credencial = Get-Credential
# Pide usuario y contraseña de forma interactiva y segura

Invoke-Command -ComputerName 'PC-Aula01', 'PC-Aula02' `
    -Credential $credencial -ScriptBlock {
    Get-Service -Name 'Spooler'
}
```

** Sesión interactiva con Enter-PSSession**
```powershell
Enter-PSSession -ComputerName 'SRV-DATOS' -Credential 'ADMIN\fmacias'
# El símbolo del sistema cambia para indicar que ya se está "dentro" del equipo remoto
Get-Service -Name 'Spooler'
Exit-PSSession
```

**Sesión persistente con New-PSSession**
```powershell
$sesion = New-PSSession -ComputerName 'SRV-DATOS' -Credential $credencial

Invoke-Command -Session $sesion -ScriptBlock { Get-Process }
Invoke-Command -Session $sesion -ScriptBlock { Get-Service }

Remove-PSSession $sesion
```

**9 - Reiniciar y apagar equipos**
```powershell
Restart-Computer -ComputerName 'PC-Aula01' -Force
Stop-Computer -ComputerName 'PC-Aula01' -Force
```

**10 - Ejemplo integrador: monitor de un aula**
```powershell
$equipos    = 'PC-Aula01', 'PC-Aula02', 'PC-Aula03'
$credencial = Get-Credential

$resultado = Invoke-Command -ComputerName $equipos `
    -Credential $credencial -ScriptBlock {
    $disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    [PSCustomObject]@{
        EspacioLibreGB = [math]::Round($disco.FreeSpace / 1GB, 2)
        SpoolerActivo  = (Get-Service Spooler).Status -eq 'Running'
    }
}

$resultado | Format-Table PSComputerName, EspacioLibreGB, SpoolerActivo -AutoSize
```


