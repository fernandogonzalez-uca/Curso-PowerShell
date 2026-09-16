# Código fuente Bloque VI - Tipos de datos y operadores

**Cómo obtener el tipo de una variable**

```powershell
$nombre = Read-Host "¿Cuál es tu nombre?"
Write-Host "El tipo de la variables $nombre es: $nombre.GetType.Name"
```

**Definición implícita de variables**

```powershell
$nombre = "Javier"
Write-Host $nombre.GetType().Name
# A la variable $nombre se le asigna el tipo string.

$precio = 5.99
Write-Host $precio.GetType().Name
# A la variable $precio se le asigna el tipo double.

$precio = "tomate"
Write-Host $precio.GetType().Name
# Ahora $precio es de tipo string.
# Como a la variable $precio no le hemos especificado de que tipo será, se adapta al valor
# asignado, es dinámica y por tanto puede cambiar de tipo.
```

**Ejemplos de definiciones explícitas de variables**

```powershell
$temperatura = 37.50
# En modo implícito $temperatura será una variable double(64 bits)

[float] $temperatura = 37.50
# En modo explícito será una variable float (32 bits). Más apropiada por su tamaño.
```

**Ejemplo de cambio del valor de una constante**

```powershell
New-Variable -Name $nombre -Value "Luisa" -Option ReadOnly
$nombre = "Pepe"

#Esto producirá un error.
```


**Ejemplo de strings multilíneas -here-strings-
```powershell
$mensaje = @"
Estimado usuario,
Su equipo se reiniciará esta noche por mantenimiento.
Departamento de Sistemas - UCA
"@
```

**Ejemplos de métodos y operadores más usados con strings**

```powershell
"cadiz".ToUpper()

"  hola  ".Trim()

"aula1".Replace('1','2')

"Sistemas".Contains('sis') 
"Sistemas".Contains('Sis')

$mi_array = "a,b,c".Split(',')
$mi_array.GetType().Name

$temp = "Hola"
$temp.GetType().Name

"Cádiz".Length

$mi_cadena = @('a','b','c') -join '-' 
$mi_cadena.GetType().Name
```


**Truncamiento en división entre enteros**
```powershell
10 / 3          # 3.33333333333333  (double, NO se trunca como en C o Java)
[int](10 / 3)   # 3  (al forzar el tipo [int], se trunca la parte decimal)
```


**Ejemplo de booleanos**
```powershell
if ("false") {
    Write-Host "Esto SÍ se ejecuta"
} else {
    Write-Host "Esto NO se ejecuta"
}
# La cadena no está vacía, así que se evalúa como $true

if ("") {
    Write-Host "Esto SÍ se ejecuta"
} else {
    Write-Host "Esto NO se ejecuta"
}
# La cadena está vacía, así que se evalúa como false
```


** Variables fecha y hora (DateTime)**

```powershell
$hoy = Get-Date
$hoy.Year          # Año, como número
$hoy.DayOfWeek     # Día de la semana
$hoy.AddDays(7)    # Una nueva fecha, 7 días después
$hoy.ToString("dd/MM/yyyy")   # Formateada como texto
```
```powershell
$inicio = Get-Date "01/01/2026"
$fin    = Get-Date
($fin - $inicio).Days     # Número de días transcurridos
```

**Arrays**

**Crear un array**
```powershell
$equipos = @('PC-Aula01', 'PC-Aula02', 'PC-Aula03')
$vacio   = @()                 # Array vacío, para ir rellenando después
$numeros = 1..10               # Operador de rango: array del 1 al 10
```

**Acceder a elementos**
```powershell
$equipos[0]        # 'PC-Aula01'  (primer elemento, índice 0)
$equipos[-1]       # 'PC-Aula03'  (último elemento, índice negativo)
$equipos[0..1]     # 'PC-Aula01', 'PC-Aula02'  (un rango de elementos)
$equipos.Count     # 3  (número de elementos)
```

**Añadir y quitar elementos**
```powershell
$equipos += 'PC-Aula04'                      # Añadir un elemento
$equipos = $equipos | Where-Object { $_ -ne 'PC-Aula02' }   # "Quitar" un elemento
```


**Recorrer un array**
```powershell
foreach ($equipo in $equipos) {
    Write-Host "Revisando $equipo"
}
```

**Arrays con un tipo concreto**
```powershell
[int[]] $edades = @(25, 30, 45)
[string[]] $nombres = @('Ana', 'Luis', 'Marta')
```

**Crear una hashtable**
```powershell
$equipo = @{
    Nombre  = 'PC-Aula01'
    IP      = '10.10.5.20'
    Estado  = 'Activo'
}
```


**Acceder y modificar valores**
```powershell
$equipo.Nombre           # 'PC-Aula01'   (notación con punto)
$equipo['IP']            # '10.10.5.20'  (notación con corchetes, útil si la clave es una variable)
$equipo.Estado = 'En mantenimiento'   # Modificar un valor existente
```

**Añadir y quitar claves**
```powershell
$equipo.Add('Ubicacion', 'Aula 3')     # Añadir una nueva clave
$equipo.Remove('Estado')               # Eliminar una clave existente
```

**Recorrer una hashtable**
```powershell
foreach ($clave in $equipo.Keys) {
    Write-Host "$clave -> $($equipo[$clave])"
}

<#
$equipo.Keys da acceso a todos los nombres de clave, y $equipo.Values a todos los valores, sin emparejar.
Para recorrer ambos a la vez (clave y valor juntos) el patrón foreach ($clave in $equipo.Keys) de arriba es el más habitual y claro para quien empieza.
#>
```


