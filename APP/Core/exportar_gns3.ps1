# APP/Core/exportar_gns3.ps1
# DOMINIO: empaquetado de proyectos GNS3 — logica pura, sin UI ni consola.
# Se carga con dot-source desde los adaptadores (Interfaz/ y Consola/).
#
# Contrato publico:
#   Find-Gns3File -Proyecto <ruta>
#       -> FileInfo del .gns3 encontrado, o $null
#
#   Export-Gns3Project -Proyecto <ruta> [-Destino <ruta>] [-OnLog { param($msg,$tipo) }]
#       $tipo: "info" | "ok" | "aviso" | "error"
#       -> @{ Exito; Salida; KB; Entradas; Error }
#
# Un .gns3project es un ZIP con: project.gns3 + README.txt + project-files/
# Los discos VMware/VirtualBox/Docker se omiten: no son portables.

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Find-Gns3File {
    param([Parameter(Mandatory = $true)][string]$Proyecto)
    if (-not (Test-Path $Proyecto)) { return $null }
    Get-ChildItem -Path $Proyecto -Filter "*.gns3" -File | Select-Object -First 1
}

function Export-Gns3Project {
    param(
        [Parameter(Mandatory = $true)][string]$Proyecto,
        [string]$Destino = "",
        [scriptblock]$OnLog = $null
    )

    function Log($msg, $tipo = "info") { if ($OnLog) { & $OnLog $msg $tipo } }

    $Proyecto = $Proyecto.Trim().Trim('"')
    if (-not (Test-Path $Proyecto)) {
        return @{ Exito = $false; Error = "La carpeta no existe: $Proyecto" }
    }

    $gns3 = Find-Gns3File $Proyecto
    if (-not $gns3) {
        return @{ Exito = $false; Error = "No hay ningun archivo .gns3 en $Proyecto" }
    }
    Log "Proyecto encontrado: $($gns3.Name)" "ok"

    $nombre = [IO.Path]::GetFileNameWithoutExtension($gns3.Name)
    if ($Destino -eq "") { $Destino = Join-Path $Proyecto "EXPORT" }

    $staging = Join-Path $env:TEMP "gns3_export_$([guid]::NewGuid().ToString('N'))"
    New-Item -ItemType Directory -Path "$staging\project-files" -Force | Out-Null

    Copy-Item $gns3.FullName "$staging\project.gns3"
    $readme = Join-Path $Proyecto "README.txt"
    if (Test-Path $readme) { Copy-Item $readme "$staging\README.txt" }

    $pf = Join-Path $Proyecto "project-files"
    $excluir = @("vmware", "virtualbox", "docker")
    if (Test-Path $pf) {
        Get-ChildItem $pf -Directory | Where-Object { $excluir -notcontains $_.Name } | ForEach-Object {
            Copy-Item $_.FullName "$staging\project-files\$($_.Name)" -Recurse
            Log "  + project-files/$($_.Name)" "ok"
        }
        Get-ChildItem $pf -Directory | Where-Object { $excluir -contains $_.Name } | ForEach-Object {
            Log "  - project-files/$($_.Name) omitido (no portable)" "aviso"
        }
    }

    New-Item -ItemType Directory -Path $Destino -Force | Out-Null
    $zip = Join-Path $env:TEMP "$nombre.zip"
    if (Test-Path $zip) { Remove-Item $zip -Force }
    Compress-Archive -Path "$staging\*" -DestinationPath $zip
    $salida = Join-Path $Destino "$nombre.gns3project"
    Move-Item $zip $salida -Force
    Remove-Item $staging -Recurse -Force

    $total = [IO.Compression.ZipFile]::OpenRead($salida).Entries.Count
    $kb = [math]::Round((Get-Item $salida).Length / 1KB)
    @{
        Exito    = $true
        Salida   = $salida
        KB       = $kb
        Entradas = $total
        Error    = ""
    }
}
