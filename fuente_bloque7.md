# Código fuente Bloque VII - 1: Estructuras de control de flujo #

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
switch ($diaSemana) {
    { $_ -in 'Sábado', 'Domingo' } { Write-Host 'Fin de semana' }
    default                        { Write-Host 'Día laborable' }
}
```

**Switch con comodines y expresiones regulares**
```powershell
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
$equipo = "CAD-AULA-PC023"

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
switch ($nota) {
    { $_ -ge 9 } { Write-Host 'Sobresaliente' }
    { $_ -ge 7 } { Write-Host 'Notable' }
    { $_ -ge 5 } { Write-Host 'Aprobado' }
    default      { Write-Host 'Suspenso' }
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
    default { Write-Host "Código $_ sin descripción" }
}
# Se ejecuta una vez por cada elemento del array
```


**Operador ternario (?). Válido a partir de PowerShell 7**
```powershell
# Con if / else (funciona en todas las versiones)
if ($edad -ge 18) { $mensaje = 'Mayor de edad' } else { $mensaje = 'Menor de edad' }

# La misma lógica con el operador ternario (solo PowerShell 7+)
$mensaje = $edad -ge 18 ? 'Mayor de edad' : 'Menor de edad'
```

**Operador ?? y ||. Válido a partir de PowerShell 7**
```powershell
# Ejecuta el segundo comando SOLO SI el primero tuvo éxito
Test-Path 'C:\Backups' && Write-Host 'La carpeta de backups existe'

# Ejecuta el segundo comando SOLO SI el primero falló
Test-Path 'C:\CarpetaInexistente' || Write-Host 'La carpeta no existe'
```

**Operadores ?? y ??=. Válidos a partir de PowerShell 7**
```powershell
$puerto = $configuracion.Puerto ?? 443
# Si $configuracion.Puerto no existe o es $null, $puerto valdrá 443

$configuracion.Puerto ??= 443
# Asigna 443 a Puerto SOLO SI actualmente es $null; si ya tiene un valor, no lo toca
```
