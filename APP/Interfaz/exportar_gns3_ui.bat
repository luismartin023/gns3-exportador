@echo off
title Exportador GNS3 - Ventana
powershell -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0exportar_gns3_ui.ps1"
