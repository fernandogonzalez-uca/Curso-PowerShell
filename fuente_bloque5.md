# Código fuente Bloque V - Objetos, variables y pipelines *

**Objetos - Propiedades y métodos**
```powershell
# Obtención del valor asociado a propiedades y métodos de un objeto
# almacenado en una variable
Get-Process | Get-Member

Get-Process -Name notepad
# Obtendremos error ya que no tenemos abierto notepad.exe

Get-Process -Name notepad -ErrorAction SilentlyContinue
# Aunque no esté abierto notepad controlamos el error para que no muestre salida al respecto.

# Abrimos notepad.exe
$proceso = Get-Process -Name notepad

$proceso.Id            # Accede a una propiedad
$proceso.CPU           # Accede a otra propiedad
$proceso.Kill()        # Ejecuta un método: cierra el proceso

#Formas alternativas de matar el proceso
(Get-Process -Name notepad).kill() 

(Get-Process -Id 28936).Kill()
``` 


**Declaración de variables en modo asignación directa**
```powershell
$nombre = "Fernando"
${apellido1 apellido2} = "González Macías"
Write-Host "Mi nombre es: $nombre"
Write-Host "Mis apellidos son: ${apellido1 apellido2}"
Write-Host "Mi nombre completo es: $nombre ${apellido1 apellido2}"
```

**Variables - Declaración mediante cmdlet**
```powershell
# Variables - Declaración mediante cmdlet
New-Variable $nombre
New-Variable -Name $nombre
New-Variable -Name $nombre -Value "Isabel"

New-Variable -Name 'MaxIntentos' -Value 5 -Option ReadOnly
New-Variable -Name 'Departamento' -Value 'Sistemas' -Option Constant -Description 'No debe modificarse'
```

**Variables - Obtención de su tipo**
```powershell
$numero = 10
$numero.GetType().Name

$texto = "Cádiz"
$texto.GetType().Name

$fecha = Get-Date
$fecha.GetType().Name

$procesos = Get-Process
$procesos.GetType().Name
```


**Ejemplo de asignación de constante mediante Set-Varible**
```powershell

#Constante (Constant): Un valor fijo e inalterable.
#No se puede modificar ni eliminar durante toda la sesión.
Set-Variable -Name PI -Value 3.1416 -Option Constant

# Solo Lectura (ReadOnly): Impide cambios accidentales. No se puede modificar ni eliminar
# mediante asignación normal, pero se puede remover usando el flag -Force.

Set-Variable -Name RUTA_BASE -Value "C:\App" -Option ReadOnly

# Forma 1 de eliminación de la variable con opción ReadOnly
Remove-Variable -Name RUTA_BASE -Force

# Forma 2 de eliminación de la variable con opción ReadOnly
# Accediendo a la unidad virtual Variable: combinada con el parámetro -Force
# del cmdlet Remove-Item
Remove-Item -Path Variable:\RUTA_BASE -Force

```


**Ejemplo de asignación de constante mediante atributo ReadOnly() en la declaración**
```powershell
[ReadOnly()]$MI_PUERTO = 8080
```


**Asignación de valores a una variable en tiempo de ejecución**
```powershell
$nombre = Read-Host "¿Cual es tu nombre?"
Write-Host "Hola $nombre"
```

**Ejemplos de uso de pipeline**
```powershell
# Obtén los cinco procesos que más CPU consumen por orden de consumo y mostrando sólo
# su nombre y la CPU usada.
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
```

**Ejemplos de uso de pipeline aplicados al ámbito de Sistemas**
```powershell
# Servicios que deberían estar iniciados y no lo están
Get-Service |
    Where-Object { $_.Status -eq 'Stopped' } |
    Select-Object Name, DisplayName
```


**Los 5 archivos más pesados de una carpeta**
```powershell
Get-ChildItem -Path 'C:\Users\Public' -Recurse |
    Sort-Object Length -Descending |
    Select-Object -First 5 Name, Length
```

**Guardar un resultado en una variable para reutilizarlo**
```powershell
$topProcesos = Get-Process | Sort-Object CPU -Descending |
    Select-Object -First 5
$topProcesos | Format-Table Name, CPU -AutoSize
```


**Ejercicios slide V-16**
```powershell
# 1.	Ejecutar Get-Process | Get-Member y localizar la propiedad WorkingSet (memoria)
# y el método Kill().
Get-Process | Get-Member


#2. Comprobar la versión de PowerShell en uso consultando la variable
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

Get-Service | Where-Object { $_.Status -eq 'Running' } | Measure-Object
```



