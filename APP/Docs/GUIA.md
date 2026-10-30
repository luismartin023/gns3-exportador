# LabPack — Exportador GNS3 Portable · Guía

Empaqueta cualquier proyecto de GNS3 como `.gns3project` para llevarlo a
otra PC. Arregla el problema del exportador oficial de GNS3, que falla con
proyectos que tienen VMs de VMware.

## Estructura

```
EXPORTADOR_PORTABLE/
├── 0-Preparar-Antivirus.bat  ← PASO 0: ejecútalo primero (excluye la carpeta de Defender)
├── LabPack.bat               ← el lanzador (doble clic abre la ventana)
├── README.md · LICENSE · CHANGELOG · CONTRIBUTING · CODE_OF_CONDUCT · SECURITY
└── APP/                      ← organizada por dominios
    ├── Core/                 ← dominio: la logica de empaquetado (una sola vez)
    │   └── LabPack.Core.ps1  (Find-Gns3File + Export-Gns3Project)
    ├── Interfaz/             ← adaptador UI: la ventana
    │   ├── LabPack.UI.ps1
    │   └── LabPack.UI.bat
    ├── Consola/              ← adaptador CLI: consola con preguntas
    │   ├── LabPack.CLI.ps1
    │   └── LabPack.CLI.bat
    ├── Recursos/             ← labpack.ico, labpack-logo.png, labpack-banner.png, captura
    └── Docs/                 ← esta guia
```

## Uso rápido

0. **Primero:** doble clic en `0-Preparar-Antivirus.bat` — pide admin y
   excluye la carpeta de Windows Defender (así no revisa ni bloquea los scripts)
1. Doble clic en `LabPack.bat` (raíz) — abre la ventana
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
powershell -File APP\Consola\LabPack.CLI.ps1 -Proyecto "C:\ruta\del\proyecto"
# con destino propio:
powershell -File APP\Consola\LabPack.CLI.ps1 -Proyecto "C:\ruta\del\proyecto" -Destino "D:\salida"
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

## Avisos antes de usar

- **SmartScreen (pantalla azul)**: al abrir un .bat descargado Windows
  puede decir "protegió tu PC". Es normal con herramientas sin firma
  digital → "Más información → Ejecutar de todas formas".
- **0-Preparar-Antivirus.bat pide administrador**: excluye la carpeta de Windows
  Defender. Sin admin, salta el paso — el exportador funciona igual.
  Solo cubre Defender; con otro antivirus agrega la carpeta a mano.

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

---

**LabPack** es un desarrollo de **MKZ COMPANY** — Luis Martin Peña Mejia,
fundador y CTO. Hecho en la República Dominicana 🇩🇴
Licencia MIT · LabPack no está afiliado ni respaldado por GNS3 Technologies.
