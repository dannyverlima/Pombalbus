@echo off
REM Script para executar a aplicação Flutter POMBUS no Windows

echo.
echo 🚀 POMBUS Flutter Application
echo ================================
echo 💻 Executando no Windows...
echo.

call flutter pub get
call flutter run -d windows

pause
