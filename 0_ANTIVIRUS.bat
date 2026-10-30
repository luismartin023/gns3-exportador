@echo off
title Paso 0 - Permiso del antivirus
chcp 65001 >nul
echo.
echo  ============================================
echo    PASO 0 - EXCLUSION DEL ANTIVIRUS
echo  ============================================
echo.
echo  Los scripts de este paquete usan PowerShell,
echo  y algunos antivirus los revisan o bloquean.
echo.
echo  Esto agrega la carpeta EXPORTADOR_PORTABLE a
echo  las exclusiones de Windows Defender para que
echo  el antivirus no la toque.
echo.
echo  SOLO afecta a esta carpeta, nada mas.
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  Se necesitan permisos de administrador.
    echo  Solicitando elevacion...
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -Command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue; Write-Output 'Exclusion aplicada'" 
echo.
echo  Carpeta excluida: %~dp0
echo  Ya puedes usar el exportador sin problemas.
echo.
pause
