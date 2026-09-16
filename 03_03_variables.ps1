# Script con variable e interacción con el usuario
<#
•   Toda variable en PowerShell se declara anteponiendo el símbolo $ (por ejemplo, $nombre).
•	Read-Host detiene la ejecución y espera a que el usuario escriba algo en la consola.
•	Dentro de una cadena de texto entre comillas dobles, el nombre de una variable se sustituye automáticamente por su valor (interpolación de cadenas); con comillas simples esto no ocurre.
#>

$nombre = Read-Host "¿Cómo te llamas?"
Write-Host "Bienvenido/a al curso de PowerShell, $nombre"