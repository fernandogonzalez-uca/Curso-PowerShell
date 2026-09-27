# Código fuente Bloque VII - Estructuras de control de flujo #

**If simple**
```powershell
$espacioLibreGB = 8

if ($espacioLibreGB -lt 10) {
    Write-Host "Aviso: queda poco espacio en disco ($espacioLibreGB GB)"
}
```

**If / else**
```powershell
if ($espacioLibreGB -lt 10) {
    Write-Host "Aviso: queda poco espacio en disco"
} else {
    Write-Host "Espacio en disco correcto"
}
```

**If / ElseIf / Else (varias condiciones encadenadas)**
```powershell
$edad = 20

if ($edad -lt 18) {
    Write-Host "Menor de edad"
} elseif ($edad -lt 65) {
    Write-Host "Adulto"
} else {
    Write-Host "Jubilado"
}
```

**Combinar condiciones con operadores lógicos**
```powershell
$cpu = 92
$ram = 88

if (($cpu -gt 90) -and ($ram -gt 85)) {
    Write-Host "Alerta: el equipo está bajo carga alta de forma sostenida"
}
```

**If anidadados. Cuando evitarlos**

```powershell
# Forma poco recomendable: if anidados para comparar un mismo valor
$estado = "Baja"
if ($estado -eq 'Activo') {
    Write-Host 'Equipo activo'
} else {
    if ($estado -eq 'Mantenimiento') {
        Write-Host 'Equipo en mantenimiento'
    } else {
        if ($estado -eq 'Baja') {
            Write-Host 'Equipo dado de baja'
        }
    }
}
```

**Swtich: Sintáxis básica**
```powershell
$estado = 'Mantenimiento'

switch ($estado) {
    'Activo'        { Write-Host 'Equipo activo' }
    'Mantenimiento' { Write-Host 'Equipo en mantenimiento' }
    'Baja'          { Write-Host 'Equipo dado de baja' }
    default         { Write-Host 'Estado no reconocido' }
}
```

**Varios valores para un mismo caso**
```powershell
$diasemana = 'Domingo'
switch ($diaSemana) {
    { $_ -in 'Sábado', 'Domingo' } { Write-Host 'Fin de semana' }
    default                        { Write-Host 'Día laborable' }
}
```

**Switch con comodines y expresiones regulares**
```powershell
$nombreEquipo = 'SRV-UCA01'
switch -Wildcard ($nombreEquipo) {
    'PC-Aula*' { Write-Host 'Equipo de aula' }
    'SRV-*'    { Write-Host 'Servidor' }
    default    { Write-Host 'Equipo sin clasificar' }
}
```

```powershell
$usuario = "admin01"

switch -Regex ($usuario) {
    "^admin"  { "Es un administrador" }
    "^alumno" { "Es un alumno" }
    "^prof"   { "Es un profesor" }
    default   { "Usuario desconocido" }
}
#El ^ significa comienzo por...
```

```powershell
$equipo = "JER-AULA-PC023"

switch -Regex ($equipo) {
    "^CAD-AULA-PC\d+$" {
        "Equipo de aula de Cádiz"
    }

    "^PR-AULA-PC\d+$" {
        "Equipo de aula de Puerto Real"
    }

    "^JER-AULA-PC\d+$" {
        "Equipo de aula de Jerez"
    }

    "^ALG-AULA-PC\d+$" {
        "Equipo de aula de Algeciras"
    }

    default {
        "Equipo no identificado"
    }
}
```

**Switch con condiciones (rangos y expresiones)**
```powershell
$nota = 6.8
switch ($nota) {
    { $_ -ge 9 } { Write-Host 'Sobresaliente' }
    { $_ -ge 7 } { Write-Host 'Notable' }
    { $_ -ge 5 } { Write-Host 'Aprobado' }
    default      { Write-Host 'Suspenso' }
}
```
```powershell
$numero = 10
switch ($numero) {
    {$_ -gt 5}  { Write-Host "Es mayor que 5" }
    10          { Write-Host "Es exactamente 10" }
    {$_ -lt 20} { Write-Host "Es menor que 20" }
}
```

