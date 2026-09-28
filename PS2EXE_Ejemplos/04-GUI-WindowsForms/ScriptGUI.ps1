<#
.SYNOPSIS
    Ejemplo 4 del módulo PS2EXE: aplicación con interfaz gráfica (Windows Forms).

.DESCRIPTION
    Formulario mínimo con un campo de texto y un botón, en la línea de las
    herramientas GUI reales usadas en el puesto de trabajo (utilidades de
    soporte, formularios de preparación de equipos, etc.).

    IMPORTANTE: al convertir este script con PS2EXE es obligatorio usar el
    parámetro -STA (Single-Threaded Apartment). Windows Forms y WPF requieren
    ese modelo de apartamento de hilos; si se omite, el formulario puede
    fallar o comportarse de forma inestable, especialmente al abrir cuadros
    de diálogo adicionales.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$formulario = New-Object System.Windows.Forms.Form
$formulario.Text = "Utilidad de Equipos - Curso PowerShell"
$formulario.Size = New-Object System.Drawing.Size(420, 220)
$formulario.StartPosition = "CenterScreen"
$formulario.FormBorderStyle = "FixedDialog"
$formulario.MaximizeBox = $false

$etiqueta = New-Object System.Windows.Forms.Label
$etiqueta.Text = "Nombre del equipo o aula:"
$etiqueta.Location = New-Object System.Drawing.Point(20, 25)
$etiqueta.AutoSize = $true
$formulario.Controls.Add($etiqueta)

$cuadroTexto = New-Object System.Windows.Forms.TextBox
$cuadroTexto.Location = New-Object System.Drawing.Point(20, 50)
$cuadroTexto.Size = New-Object System.Drawing.Size(360, 25)
$formulario.Controls.Add($cuadroTexto)

$etiquetaResultado = New-Object System.Windows.Forms.Label
$etiquetaResultado.Location = New-Object System.Drawing.Point(20, 120)
$etiquetaResultado.Size = New-Object System.Drawing.Size(360, 40)
$etiquetaResultado.ForeColor = [System.Drawing.Color]::DarkGreen
$formulario.Controls.Add($etiquetaResultado)

$boton = New-Object System.Windows.Forms.Button
$boton.Text = "Comprobar"
$boton.Location = New-Object System.Drawing.Point(20, 85)
$boton.Size = New-Object System.Drawing.Size(120, 30)
$boton.Add_Click({
    if ([string]::IsNullOrWhiteSpace($cuadroTexto.Text)) {
        $etiquetaResultado.Text = "Introduce un nombre antes de continuar."
        $etiquetaResultado.ForeColor = [System.Drawing.Color]::Firebrick
    } else {
        $etiquetaResultado.Text = "Comprobación simulada OK para: '$($cuadroTexto.Text)'"
        $etiquetaResultado.ForeColor = [System.Drawing.Color]::DarkGreen
    }
})
$formulario.Controls.Add($boton)

$formulario.AcceptButton = $boton

[void]$formulario.ShowDialog()
