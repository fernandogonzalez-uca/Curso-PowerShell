# Código fuente Bloque XII - PowerShell Galery #

**1 - Buscar módulos: Find-Module**
```powershell
Find-Module -Name 'ImportExcel'
Find-Module -Name '*Excel*'          # Búsqueda con comodines
Find-Module -Tag 'ActiveDirectory'   # Búsqueda por etiqueta temática
```

```powershell
Find-Module -Name 'ImportExcel' |
    Format-List Name, Author, Description, PublishedDate, ProjectUri
```

**2 - Los cmdlets principales de PowerShellGet**
```powershell
Find-Module -Name 'ImportExcel'
Install-Module -Name 'ImportExcel' -Scope CurrentUser
Import-Module -Name 'ImportExcel'
Get-Module -ListAvailable
Get-InstalledModule
Update-Module -Name 'ImportExcel'
Uninstall-Module -Name 'ImportExcel'
Install-Script -Name 'nombre-script'
```

**3 - Instalar un módulo**

```powershell
Install-Module -Name 'ImportExcel' -Scope CurrentUser
```

```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
```

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

**4 - Cargar e inspeccionar un módulo ya instalado**
```powershell
Import-Module -Name 'ImportExcel'
Get-Command -Module 'ImportExcel'      # Qué cmdlets aporta el módulo
Get-InstalledModule                    # Qué módulos hay instalados, con su versión
```

**5 - Actualizar y desinstalar módulos**
```powershell
Update-Module -Name 'ImportExcel'
Uninstall-Module -Name 'ImportExcel'
```

**6 - Instalación sin conexión a Internet**
```powershell
# En un equipo CON conexión a Internet:
Save-Module -Name 'ImportExcel' -Path 'C:\Datos\ModulosOffline'

# En el equipo destino comprobar las rutas donde PowerShell busca módulos instalados:
$env:PSModulePath -split ';'

# Copiar la carpeta del módulo descargado a una de esas rutas
# en el equipo de destino (sin conexión), y ya estará disponible
# como si se hubiera instalado con Install-Module.
```

**7 - Una nota sobre PSResourceGet (PowerShell 7.4)**
```powershell
Install-PSResource -Name 'ImportExcel'   # Equivalente moderno, PowerShell 7.4+
```


**8 - Ejemplo integrador: generar Excel real con ImportExcel**
```powershell
Install-Module -Name ImportExcel -Scope CurrentUser
Import-Module ImportExcel

$inventario = Get-ChildItem -Path 'C:\Software' -File |
    Select-Object Name, Length, LastWriteTime

$inventario | Export-Excel -Path 'C:\Datos\inventario.xlsx' `
    -AutoSize -TableName Inventario
```
