#Declaración de variables en modo implícito.

$nombre = "Fernando"
${apellido1 apellido2} = "González Macías"
Write-Host "Mi nombre es: $nombre"
Write-Host "Mis apellidos son: ${apellido1 apellido2}"
Write-Host "Mi nombre completo es: $nombre ${apellido1 apellido2}"

# Obtención del valor asociado a propiedades y métodos de un objeto
# almacenado en una variable
$proceso = Get-Process -Name notepad
$proceso.Id            # Accede a una propiedad
$proceso.CPU           # Accede a otra propiedad
$proceso.Kill()        # Ejecuta un método: cierra el proceso


#Declaración de variables en modo explícito
New-Variable $nombre
New-Variable -Name $nombre
New-Variable -Name $nombre -Value "Isabel"

# Ejemplo de asignación de constante mediante Set-Varible

# Constante (Constant): Un valor fijo e inalterable.
# No se puede modificar ni eliminar durante toda la sesión.
Set-Variable -Name PI -Value 3.1416 -Option Constant

# Solo Lectura (ReadOnly): Impide cambios accidentales. No se puede modificar ni eliminar
# mediante asignación normal, pero se puede remover usando el flag -Force.

Set-Variable -Name RUTA_BASE -Value "C:\App" -Option ReadOnly


# Ejemplo de asignación de constante mediante atributo ReadOnly() en la declaración

[ReadOnly()]$MI_PUERTO = 8080


#Asignación de valores a una variable en tiempo de ejecución
$nombre = Read-Host "¿Cual es tu nombre?"
Write-Host "Hola $nombre"


# Ejemplos de uso de pipeline
# Obtén los cinco procesos que más CPU consumen por orden de consumo y mostrando sólo
# su nombre y la CPU usada.
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU

# Ejemplos de uso de pipeline aplicados al ámbito de Sistemas
# Servicios que deberían estar iniciados y no lo están
Get-Service |
    Where-Object { $_.Status -eq 'Stopped' } |
    Select-Object Name, DisplayName


# Los 5 archivos más pesados de una carpeta
Get-ChildItem -Path 'C:\Users\Public' -Recurse |
    Sort-Object Length -Descending |
    Select-Object -First 5 Name, Length

# Guardar un resultado en una variable para reutilizarlo
$topProcesos = Get-Process | Sort-Object CPU -Descending |
    Select-Object -First 5
$topProcesos | Format-Table Name, CPU -AutoSize


# Ejercicios slide V-16

# 1.	Ejecutar Get-Process | Get-Member y localizar la propiedad WorkingSet (memoria)
# y el método Kill().
Get-Process | Get-Member

# 2.	Comprobar la versión de PowerShell en uso consultando la variable
# automática $PSVersionTable.
$PSVersionTable

# 3.    Construir un pipeline propio que muestre los 5 procesos que más memoria
# consumen (WorkingSet), mostrando solo las propiedades Name y WorkingSet.
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, WorkingSet

# 4.    Guarda el resultado en una variable $TopMemoria

$TopMemoria = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, WorkingSet


# 5.    A partir de $topMemoria, filtrar con Where-Object los procesos 
# cuyo nombre contenga la letra “e”. (Pista: $_.Name -like '*e*').

$topMemoria | Where-Object { $_.Name -like '*e*' }
$topMemoria | Where-Object Name -like '*e*'


# 6.    Contar cuántos servicios del equipo están actualmente en estado “Running”
# usando Measure-Object.

Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object
