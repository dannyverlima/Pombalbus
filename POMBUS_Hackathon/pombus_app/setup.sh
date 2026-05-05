#!/bin/bash

# Script de setup e compilação para POMBUS Flutter App

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   POMBUS Flutter Application Setup         ║"
echo "║   Serviços de Transporte Premium           ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado!"
    echo "Por favor instale Flutter de: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter ($(flutter --version | head -1))"

# Instalar/atualizar dependências
echo ""
echo "📦 Instalando dependências..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Erro ao instalar dependências"
    exit 1
fi

echo "✅ Dependências instaladas com sucesso"

# Menu de seleção
echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   Selecione a plataforma para compilar    ║"
echo "╠════════════════════════════════════════════╣"
echo "║  1) macOS                                  ║"
echo "║  2) Windows                                ║"
echo "║  3) Limpar e recompilação completa        ║"
echo "║  4) Sair                                   ║"
echo "╚════════════════════════════════════════════╝"
echo ""
read -p "Escolha uma opção (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Compilando para macOS..."
        flutter run -d macos
        ;;
    2)
        echo ""
        echo "🚀 Compilando para Windows..."
        flutter run -d windows
        ;;
    3)
        echo ""
        echo "🧹 Limpando arquivos anteriores..."
        flutter clean
        echo "📦 Reinstalando dependências..."
        flutter pub get
        echo ""
        echo "🚀 Compilando do zero..."
        read -p "Plataforma (macos/windows): " platform
        if [ "$platform" = "macos" ]; then
            flutter run -d macos
        elif [ "$platform" = "windows" ]; then
            flutter run -d windows
        else
            echo "❌ Plataforma inválida"
        fi
        ;;
    4)
        echo "👋 Até logo!"
        exit 0
        ;;
    *)
        echo "❌ Opção inválida"
        exit 1
        ;;
esac

echo ""
echo "✅ Configuração completa!"
