# Código fuente Bloque X - Funciones #

**1 - ¿Qué es una función?**
```powershell
function Get-Saludo {
    param(
        [string]$Nombre
    )
    Write-Output "Hola, $Nombre. Bienvenido al curso de PowerShell"
}

Get-Saludo -Nombre 'Fernando'
```

**2 - Parámetros: El bloque param()**

**2.1 Valores por defecto**
```powershell
function Get-Saludo {
    param(
        [string]$Nombre = 'invitado'
    )
    "Hola, $Nombre"
}
Get-Saludo             # Hola, invitado
Get-Saludo -Nombre 'Ana'   # Hola, Ana
```
**2.2 - Parámetros obligatorios**
```powershell
function New-CarpetaAula {
    param(
        [Parameter(Mandatory = $true)]
        [string]$NombreAula
    )
    New-Item -Path "C:\Aulas\$NombreAula" -ItemType Directory -Force
}

New-CarpetaAula
# PowerShell detiene la ejecución y PREGUNTA el valor de NombreAula,
# en vez de fallar directamente
```

**2.3 - Validación de parámetros**
```powershell
function Set-EstadoEquipo {
    param(
        [ValidateSet('Activo', 'Mantenimiento', 'Baja')]
        [string]$Estado,

        [ValidateRange(1, 50)]
        [int]$NumeroAula
    )
    "Aula $NumeroAula -> $Estado"
}

Set-EstadoEquipo -Estado 'Reparando' -NumeroAula 3
# Error inmediato: 'Reparando' no está en el ValidateSet permitido
```

**2.4 - Parámetros de tipo interruptor (switch)**
```powershell
function Remove-ArchivosTemp {
    param(
        [string]$Carpeta,
        [switch]$Force
    )
    if ($Force) {
        Remove-Item -Path "$Carpeta\*.tmp" -Force
    } else {
        Remove-Item -Path "$Carpeta\*.tmp" -WhatIf
    }
}

Remove-ArchivosTemp -Carpeta 'C:\Temp'            # Solo simula (WhatIf)
Remove-ArchivosTemp -Carpeta 'C:\Temp' -Force     # Borra de verdad
```

**3 - Devolver valores de una función**
```powershell
function Get-Cuadrado {
    param([int]$Numero)
    $Numero * $Numero      # esto se "devuelve" solo, sin necesidad de return
}

$resultado = Get-Cuadrado -Numero 5
$resultado    # 25
```

```powershell
function Test-EsPar {
    param([int]$Numero)
    if ($Numero % 2 -eq 0) {
        return $true    # sale inmediatamente de la función con este valor
    }
    return $false
}
```

**4 - Funciones avanzadas: [CmdletBinding()]**
```powershell
function Get-InformeEquipos {
    [CmdletBinding()]
    param(
        [string]$Carpeta
    )
    Write-Verbose "Explorando la carpeta $Carpeta"
    Get-ChildItem -Path $Carpeta
}

Get-InformeEquipos -Carpeta 'C:\Datos' -Verbose
# Ahora sí se muestran los mensajes de Write-Verbose
```

**5 - Recibir datos por el pipeline**
```powershell
function Test-Conectividad {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$ComputerName
    )
    process {
        $ok = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
        [PSCustomObject]@{
            Equipo   = $ComputerName
            Responde = $ok
        }
    }
}

'PC-Aula01', 'PC-Aula02', 'PC-Aula03' | Test-Conectividad
```

