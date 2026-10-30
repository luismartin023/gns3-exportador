# APP/Consola/LabPack.CLI.ps1
# ADAPTADOR CLI: solo parsea parametros, pinta el log y traduce el
# resultado del dominio a codigos de salida. La logica vive en Core/.
# Uso:  powershell -File LabPack.CLI.ps1 -Proyecto "C:\ruta\proyecto" [-Destino "C:\salida"]

param(
    [Parameter(Mandatory = $true)][string]$Proyecto,
    [string]$Destino = ""
)

. (Join-Path $PSScriptRoot "..\Core\LabPack.Core.ps1")

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   LABPACK - EXPORTADOR GNS3 -> .gns3project"
Write-Host "============================================" -ForegroundColor Cyan

$resultado = Export-Gns3Project -Proyecto $Proyecto -Destino $Destino -OnLog {
    param($msg, $tipo)
    $color = switch ($tipo) {
        "ok"    { "Green" }
        "aviso" { "Yellow" }
        "error" { "Red" }
        default { "Gray" }
    }
    Write-Host $msg -ForegroundColor $color
}

if (-not $resultado.Exito) {
    Write-Host "ERROR: $($resultado.Error)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "LISTO" -ForegroundColor Green
Write-Host "Archivo: $($resultado.Salida) ($($resultado.KB) KB)"
Write-Host "Entradas en el paquete: $($resultado.Entradas)"
Write-Host ""
