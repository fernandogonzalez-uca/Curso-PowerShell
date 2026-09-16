# Código fuente Bloque VIII - Estructuras repetitivas (Bucles) #

**El bucle for**
```powershell
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Iteración número $i"
}
```

```powershell
for ($i = 1; $i -le 3; $i++) {
    Write-Host "Creando carpeta Aula$i"
    New-Item -Path "C:\Aulas\Aula$i" -ItemType Directory -Force | Out-Null
}
```

**El bucle for-each (statement)**

```powershell
$equipos = 'PC-Aula01', 'PC-Aula02', 'PC-Aula03'

foreach ($equipo in $equipos) {
    Write-Host "Comprobando $equipo"
}
```

**El cmdlet foreach-object**
```powershell
Get-Process | ForEach-Object {
    Write-Host "$($_.Name) está usando $($_.CPU) segundos de CPU"
}
```

**El bucle while**

```powershell
$intentos = 0

while ($intentos -lt 3) {
    Write-Host "Intento número $($intentos + 1)"
    $intentos++
}
```

**El bucle do while**
```powershell
do {
    Write-Host "Esperando a que el servicio Spooler arranque..."
    Start-Sleep -Seconds 2
} while ((Get-Service Spooler).Status -ne 'Running')
```

**El bucle do until**
```powershell
$numero = 0
do {
    $numero++
    Write-Host "Número actual: $numero"
} until ($numero -ge 5)
```

**Controlar un bucle desde dentro: break y continue**

```powershell
foreach ($numero in 1..10) {
    if ($numero -eq 5) { break }
    # al llegar a 5, sale del bucle por completo

    if ($numero % 2 -eq 0) { continue }
    # los pares se saltan, pero el bucle continúa

    Write-Host $numero
}
# Resultado: 1, 3  (se detiene del todo al llegar a 5, antes de imprimirlo)
```

**Etiquetas de bucle: controlar bucles anidados**
```powershell
:filas foreach ($fila in 1..3) {
    foreach ($columna in 1..3) {
        if ($columna -eq 2) { continue filas }
        Write-Host "Fila $fila, columna $columna"
    }
}
```

**For-Each --Parallel. A partir de PowerShell 7**

```powershell
$equipos = 'PC-Aula01', 'PC-Aula02', 'PC-Aula03', 'PC-Aula04'

$equipos | ForEach-Object -Parallel {
    $resultado = Test-Connection -ComputerName $_ -Count 1 -Quiet
    "$_ : $resultado"
} -ThrottleLimit 4
```

**Buen uso de los bucles: una trampa de rendimiento**

```powershell
# Poco eficiente: += crea un array COMPLETO nuevo en cada vuelta
$resultados = @()
foreach ($equipo in $listaGrandeDeEquipos) {
    $resultados += Test-Connection -ComputerName $equipo -Count 1 -Quiet
}
```

```powershell
# Preferible: se asigna directamente el resultado del bucle completo
$resultados = foreach ($equipo in $listaGrandeDeEquipos) {
    Test-Connection -ComputerName $equipo -Count 1 -Quiet
}
```

**Ejemplo integrador aplicado a Sistemas**

```powershell
$maxIntentos = 10
$intentos    = 0
$listo       = $false

while (-not $listo -and $intentos -lt $maxIntentos) {
    $intentos++
    $listo = Test-Connection -ComputerName 'SRV-DATOS' -Count 1 -Quiet
    if (-not $listo) { Start-Sleep -Seconds 5 }
}

if ($listo) {
    Write-Host "El servidor respondió tras $intentos intento(s)"
} else {
    Write-Host "El servidor no respondió tras $maxIntentos intentos"
}
```