```powershell
$numero = 4
switch ($numero) {
    { $_ % 2 -eq 0 } { Write-Host "$numero es par" }
    { $_ -gt 3 }     { Write-Host "$numero es mayor que 3" }
}
# Se muestran AMBOS mensajes, porque ambas condiciones son ciertas para 4
```

```powershell
switch ($numero) {
    { $_ % 2 -eq 0 } { Write-Host "$numero es par"; break }
    { $_ -gt 3 }     { Write-Host "$numero es mayor que 3"; break }
}
# Ahora solo se muestra el primer mensaje que coincide
```


```powershell
switch ($nota) {

    { $_ -ge 9 } {
        Write-Host 'Sobresaliente'
        break
    }

    { $_ -ge 7 } {
        Write-Host 'Notable'
        break
    }

    { $_ -ge 5 } {
        Write-Host 'Aprobado'
        break
    }

    default {
        Write-Host 'Suspenso'
    }
}
```


**Swtich sobre un array**
```powershell
$codigos = 1, 2, 5, 9

switch ($codigos) {
    1       { Write-Host 'Código 1: inicio' }
    5       { Write-Host 'Código 5: aviso' }
    default { Write-Host "Código $_: sin descripción" }
}
# Se ejecuta una vez por cada elemento del array
```


**Operador ternario (?). Válido a partir de PowerShell 7**
```powershell
# Con if / else (funciona en todas las versiones)
$edad = 25
if ($edad -ge 18) { $mensaje = 'Mayor de edad' } else { $mensaje = 'Menor de edad' }
Write-Host $mensaje

# La misma lógica con el operador ternario (solo PowerShell 7+)
$edad = 15
$mensaje = $edad -ge 18 ? 'Mayor de edad' : 'Menor de edad'
Write-Host $mensaje
```

**Operador ?? y ||. Válido a partir de PowerShell 7**
```powershell
# La segunda instrucción se ejecutará siempre independientemente del resultado de la primera.
New-Item -Path "C:\Temp\Prueba" -ItemType Directory
Write-Host "Directorio creado correctamente"

# De esta forma nos aseguramos de que se ejecute el segundo cmdlet sólo si el primero SÍ terminó correctamente.
New-Item -Path "C:\Temp\Prueba" -ItemType Directory && Write-Host "Directorio creado correctamente"

# Ejecuta el segundo comando SOLO SI el primero NO terminó correctamente.
New-Item -Path "C:\Temp\Prueba" -ItemType Directory || Write-Host 'La carpeta C:\Temp\Prueba ya existe'

# && y || juntos
ping 192.168.1.1 && Write-Host "OK" || Write-Host "ERROR"
```
**¿Qué significa terminar correctamente?**
```powershell
ping localhost && Write-Host "ping a localhost correcto"
ping www.dominiotutia.com && Write-Host "ping a www.dominiotutia.com incorrecto"

ping www.dominioinventado.com || Write-Host "ping a www.dominioinventado.com incorrecto"
```


**Operadores ?? y ??=. Válidos a partir de PowerShell 7**
```powershell
$puerto = $configuracion.Puerto ?? 443
# Si $configuracion.Puerto no existe o es $null, $puerto valdrá 443
$puerto

#Ahora vamos a asignar de partida un valor 8080 de puerto
$configuracion = @{
    Puerto = 8080
}

$configuracion.Puerto
$puerto

$puerto = $configuracion.Puerto ?? 443
$puerto


$configuracion.Puerto ??= 443
# Asigna 443 a Puerto SOLO SI actualmente es $null; si ya tiene un valor, no lo toca
```

**Ejemplo integrador aplicado a Sistemas**
```powershell
$servicios = Get-Service -Name 'Spooler', 'BITS', 'WinRM'

foreach ($servicio in $servicios) {
    switch -Wildcard ($servicio.Status) {
        'Running' { Write-Host "$($servicio.Name): funcionando correctamente" }
        'Stop*'   { Write-Host "$($servicio.Name): DETENIDO, revisar" }
        default   { Write-Host "$($servicio.Name): estado $($servicio.Status)" }
    }
}
```