**Hashtables ordenadas**
```powershell
$equipoOrdenado = [ordered]@{
    Nombre = 'PC-Aula01'
    IP     = '10.10.5.20'
    Estado = 'Activo'
}
# Nos aseguramos de mantener las claves exactamente en este orden.
# Si no se especifican por defecto son modificadas en su creación.
```

**Leer valores -acceso a los datos-**
```powershell
# Obtener la IP usando el punto
$laIP = $equipoOrdenado.IP

# Obtener el Estado usando corchetes (útil si la clave está en otra variable)
$elEstado = $equipoOrdenado['Estado']
```

**Añadir nuevas propiedades (Clave-Valor)**
```powershell
# Si queremos agregar más características al equipo, como el sistema operativo o la memoria RAM.
# Método 1: Notación de punto directa
$equipoOrdenado.SO = 'Windows 11'

# Método 2: Usando el método .Add()
$equipoOrdenado.Add('RAM', '16GB')
```

**Modificar un valor existente**
```powershell
# Si el equipo cambia de dirección de red o se apaga puedes actualizar su valor como sigue.

$equipoOrdenado.IP = '10.10.5.25'
$equipoOrdenado.Estado = 'Inactivo'
```


**Eliminar una propiedad**
```powershell
# Si ya no necesitas hacer el seguimiento de una clave en concreto, utiliza el método. Remove():
$equipoOrdenado.Remove('Estado')
```

**Comprobar si existe una clave o un valor**
```powershell
# Comprobar si existe la clave 'MacAddress'
if ($equipoOrdenado.Contains('MacAddress')) { "Ya tiene MAC" }

# Comprobar si la IP '10.10.5.20' está asignada a alguna de las propiedades
if ($equipoOrdenado.ContainsValue('10.10.5.20')) { "Esa IP está registrada" }
```

**Recorrer la hashtable**
```powershell
# Recorrer la Hashtable (Bucles)Para iterar por todos los elementos de la tabla hash de
# forma ordenada, se suele recorrer su colección de claves (.Keys):
foreach ($propiedad in $equipoOrdenado.Keys) {
    Write-Host "La propiedad '$propiedad' tiene el valor: $($equipoOrdenado[$propiedad])"
}
``` 
**Convertir hashtable a objeto (PSCustomObject)**
```powershell
# El uso más común de una hashtable ordenada en PowerShell es servir de molde para crear
# un objeto real. Esto te permite exportarlo a un CSV, mostrarlo en una tabla perfecta o
# pasarlo por tuberías (|):

# Convertir a objeto real
$objetoEquipo = [PSCustomObject]$equipoOrdenado

# Ahora puedes enviarlo a un archivo CSV directamente
$objetoEquipo | Export-Csv -Path "C:\datos\equipo.csv" -NoTypeInformation

```





**Ejemplo integrador: un array de hashtables**
```powershell
$inventario = @(
    @{ Nombre = 'PC-Aula01'; Estado = 'Activo' },
    @{ Nombre = 'PC-Aula02'; Estado = 'Baja' },
    @{ Nombre = 'PC-Aula03'; Estado = 'Activo' }
)

foreach ($equipo in $inventario) {
    if ($equipo.Estado -eq 'Activo') {
        Write-Host "$($equipo.Nombre) está operativo"
    }
}
```






**Conversión de tipos (Casting)**

```powershell
[int]"10" + 5   # 15   ("10" se convierte a número antes de sumar)
"10" + 5         # "105" (sin conversión, PowerShell concatena texto)
[string]123 + "€"   # "123€"
```

**Casting. Ejemplo**

```powershell
$fecha = "3/10/2010"
Write-Host $fecha

# Si no le decimos nada se almacenará como string.

[datetime] $fecha = "3/10/2010"
Write-Host $fecha.GetType().Name

$fecha = [datetime] "3/10/2010"
Write-Host $fecha.GetType().Name

# En estos casos la variable $fecha será de tipo datetime.

Write-host $fecha
```


**Ejemplo combinado de operadores aritméticos**

```powershell
$equiposTotales = 23
$capacidadAula  = 5

$aulasCompletas = [int]($equiposTotales / $capacidadAula)   # 4 aulas completas
$equiposSueltos = $equiposTotales % $capacidadAula          # 3 equipos sobran

Write-Host "Se necesitan $aulasCompletas aulas completas y sobran $equiposSueltos equipos"
```

**Ejemplos aplicados a Sistemas**

***Comprobar si un equipo lleva muchos días encendido***

```powershell
$arranque = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$diasEncendido = (Get-Date) - $arranque
if ($diasEncendido.Days -gt 15) {
    Write-Host "Aviso: el equipo lleva $($diasEncendido.Days) días sin reiniciarse" 
} else {
    Write-Host "Aviso: el qequipo lleva sólo $(diasEncendido.Days) días encendidos"
}


```

***Comprobar el espacio libre en disco con un umbral***
```powershell
$disco = Get-PSDrive C
$libreGB = [math]::Round($disco.Free / 1GB, 2)

if ($libreGB -lt 10) {
    Write-Host "Espacio libre bajo: $libreGB GB"
} else {
    $uptime = Get-Uptime
    Write-Host "El espacio es suficiente ($libreGB GB)."
    Write-Host "El equipo lleva encendido: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos y $($uptime.Seconds) segundos."
}

```



