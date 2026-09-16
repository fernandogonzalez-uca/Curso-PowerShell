# Código fuente Bloque II - Entorno y primeros pasos

**Ejecutando los distintos ejecutables de PowerShell con permisos de Administrador desde una consola de MS-DOS**

**PowerShell 64 bits (Admin)**

```powershell
powershell -Command "Start-Process powershell -Verb RunAs"
```

**PowerShell 64 bits (ISE (Admin)**
```powershell
powershell -Command "Start-Process powershell_ise -Verb RunAs"
```
**PowerShell 32 bits (Admin)**

```powershell
powershell -Command "Start-Process '%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe' -Verb RunAs"
```
**PowerShell 32 bits  ISE (Admin)**

```powershell
powershell -Command "Start-Process '%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe' -Verb RunAs"
```

**Ejemplo de procesamiento paralelo para el comando ForEach-Objecto en PowerShell 7.X**

```powershell
# Procesamiento masivo de equipos en paralelo
# Realiza una comprobación de conectividad (ping) a una lista de servidores ejecutando
# las peticiones al mismo tiempo (en paralelo), en lugar de probarlos uno por uno (en
# secuencia).
# Nota: Ejecución sólo disponible en PowerShell 7.x

$servers | ForEach-Object -Parallel { Test-Connection -ComputerName $_ -Count 1 } -ThrottleLimit 20
```

```powershell
# En PowerShell 5.1 (Lento)
# Si hay 100 servidores y 10 no responden (esperando timeout de 4 seg), 
# la ejecución tardaría más de 40 segundos en terminar.
$servers | ForEach-Object { Test-Connection -ComputerName $_ -Count 1 }
```

**Ejemplo de comando para ejecutar en el ISE**
```powershell
Get-Command -CommandType cmdlet | Measure-Object
```

**Cmdlet para obtener ayuda en PowerShell**
```powershell
Get-Help -Name Nombre_Cmdlet
Get-Help -Name Get-Command
Get-Help Get-Command
# Muestra la información online, en la página de learn de Microsoft.
Get-Help Get-Command -Online


Get-Help Get-Command -Detailed
# La muestra también online, ¿porqué?

Get-Help  
```

Podremos obtener una referencia respecto a que no está descargada la ayuda respecto al comando en PowerShell, será necesario ejecutar el comando Update-Help o responder afirmativamente a la opción de descarga

```powershell
Update-Help -UICulture es-ES -Force
# Obtendremos bastante errorres ya que muchos paquetes no están traducidos y por tanto
# no los descargará.

Update-Help -UICUlture en-US -Force
# Descargaremos casi la totalidad de paquetes.

Get-Help Get-Command -Detailed # mostrará la ayuda en consola.
```


**Comandos simples y ejemplos de alias**

**dir**

```powershell
dir
ls
gci
```

```powershell
clear
pwd
md C:\datos
cd C:\datos
md prueba
cd prueba
ni test.txt
echo "hola">.\test.txt
cat test.txt
rm .\test.txt
cd ..
rm -r .\prueba
history

```

**Conocer si un comando tiene alias**

```powershell
Get-Alias -Definition cmdlet
Get-Alias -Definition Get-Content

Get-Alias -Definition Get-History
``` 

**Se obtiene un error en la consulta cuando no existe un alias asociado**

```powershell
Get-Alias -Definition Get-LocalUser
#Obtendremos un error y es normal, ya que no se encuentra ninguna asociación.
```
```powershell
Get-Alias -Definition Get-LocalUser -ErrorAction SilentlyContinue
```


**Conocer que comandos existen relacionados con los alias**
```powershell
Get-Command "*alias*"
```

**Crear nuevos alias para listar usuarios locales y grupos locales**
```powershell
New-Alias -Name usuarios Get-LocalUser
New-Alias -Name grupos Get-LocalGroup
```

**Exportación e importación de alias**
```powershell
md C:\Datos\prueba
Export-Alias -Name usuarios,grupos -Path C:\Datos\prueba\mis_alias.txt
cat C:\Datos\prueba\mis_alias.txt

Import-Alias -Path C:\Datos\prueba\mis_alias.txt
Get-Alias
```



**Eliminar un alias**
```powershell
Remove-Item Alias:\usuarios
Remove-Item Alias:\grupos
Remove-Item -Path Alias:\usuarios
Remove-Item -Path Alias:\grupos
```


**Cómo hacer un alias permanente**

El perfil es un script que PowerShell ejecuta automáticamente cada vez que abres una nueva consola.

1º) Abre o crea tu perfil:

Ejecuta este comando para abrir tu archivo de perfil en el Bloc de notas (si no existe, lo creará automáticamente):

```powershell
if (!(Test-Path $PROFILE)) { New-Item -Type File -Force $PROFILE }
notepad $PROFILE
```
2º) Añade tus alias al archivo:

Escribe tus comandos de creación de alias dentro del bloc de notas. Por ejemplo:

```powershell
New-Alias -Name usuarios Get-LocalUser
New-Alias -Name grupos Get-LocalGroup
```
3º) Guarda y cierra el archivo.

A partir de ese momento, cada vez que abras PowerShell, el alias estará disponible.




