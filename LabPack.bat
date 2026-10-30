@echo off
rem Lanzador portable - abre la ventana del exportador
powershell -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0APP\Interfaz\LabPack.UI.ps1"
