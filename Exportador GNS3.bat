@echo off
rem Lanzador portable - abre la ventana del exportador
powershell -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0APP\exportar_gns3_ui.ps1"
