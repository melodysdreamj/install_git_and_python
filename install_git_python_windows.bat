@echo off
Powershell -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0install_git_python_windows.ps1\"' -Verb RunAs}"
