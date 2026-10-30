# Contribuir a LabPack

Gracias por querer mejorar LabPack. Es una herramienta pequeña, así que
las reglas también son pocas y claras.

## Cómo contribuir

1. Haz un **fork** del repositorio.
2. Crea una rama: `git checkout -b mejora/lo-que-sea`.
3. Haz tus cambios y pruébalos con un proyecto GNS3 real.
4. Abre un **Pull Request** explicando qué resuelve.

También puedes abrir un **issue** si encontraste un error: describe qué
hiciste, qué esperabas y qué pasó. Adjunta captura si es la ventana.

## Reglas del código

- **PowerShell con verbos aprobados** (`Export-`, `Get-`, `Write-`...).
  El analizador del editor no debe marcar warnings.
- La lógica de empaquetado va **solo en `APP/Core/`**. La ventana
  (`Interfaz/`) y la consola (`Consola/`) son adaptadores: no dupliques
  lógica ahí.
- Todo debe seguir siendo **portable**: rutas relativas (`%~dp0`,
  `$PSScriptRoot`), cero rutas absolutas ni dependencias que haya que
  instalar.
- Comentarios en español, directos, que expliquen el *por qué*.
- Los discos VMware/VirtualBox/Docker **nunca** se empacan — es un límite
  de GNS3, no una decisión nuestra.

## Reportar problemas

Abre un issue en
[github.com/luismartin023/gns3-exportador/issues](https://github.com/luismartin023/gns3-exportador/issues)
con el sistema operativo, el proyecto que intentabas exportar y el error
exacto.

---

**MKZ COMPANY** — República Dominicana
