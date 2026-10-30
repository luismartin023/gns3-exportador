# APP/Interfaz/LabPack.UI.ps1 — Exportador GNS3 con ventana grafica
# ADAPTADOR UI: solo dibuja el formulario y pinta el log.
# La logica de empaquetado vive en APP/Core/LabPack.Core.ps1.

param([string]$Captura = "")

. (Join-Path $PSScriptRoot "..\Core\LabPack.Core.ps1")

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Declarar el proceso como DPI-aware: sin esto Windows escala la ventana
# como bitmap y todo se ve borroso en pantallas de alta densidad.
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class DpiAwareness {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
}
"@
[void][DpiAwareness]::SetProcessDPIAware()

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Exportador GNS3 Portable"
$form.Size = New-Object System.Drawing.Size(560, 515)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.AutoScaleMode = "Dpi"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.BackColor = [System.Drawing.Color]::White

$iconoPath = Join-Path $PSScriptRoot "..\Recursos\labpack.ico"
$ico = $null
if (Test-Path $iconoPath) {
    $ico = New-Object System.Drawing.Icon($iconoPath)
    $form.Icon = $ico
}

# ===== Cabecera =====
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 64
$header.BackColor = [System.Drawing.Color]::FromArgb(24, 94, 48)
$form.Controls.Add($header)

if ($ico) {
    $pb = New-Object System.Windows.Forms.PictureBox
    $pb.Image = $ico.ToBitmap()
    $pb.SizeMode = "StretchImage"
    $pb.Location = New-Object System.Drawing.Point(16, 14)
    $pb.Size = New-Object System.Drawing.Size(36, 36)
    $pb.BackColor = [System.Drawing.Color]::Transparent
    $header.Controls.Add($pb)
}

$lblTitulo = New-Object System.Windows.Forms.Label
$lblTitulo.Text = "Exportador GNS3 Portable"
$lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
$lblTitulo.ForeColor = [System.Drawing.Color]::White
$lblTitulo.BackColor = [System.Drawing.Color]::Transparent
$lblTitulo.Location = New-Object System.Drawing.Point(62, 11)
$lblTitulo.AutoSize = $true
$header.Controls.Add($lblTitulo)

$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "Empaqueta tu proyecto como .gns3project para otra PC"
$lblSub.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblSub.ForeColor = [System.Drawing.Color]::FromArgb(200, 235, 210)
$lblSub.BackColor = [System.Drawing.Color]::Transparent
$lblSub.Location = New-Object System.Drawing.Point(63, 36)
$lblSub.AutoSize = $true
$header.Controls.Add($lblSub)

function New-Campo($titulo, $y, $valorInicial) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $titulo
    $lbl.Location = New-Object System.Drawing.Point(15, $y)
    $lbl.AutoSize = $true
    $form.Controls.Add($lbl)

    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Location = New-Object System.Drawing.Point(15, ($y + 20))
    $txt.Size = New-Object System.Drawing.Size(430, 24)
    $txt.Text = $valorInicial
    $form.Controls.Add($txt)

    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "Examinar..."
    $btn.Location = New-Object System.Drawing.Point(455, ($y + 19))
    $btn.Size = New-Object System.Drawing.Size(80, 26)
    $form.Controls.Add($btn)
    return @{ TextBox = $txt; Boton = $btn }
}

$proyectosDefault = Join-Path $env:USERPROFILE "GNS3\projects"
if (-not (Test-Path $proyectosDefault)) { $proyectosDefault = "" }

$campoProyecto = New-Campo "Carpeta del proyecto GNS3 (donde esta el .gns3):" 80 $proyectosDefault
$campoDestino  = New-Campo "Carpeta destino (vacio = proyecto\EXPORT):" 140 ""

