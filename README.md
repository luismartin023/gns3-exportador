# Exportador GNS3 Portable

Herramienta para empaquetar proyectos de GNS3 como `.gns3project` y
llevarlos a otra PC. El exportador oficial de GNS3 falla cuando el
proyecto tiene nodos VMware — esta herramienta arma el paquete a mano
con el mismo formato estándar.

## Uso

```
1. Descarga el repo (Code → Download ZIP) y descomprime
2. Doble clic en 0_ANTIVIRUS.bat   (una sola vez — excluye la carpeta de Defender)
3. Doble clic en Exportador GNS3.bat
4. Elige la carpeta de tu proyecto y el destino → EXPORTAR AHORA
```

Sale `TuProyecto.gns3project` listo para importar en otra PC con
`File → Open portable project`.

**¿Dónde está mi proyecto?** GNS3 los guarda normalmente en
`C:\Users\TU-USUARIO\GNS3\projects\NombreDelProyecto`.

## Avisos antes de usar

- **SmartScreen (pantalla azul)**: al abrir un .bat descargado Windows
  puede decir "protegió tu PC". Es normal con herramientas sin firma
  digital → clic en "Más información → Ejecutar de todas formas".
- **0_ANTIVIRUS.bat pide administrador**: agrega la carpeta a las
  exclusiones de Windows Defender. Si no tienes admin, salta este paso —
  el exportador funciona igual mientras tu antivirus no lo bloquee. Solo
  cubre Defender; con Avast/McAfee agrega la carpeta a sus exclusiones.
- **Imágenes IOS**: para que el proyecto *corra* en la otra PC hacen
  falta las mismas imágenes (ej. Cisco 3725). El archivo importa igual
  y GNS3 te dice exactamente cuál falta.

## Requisitos

- Windows con PowerShell (ya viene instalado)
- El `.gns3` del proyecto y su carpeta `project-files`

## Notas

- Las carpetas `vmware`, `virtualbox` y `docker` de `project-files` no se
  incluyen: sus discos dependen de la PC local y no son portables (ni el
  exportador oficial las empaqueta).
- Para que el proyecto **corra** en la otra PC hacen falta las mismas
  imágenes IOS (ej. Cisco 3725) — el archivo importa igual, GNS3 avisa
  qué imagen falta.
- Guía completa en `APP/GUIA.md`.

## Autor

Luis Martin Peña Mejia · 2023-4341 · UCE Punta Cana
