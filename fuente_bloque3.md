# Código fuente Bloque I3 - 1: Scripts y entornos de seguridad

**Comandos esenciales**

**Para consultar la política**

```powershell
# Ver la política efectiva la que realmente se aplica.
Get-ExecutionPolicy

# Ver la política en TODOS los ámbitos, con su orden de precedencia.
Get-ExecutionPolicy -List
```

**Para cambiar la política**

```powershell
# Requiere permisos de administrador si el ámbito es LocalMachine.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Cambiar la política solo para el usuario actual, sin ser administrador.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Ejemplo de Unblock File**

```powershell
Unblock-File -Path .\script.ps1
```

**Mi primer script en ISE**

```powershell
# Mi primer script en PowerShell
Write-Host "Hola ATI de la UCA!!"
```

**Segundo script: variables e interacción con el usuario**
```powershell
# Script con variable e interacción con el usuario
<#
•   Toda variable en PowerShell se declara anteponiendo el símbolo $ (por ejemplo, $nombre).
•	Read-Host detiene la ejecución y espera a que el usuario escriba algo en la consola.
•	Dentro de una cadena de texto entre comillas dobles, el nombre de una variable se sustituye automáticamente por su valor (interpolación de cadenas); con comillas simples esto no ocurre.
#>

$nombre = Read-Host "¿Cómo te llamas?"
Write-Host "Bienvenido/a al curso de PowerShell, $nombre"
```

** Tercer script: Variables de entorno y aplicación a Sistemas**
```powershell
# Información básica del equipo
$equipo = $env:COMPUTERNAME
$fecha  = Get-Date
$fecha2 = Get-Date -Format "dd/MM/yyyy HH:mm:ss"


Write-Host "Este script se ha ejecutado en el equipo $equipo el $fecha"
Write-Host "Este script se ha ejecutado en el equipo $equipo el $fecha2"
```