$campoProyecto.Boton.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Elige la carpeta del proyecto GNS3"
    if (Test-Path $campoProyecto.TextBox.Text) { $dlg.SelectedPath = $campoProyecto.TextBox.Text }
    if ($dlg.ShowDialog() -eq "OK") { $campoProyecto.TextBox.Text = $dlg.SelectedPath }
})
$campoDestino.Boton.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Elige donde guardar el .gns3project"
    if ($dlg.ShowDialog() -eq "OK") { $campoDestino.TextBox.Text = $dlg.SelectedPath }
})

$log = New-Object System.Windows.Forms.RichTextBox
$log.ReadOnly = $true
$log.ScrollBars = "Vertical"
$log.Font = New-Object System.Drawing.Font("Consolas", 9)
$log.BorderStyle = "None"
$log.Location = New-Object System.Drawing.Point(15, 240)
$log.Size = New-Object System.Drawing.Size(520, 190)
$log.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$log.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$form.Controls.Add($log)

function Write-Log($texto, $color = "") {
    $log.SelectionStart = $log.TextLength
    $log.SelectionLength = 0
    $log.SelectionColor = switch ($color) {
        "rojo"  { [System.Drawing.Color]::FromArgb(255, 120, 120) }
        "aviso" { [System.Drawing.Color]::FromArgb(255, 200, 90) }
        "ok"    { [System.Drawing.Color]::FromArgb(140, 220, 140) }
        default { $log.ForeColor }
    }
    $log.AppendText("$texto`r`n")
    $log.SelectionColor = $log.ForeColor
    $log.ScrollToCaret()
}

$btnExportar = New-Object System.Windows.Forms.Button
$btnExportar.Text = "EXPORTAR AHORA"
$btnExportar.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnExportar.Location = New-Object System.Drawing.Point(15, 195)
$btnExportar.Size = New-Object System.Drawing.Size(520, 34)
$btnExportar.BackColor = [System.Drawing.Color]::FromArgb(30, 122, 60)
$btnExportar.ForeColor = [System.Drawing.Color]::White
$btnExportar.FlatStyle = "Flat"
$form.Controls.Add($btnExportar)

$btnExportar.Add_Click({
    $log.Clear()
    $resultado = Export-Gns3Project `
        -Proyecto $campoProyecto.TextBox.Text `
        -Destino  $campoDestino.TextBox.Text `
        -OnLog {
            param($msg, $tipo)
            $estilo = if ($tipo -eq "error") { "rojo" } else { $tipo }
            Write-Log $msg $estilo
        }

    if (-not $resultado.Exito) {
        Write-Log "ERROR: $($resultado.Error)" "rojo"
        return
    }

    Write-Log "" ""
    Write-Log "LISTO: $($resultado.Salida) ($($resultado.KB) KB)" "ok"
    [System.Windows.Forms.MessageBox]::Show(
        "Exportado correctamente:`n$($resultado.Salida) ($($resultado.KB) KB)", "Exportador GNS3",
        "OK", "Information") | Out-Null
})

$lblPie = New-Object System.Windows.Forms.Label
$lblPie.Text = "Los nodos VMware/VirtualBox no se incluyen: no son portables."
$lblPie.Location = New-Object System.Drawing.Point(15, 440)
$lblPie.AutoSize = $true
$lblPie.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($lblPie)

# Modo captura: muestra la ventana, la fotografia de pantalla real y sale
if ($Captura -ne "") {
    $form.TopMost = $true
    $form.Show()
    $form.Activate()
    $form.Refresh()
    Start-Sleep -Milliseconds 800
    $origen = $form.PointToScreen((New-Object System.Drawing.Point(0, 0)))
    $bmp = New-Object System.Drawing.Bitmap($form.Width, $form.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($origen, (New-Object System.Drawing.Point(0, 0)), $bmp.Size)
    $g.Dispose()
    $bmp.Save($Captura, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $form.Close()
    exit 0
}

# Quita la seleccion azul del texto precargado al abrir
$form.Add_Shown({
    $campoProyecto.TextBox.SelectionStart = $campoProyecto.TextBox.TextLength
    $campoProyecto.TextBox.SelectionLength = 0
})

[void]$form.ShowDialog()
