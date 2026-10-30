# Changelog — LabPack

Historial de versiones de LabPack, el exportador portable de proyectos
GNS3. Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [1.2.0] — 2025-10-30

### Cambiado
- Renombrado completo de archivos a la convención `LabPack.*`:
  `LabPack.bat`, `LabPack.Core.ps1`, `LabPack.UI.ps1`,
  `LabPack.CLI.ps1`, `labpack.ico`, `labpack-banner.png`...
- `0_ANTIVIRUS.bat` → `0-Preparar-Antivirus.bat` (mismo paso 0, nombre
  autoexplicativo, sigue ordenando primero en la carpeta).

### Agregado
- Documentos del proyecto: `LICENSE` (MIT), `CHANGELOG.md`,
  `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`.
- Marca y autoría: MKZ COMPANY — Luis Martin Peña Mejia,
  República Dominicana.

## [1.1.0] — 2025-10-30

### Cambiado
- Reestructura interna por dominios: `APP/Core`, `APP/Interfaz`,
  `APP/Consola`, `APP/Recursos`, `APP/Docs`.
- La lógica de empaquetado vive una sola vez en `Core`
  (`Export-Gns3Project` con contrato `-OnLog`); la ventana y la consola
  son adaptadores que la consumen — se eliminó el código duplicado.

## [1.0.0] — 2025-10-29

### Agregado
- Primera versión estable: exportador portable de proyectos GNS3 que
  resuelve el fallo del exportador oficial con nodos VMware.
- Interfaz WinForms DPI-aware con log a color, consola interactiva,
  lanzador `.bat` raíz y script de exclusión de Windows Defender.
