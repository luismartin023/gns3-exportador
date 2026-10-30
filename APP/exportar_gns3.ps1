# exportar_gns3.ps1
# Empaqueta un proyecto GNS3 como .gns3project portable.
# Uso:  powershell -File exportar_gns3.ps1 -Proyecto "C:\ruta\proyecto" [-Destino "C:\salida"]
# Un .gns3project es un ZIP con: project.gns3 + README.txt + project-files/
# El exportador oficial de GNS3 no incluye nodos VMware; este script tampoco
# (esos discos dependen de la PC local y no son portables).

param(
    [Parameter(Mandatory=$true)][string]$Proyecto,
    [string]$Destino = ""
)

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   EXPORTADOR GNS3 -> .gns3project"
Write-Host "============================================" -ForegroundColor Cyan

$Proyecto = $Proyecto.Trim().Trim('"')

# 1. Validar carpeta del proyecto
if (-not (Test-Path $Proyecto)) {
    Write-Host "ERROR: la carpeta no existe: $Proyecto" -ForegroundColor Red
    exit 1
}

# 2. Buscar el archivo .gns3 dentro
$gns3 = Get-ChildItem -Path $Proyecto -Filter "*.gns3" -File | Select-Object -First 1
if (-not $gns3) {
    Write-Host "ERROR: no hay ningun archivo .gns3 en $Proyecto" -ForegroundColor Red
    exit 1
}
Write-Host "Proyecto encontrado: $($gns3.Name)"

# 3. Nombre de salida = nombre del proyecto
$nombre = [IO.Path]::GetFileNameWithoutExtension($gns3.Name)
if ($Destino -eq "") { $Destino = Join-Path $Proyecto "EXPORT" }

$Staging = Join-Path $env:TEMP "gns3_export_$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path "$Staging\project-files" -Force | Out-Null

# 4. project.gns3 + README.txt
Copy-Item $gns3.FullName "$Staging\project.gns3"
$readme = Join-Path $Proyecto "README.txt"
if (Test-Path $readme) { Copy-Item $readme "$Staging\README.txt" }

# 5. project-files: copiar todo EXCEPTO carpetas de VMs (no portables)
$pf = Join-Path $Proyecto "project-files"
$excluir = @("vmware", "virtualbox", "docker")
if (Test-Path $pf) {
    Get-ChildItem $pf -Directory | Where-Object { $excluir -notcontains $_.Name } | ForEach-Object {
        Copy-Item $_.FullName "$Staging\project-files\$($_.Name)" -Recurse
        Write-Host "  + project-files/$($_.Name)"
    }
    Get-ChildItem $pf -Directory | Where-Object { $excluir -contains $_.Name } | ForEach-Object {
        Write-Host "  - project-files/$($_.Name) omitido (no portable)" -ForegroundColor Yellow
    }
}

# 6. Comprimir como ZIP y renombrar
New-Item -ItemType Directory -Path $Destino -Force | Out-Null
$zip = Join-Path $env:TEMP "$nombre.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path "$Staging\*" -DestinationPath $zip
$salida = Join-Path $Destino "$nombre.gns3project"
Move-Item $zip $salida -Force

# 7. Reporte final
$kb = [math]::Round((Get-Item $salida).Length / 1KB)
Write-Host ""
Write-Host "LISTO" -ForegroundColor Green
Write-Host "Archivo: $salida ($kb KB)"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$total = [IO.Compression.ZipFile]::OpenRead($salida).Entries.Count
Write-Host "Entradas en el paquete: $total"
Remove-Item $Staging -Recurse -Force
Write-Host ""
