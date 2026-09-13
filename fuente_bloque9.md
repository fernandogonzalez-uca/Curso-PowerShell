# Código fuente Bloque IX - 1: Manejo de archivos y carpetas #

*Ejemplo de Get-ChildItem**
```powershell
Get-ChildItem -Path 'C:\Temp' | Get-Member -MemberType Property
# TypeName: System.IO.FileInfo  ->  también es, simplemente, un objeto más
```

**Rutas en PowerShell**
```powershell
$rutaDatos = Join-Path -Path $PSScriptRoot -ChildPath 'datos\informe.csv'
Split-Path -Path $rutaDatos -Parent      # La carpeta contenedora
Split-Path -Path $rutaDatos -Leaf        # Solo el nombre del archivo
```

**Comprobar si algo existe:Test-Path**
```powershell
Test-Path 'C:\Datos\informe.csv'                    # $true o $false
Test-Path 'C:\Datos' -PathType Container             # ¿Es una carpeta?
Test-Path 'C:\Datos\informe.csv' -PathType Leaf      # ¿Es un archivo?
```

**CMDLETs fundamentales**
```powershell
Test-Path 'C:\Datos\informe.csv'
Get-Item 'C:\Datos\informe.csv'
Get-ChildItem 'C:\Datos' -Recurse
New-Item -Path 'C:\Datos' -ItemType Directory
Copy-Item 'origen.txt' 'destino.txt'
Move-Item 'informe.csv' 'C:\Archivo\'
Rename-Item 'viejo.txt' 'nuevo.txt'
Remove-Item 'temporal.txt'
```

```powershell
# Crear carpeta para hacer que estos cmdlets funcionen
```

**Crear carpetas y archivos**
```powershell
New-Item -Path 'C:\Datos\Aulas' -ItemType Directory -Force
New-Item -Path 'C:\Datos\Aulas\registro.txt' -ItemType File -Force
```

```powershell
# Creando carpetas con el ForeEach-Object.
# Crea múltiples subcarpetas de asignaturas de una sola vez usando el pipeline.
'Matematicas', 'Historia', 'Ciencias', 'Lengua' | ForEach-Object {
    New-Item -Path "C:\Datos\Aulas\$_" -ItemType Directory -Force
}
```

```powershell
# Definir rutas en variables para mantener el código limpio
$rutaBase = "C:\Datos\Aulas"
$archivoRegistro = Join-Path -Path $rutaBase -ChildPath "registro.txt"

# Comprobar si la carpeta ya existe antes de crearla
if (-not (Test-Path -Path $rutaBase)) {
    New-Item -Path $rutaBase -ItemType Directory
    Write-Host "Carpeta base creada con éxito." -ForegroundColor Green
} else {
    Write-Host "La carpeta base ya existía." -ForegroundColor Yellow
}

# Crear el archivo solo si no existe
if (-not (Test-Path -Path $archivoRegistro)) {
    New-Item -Path $archivoRegistro -ItemType File
}
```

```powershell
# Crear un archivo de configuración que ya incluya texto de bienvenida y la fecha actual
$contenidoInicial = @"
======================================
Registro de Aula iniciado correctamente
Fecha de creación: $(Get-Date)
======================================
"@

New-Item -Path 'C:\Datos\Aulas\registro.txt' -ItemType File -Value $contenidoInicial Force
```

**Listar contenido con Get-ChildItem**
```powershell
Get-ChildItem -Path 'C:\Datos'
# Contenido directo de la carpeta (sin subcarpetas)

Get-ChildItem -Path 'C:\Datos' -Recurse
# Incluye también el contenido de todas las subcarpetas

Get-ChildItem -Path 'C:\Datos' -Filter '*.log'
# Solo archivos que coincidan con el patrón

Get-ChildItem -Path 'C:\Datos' -File
# Solo archivos, sin carpetas

Get-ChildItem -Path 'C:\Datos' -Directory
# Solo carpetas
```

**Copiar, mover, renombrar y eliminar**
```powershell
Copy-Item -Path 'C:\Datos\informe.csv' -Destination 'C:\Backup\'
Copy-Item -Path 'C:\Datos' -Destination 'C:\Backup\Datos' -Recurse

Move-Item -Path 'C:\Datos\informe.csv' -Destination 'C:\Archivo\'
Rename-Item -Path 'C:\Datos\viejo.txt' -NewName 'nuevo.txt'

Remove-Item -Path 'C:\Temp\cache.tmp'
Remove-Item -Path 'C:\Temp\CarpetaVieja' -Recurse -Force

Remove-Item 'C:\Temp\*' -Recurse -WhatIf
```

