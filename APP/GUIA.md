# Exportador GNS3 Portable — Guía

Empaqueta cualquier proyecto de GNS3 como `.gns3project` para llevarlo a
otra PC. Arregla el problema del exportador oficial de GNS3, que falla con
proyectos que tienen VMs de VMware.

## Estructura

```
EXPORTADOR_PORTABLE/
├── 0_ANTIVIRUS.bat       ← PASO 0: ejecútalo primero (excluye la carpeta de Defender)
├── Exportador GNS3.bat   ← el lanzador (doble clic abre la ventana)
└── APP/                  ← todo lo demás: scripts, ícono, esta guía
    ├── exportar_gns3_ui.ps1   (la ventana)
    ├── exportar_gns3_ui.bat   (lanza la ventana desde bat)
    ├── exportar_gns3.bat      (consola con preguntas)
    ├── exportar_gns3.ps1      (consola / terminal)
    ├── icono.ico
    └── GUIA.md
```

## Uso rápido

0. **Primero:** doble clic en `0_ANTIVIRUS.bat` — pide admin y excluye
   la carpeta de Windows Defender (así no revisa ni bloquea los scripts)
1. Doble clic en `Exportador GNS3.bat` (raíz) — abre la ventana
2. `Examinar...` → elige **la carpeta del proyecto** (donde está el `.gns3`
   y `project-files`)
3. `Examinar...` en destino (o déjalo vacío → `tuProyecto\EXPORT`)
4. `EXPORTAR AHORA` → el log muestra qué se empacó y sale el aviso final

Ejemplo de ruta válida:

```
C:\Users\Juan\GNS3\projects\mi_lab
```

## Uso por terminal

```powershell
powershell -File APP\exportar_gns3.ps1 -Proyecto "C:\ruta\del\proyecto"
# con destino propio:
powershell -File APP\exportar_gns3.ps1 -Proyecto "C:\ruta\del\proyecto" -Destino "D:\salida"
```

## Qué empaca y qué no

| Incluye | No incluye |
|---|---|
| `project.gns3` (la topología) | `project-files\vmware\` |
| `README.txt` | `project-files\virtualbox\` |
| `project-files\dynamips\` (configs) | `project-files\docker\` |
| `project-files\images\` | |
| `project-files\captures\` (pcap) | |
| Todo lo demás de `project-files\` | |

Las carpetas de VMs se omiten porque sus discos dependen de la PC local —
no son portables ni siquiera para el exportador oficial de GNS3.

## Importar en la otra PC

1. `File → Open portable project` en GNS3
2. Selecciona el `.gns3project`
3. GNS3 lo descomprime y abre la topología

**Lo que puede salir al importar (no son errores del archivo):**

- **"Imagen no encontrada"**: la otra PC necesita las mismas imágenes IOS
  (ej. Cisco 3725). GNS3 avisa qué imagen falta — se agrega en
  `Preferences → IOS routers` (o el tipo que corresponda).
- **Nodos VMware faltantes**: si el proyecto tenía VMs de VMware, esos
  nodos no existen en la otra PC. Los routers/switches Dynamips cargan
  normal con sus configs.
- **El `.gns3project` importa sin errores de formato** — es el estándar
  oficial, un ZIP con estructura fija.

## Si el exportador oficial ya funcionó para tu proyecto

Si tu proyecto no tiene VMware y el export oficial te sirve, úsalo — este
script hace exactamente lo mismo. Existe para cuando el oficial falla.