```powershell
# Ejemplo de recibir datos del pipeline con begin, process y end.
function Get-Promedio {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [double]$Numero
    )

    begin {
        # 1. Se ejecuta UNA SOLA VEZ al inicio.
        # Ideal para preparar variables o abrir conexiones.
        $suma = 0
        $contador = 0
        Write-Verbose "Iniciando el cálculo..."
    }

    process {
        # 2. Se ejecuta UNA VEZ POR CADA ELEMENTO que entra por el pipeline.
        # Aquí se procesa cada dato individual.
        suma += Numero
        $contador++
    }

    end {
        # 3. Se ejecuta UNA SOLA VEZ al finalizar la entrada de datos.
        # Ideal para consolidados, cálculos finales o cerrar conexiones.
        if ($contador -gt 0) {
            promedio = suma / $contador
            
            [PSCustomObject]@{
                TotalElementos = $contador
                SumaTotal      = $suma
                Promedio       = $promedio
            }
        } else {
            Write-Warning "No se recibieron números."
        }
    }
}

# Ejemplo de uso pasándole valores por el pipeline:
10, 20, 30, 40 | Get-Promedio
```

**6 - El ámbito (scope) de las variables dentro de una función**
```powershell
$contador = 0

function Add-Contador {
    $contador++     # esto crea/usa una variable LOCAL, no la de fuera
    $contador
}

Add-Contador     # 1
Add-Contador     # 1 otra vez (no 2): cada llamada usa su propia copia local
$contador        # sigue valiendo 0 fuera de la función
```

```powershell
function Add-ContadorGlobal {
    $script:contador++
}

Add-ContadorGlobal
$contador   # Ahora tendrá un valor de 1
Add-ContadorGlobal
$contador   # Ahora tendrá un valor de 2
```

```powershell
# Ejemplo adaptado  para usar parámetros y devolver valores (evitando el uso de $script:).
# 1. Definimos la función para que acepte un valor y devuelva el resultado
function Add-Contador {
    param(
        [int]$ValorActual = 0
    )
    # Incrementa el valor recibido y lo devuelve
    return $ValorActual + 1
}

# 2. Inicializamos nuestra variable en el ámbito del script
$contador = 0

# 3. Llamamos a la función pasándole la variable y guardando el nuevo resultado
$contador = Add-Contador -ValorActual $contador

# 4. Mostramos el resultado
$contador   # Muestra 1
```

**7 - Documentar una función: ayuda basada en comentarios**
```powershell
function Get-InformeArchivosGrandes {
    <#
    .SYNOPSIS
        Genera un informe de archivos grandes en una carpeta.
    .DESCRIPTION
        Recorre una carpeta de forma recursiva y exporta a CSV
        los archivos que superen un tamaño indicado.
    .PARAMETER Carpeta
        Ruta de la carpeta a analizar.
    .PARAMETER UmbralMB
        Tamaño mínimo, en megabytes, para considerar un archivo "grande".
    .EXAMPLE
        Get-InformeArchivosGrandes -Carpeta 'C:\Datos' -UmbralMB 100
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Carpeta,

        [int]$UmbralMB = 100
    )
    # ... cuerpo de la función ...
}

Get-Help Get-InformeArchivosGrandes
Get-Help Get-InformeArchivosGrandes -Examples
```


**8 - Ejemplo integrador: convertir script en función**
```powershell
function Get-InformeArchivosGrandes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$Carpeta,

        [int]$UmbralMB = 100,

        [string]$RutaSalida = '.\archivos_grandes.csv'
    )

    $umbralBytes = $UmbralMB * 1MB

    $archivosGrandes = Get-ChildItem -Path $Carpeta -Recurse -File |
        Where-Object { $_.Length -gt $umbralBytes } |
        Select-Object Name, LastWriteTime,
            @{Name='TamañoMB'; Expression={ [math]::Round($_.Length / 1MB, 2) }}

    $archivosGrandes |
        Export-Csv -Path $RutaSalida -NoTypeInformation -Encoding UTF8

    $mensaje = "Se han encontrado $($archivosGrandes.Count) archivos" +
               " de más de $UmbralMB MB"
    Write-Verbose $mensaje

    return $archivosGrandes
}

Get-InformeArchivosGrandes -Carpeta 'C:\Datos' -UmbralMB 50 -Verbose
```

