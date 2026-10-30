@echo off
title Exportador GNS3 Portable - PCalito Tools
chcp 65001 >nul
echo.
echo  ============================================
echo    EXPORTADOR GNS3 -^> .gns3project portable
echo  ============================================
echo.
echo  Este programa empaqueta tu proyecto de GNS3
echo  para llevarlo a otra PC.
echo.
echo  NECESITAS: la ruta de la CARPETA del proyecto
echo  (donde esta el archivo .gns3 y la carpeta
echo   project-files).
echo.
echo  Ejemplo:  C:\Users\Juan\GNS3\projects\mi_lab
echo.
set /p PROYECTO=  Pega la ruta del proyecto y Enter: 
set PROYECTO=%PROYECTO:"=%

if "%PROYECTO%"=="" (
    echo.
    echo  No pusiste ninguna ruta. Saliendo.
    pause
    exit /b 1
)

echo.
set /p DESTINO=  Carpeta destino (Enter = "%PROYECTO%\EXPORT"): 
set DESTINO=%DESTINO:"=%

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0LabPack.CLI.ps1" -Proyecto "%PROYECTO%" -Destino "%DESTINO%"

echo.
echo  ============================================
pause