**Leer contenido de un archivo**
```powershell
Get-Content -Path 'C:\Datos\registro.txt'
# Devuelve un array: una línea por elemento

Get-Content -Path 'C:\Datos\registro.txt' -Raw
# Todo el archivo como una única cadena de texto

Get-Content -Path 'C:\Datos\registro.txt' -TotalCount 10
# Solo las 10 primeras líneas

Get-Content -Path 'C:\Datos\registro.txt' -Tail 10
# Solo las 10 últimas líneas
```

```powershell
$lineas = Get-Content -Path 'C:\Datos\registro.txt'
foreach ($linea in $lineas) {
    if ($linea -match 'ERROR') {
        Write-Host $linea
    }
}
```

**Escribir en un archivo**
```powershell
Set-Content -Path 'C:\Datos\salida.txt' -Value 'Primera línea'
# Set-Content SOBRESCRIBE el archivo completo si ya existía

Add-Content -Path 'C:\Datos\salida.txt' -Value 'Otra línea más'
# Add-Content AÑADE al final, sin borrar lo anterior
```

```powershell
Get-Process | Out-File -FilePath "C:\datos\procesos.txt"
# En este caso guarda la salida de un comando, que suele ser el uso básico.
```

**Añadir contenido sin borrar lo anterior (-Append)**
```powershell
"Nueva línea de registro" | Out-File -FilePath "C:\datos\log.txt" -Append
```

**Forzar la escritura en archivos protegidos (-Force)**
```powershell
Get-Service | Out-File -FilePath "C:\datos\servicios.txt" -Force
```


**Cambiar la codifición del archivo (Encoding)**
```powershell
"Texto en formato ASCII" | Out-File -FilePath "C:\datos\archivo.txt" -Encoding ascii
```

**Controlar el ancho de línea (-Width)**
```powershell
# Definimos un ancho de 300 caracteres para que quepan todas las columnas sin cortes
Get-Process | Out-File -FilePath "C:\datos\procesos_anchos.txt" -Width 300
```

**Controlar errores si el archivo está bloqueado**
```powershell
#Opción A: Ignorar el error de forma silenciosa
"Texto de prueba" | Out-File -FilePath "C:\datos\archivo_bloqueado.txt" -ErrorAction SilentlyContinue
```

```powershell
#Opción B: Capturar el error para tomar medidas
try {
    "Log importante" | Out-File -FilePath "C:\datos\archivo.txt" -ErrorAction Stop
    Write-Host "Archivo guardado con éxito." -ForegroundColor Green
} catch {
    Write-Host "Error: No se pudo escribir en el archivo. Puede que esté bloqueado." -ForegroundColor Red
    # Aquí podrías enviar una alerta o escribir en un archivo alternativo
}
```

**Trabajar con archivos .csv**
```powershell
$equipos = Import-Csv -Path 'C:\Datos\equipos.csv'

foreach ($equipo in $equipos) {
    Write-Host "$($equipo.Nombre) está en el aula $($equipo.Aula)"
}
$inventario = Get-ChildItem -Path 'C:\Software' -File |
    Select-Object Name, Length, LastWriteTime

$inventario | Export-Csv -Path 'C:\Datos\inventario.csv' -NoTypeInformation -Encoding UTF8
```

**Trabajar con archivos JSON**
```powershell
$configuracion = @{
    Aula          = 'Aula 3'
    NumeroEquipos = 25
    Responsable   = 'Fernando'
}

$configuracion | ConvertTo-Json | Set-Content -Path 'C:\Datos\config.json'
$configuracion = Get-Content -Path 'C:\Datos\config.json' -Raw | ConvertFrom-Json
$configuracion.Aula
$configuracion.NumeroEquipos
```

**Ejemplo integrador**
```powershell
$carpeta = 'C:\Datos'
$umbral  = 10MB

$archivosGrandes = Get-ChildItem -Path $carpeta -Recurse -File |
    Where-Object { $_.Length -gt $umbral } |
    Select-Object Name, LastWriteTime,
        @{Name='TamañoMB'; Expression={ [math]::Round($_.Length / 1MB, 2) }}

$archivosGrandes |
    Export-Csv -Path 'C:\Datos\archivos_grandes.csv' -NoTypeInformation -Encoding UTF8

Write-Host "Se han encontrado $($archivosGrandes.Count) archivos de más de 10 MB"
```

