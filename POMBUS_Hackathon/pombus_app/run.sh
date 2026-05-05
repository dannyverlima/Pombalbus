#!/bin/bash

# Script rápido para executar a aplicação Flutter POMBUS
# Use: ./run.sh [macos|windows]

PLATFORM=${1:-macos}

echo "🚀 POMBUS Flutter Application"
echo "================================"

if [ "$PLATFORM" = "macos" ]; then
    echo "📱 Executando no macOS..."
    flutter pub get
    flutter run -d macos
elif [ "$PLATFORM" = "windows" ]; then
    echo "💻 Executando no Windows..."
    flutter pub get
    flutter run -d windows
else
    echo "Uso: ./run.sh [macos|windows]"
    exit 1
fi
