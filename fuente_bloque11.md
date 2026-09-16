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
# Los siguienes cmdlets los ejecutamos en cada equippo.

# Habilitar administración remota mediante PowerShell.

Enable-PSRemoting -Force
# Esto habilita/configura WinRM, crea las reglas de firewall correspondientes y prepara PowerShell Remoting.

Get-Service WinRM
# Verificamos si el servicio WinRM se está ejecutando

Get-Service Wingmt
# Idem para el servicio Wingmt

Get-NetFirewallRule -DisplayGroup "Windows Remote Management"
# Comprobamos el firewall


# Ahora desde cada equipo verificamos la conexión con el equipo remoto

# Comprobamos WinRM con:
Test-WSMan PC-AULA01

Get-CimInstance Win32_OperatingSystem -ComputerName 'PC-Aula01'
# Obtenemos versión del sistema operativo del eqiupo remoto.
# Esto funcionará si estamos ejecutando PowerShell con una cuenta que tiene permisos administrativos sobre el equipo remoto.
```

```powershell
# Solicitamos credenciales
$Cred = Get-Credential

Get-CimInstance Win32_OperatingSystem -ComputerName 'PC-Aula01'
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
Test-Connection -ComputerName 'PC-Aula01' -Count 2
Test-NetConnection -ComputerName 'SRV-DATOS' -Port 445
Get-NetIPConfiguration
Resolve-DnsName 'www.uca.es'
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
New-LocalUser -Name 'alumno' -Password $Password
# PowerShell solicitará la contraseña de forma segura y no la mostrará en pantalla..
```
```powershell
# Si queremos establecer directamente una contraseña concreta

$Password = ConvertTo-SecureString 'P@ssw0rd123' -AsPlainText -Force
New-LocalUser -Name 'alumno' -Password $Password
```


```powershell
# Podemos añadir información en la cuenta del usuario.

$Password = ConvertTo-SecureString 'P@ssw0rd123' -AsPlainText -Force
New-LocalUser `
    -Name 'alumno' `
    -Password $Password `
    -FullName 'Usuario Alumno' `
    -Description 'Cuenta de usuario del aula'
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


