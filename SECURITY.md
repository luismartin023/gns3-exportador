# Política de Seguridad — LabPack

## Versiones con soporte

| Versión | Soporte          |
|---------|------------------|
| 1.2.x   | ✅ Versión actual |
| < 1.2   | ❌ Ya no          |

Usa siempre la última release del repositorio.

## Qué hace LabPack con tu PC (transparencia)

LabPack es una herramienta local: **no se conecta a internet ni envía
datos**. Los únicos cambios que toca en tu sistema:

- `0-Preparar-Antivirus.bat` agrega **únicamente la carpeta de LabPack**
  a las exclusiones de Windows Defender. No desactiva el antivirus ni
  excluye otras rutas. Requiere permisos de administrador y es opcional.
- Durante la exportación crea una carpeta temporal en `%TEMP%`
  (staging del ZIP) que se elimina al terminar.
- El archivo generado se guarda donde el usuario indique
  (o en `proyecto\EXPORT` por defecto).

El código es 100% visible: son scripts `.bat` y `.ps1` en texto plano —
puedes leerlos completos antes de ejecutarlos.

## Reportar una vulnerabilidad

Si encuentras un problema de seguridad, **no abras un issue público**.
Contacta directamente por GitHub a
[@luismartin023](https://github.com/luismartin023) describiendo el
problema. Responderé lo antes posible y la corrección se publicará en
una nueva release.

## Descargo

LabPack es software libre bajo licencia MIT: se entrega "tal cual", sin
garantía. LabPack **no está afiliado ni respaldado por GNS3 Technologies**;
"GNS3" es marca de sus respectivos propietarios. Cada usuario es
responsable del uso que le dé a la herramienta.

---

**MKZ COMPANY** — República Dominicana
