# 🚀 Guia Rápido de Início - POMBUS Flutter App

## ✅ O que foi criado

Uma aplicação Flutter **completa e profissional** para gerenciar serviços de transporte, com suporte total para **macOS** e **Windows**.

## 📋 Checklist de Funcionalidades Implementadas

- ✅ **Autenticação**: Login e registro com armazenamento seguro de tokens
- ✅ **Listagem de Serviços**: Com busca, filtros por categoria
- ✅ **Detalhes do Serviço**: Visualização completa e formulário de reserva
- ✅ **Sistema de Reservas**: Criar, visualizar, cancelar reservas
- ✅ **Perfil do Utilizador**: Configurações e logout
- ✅ **Interface Moderna**: Design responsivo com Material Design 3
- ✅ **Gerenciamento de Estado**: Usando Provider pattern
- ✅ **Armazenamento Local**: SharedPreferences para persistência

## 🎯 Próximos Passos (Essencial)

### 1️⃣ Configurar API (OBRIGATÓRIO)

Abrir o ficheiro:
```
pombus_app/lib/services/api_service.dart
```

E atualizar as credenciais:
```dart
static const String baseUrl = 'https://api.pombus.com/v1';  // URL real da API
static const String apiKey = 'YOUR_API_KEY_HERE';            // Sua chave API
```

### 2️⃣ Instalar Dependências

```bash
cd /Users/valass/POMBUS_Hackathon/pombus_app
flutter pub get
```

### 3️⃣ Executar a Aplicação

**No macOS:**
```bash
flutter run -d macos
```

**No Windows:**
```bash
flutter run -d windows
```

Ou use o script:
```bash
chmod +x setup.sh
./setup.sh
```

## 📁 Estrutura do Projeto

```
pombus_app/
├── lib/
│   ├── main.dart                    # Entrada com Provider setup
│   ├── models/                      # User, Service, Booking
│   ├── services/                    # API e Autenticação
│   ├── providers/                   # Estado compartilhado
│   ├── screens/                     # 7 telas principais
│   ├── widgets/                     # Componentes reutilizáveis
│   └── utils/                       # Dados mock e utilitários
├── pubspec.yaml                     # Dependências
├── CONFIG.md                        # Documentação técnica
├── run.sh / run.bat                # Scripts de execução
└── setup.sh                        # Script de setup interativo
```

## 🔐 Fluxo de Autenticação

1. **Login/Register** → API valida credenciais
2. **Token armazenado** → SharedPreferences
3. **Requisições autenticadas** → Header `Authorization: Bearer <token>`
4. **Logout** → Token removido, volta ao Login

## 📱 Fluxo da Aplicação

```
Login → Home (Serviços) → Detalhes Serviço → Reserva
                ↓                               ↓
            Minhas Reservas → Detalhes Reserva
                ↓
            Perfil → Logout
```

## 🛠️ Dependências Usadas

| Pacote | Versão | Função |
|--------|--------|--------|
| provider | 6.0.0 | Gerenciamento de estado |
| http | 1.1.0 | Requisições HTTP |
| shared_preferences | 2.2.0 | Armazenamento local |
| intl | 0.19.0 | Formatação datas/moedas |
| cached_network_image | 3.3.0 | Cache de imagens |
| connectivity_plus | 5.0.0 | Verificar conectividade |

## 🎨 Tema da Aplicação

- **Cor Primária**: Deep Orange (#FF6F00)
- **Design System**: Material Design 3
- **Modo**: Responsivo (desktop-first)

## 📝 Dados de Teste (Mock)

Para testar localmente sem API real:

```dart
// Em lib/utils/mock_data.dart
import 'utils/mock_data.dart';

final services = MockData.getMockServices();
final bookings = MockData.getMockBookings();
```

## ⚙️ Configuração de API esperada

A API deve responder com JSON nos teus endpoints. Ver `CONFIG.md` para o schema completo.

## 🐛 Troubleshooting Comum

| Erro | Solução |
|------|---------|
| "Flutter not found" | Instalar Flutter do https://flutter.dev |
| Erro de compilação macOS | `flutter clean && flutter pub get` |
| Erro de compilação Windows | Verificar Visual Studio Build Tools |
| Erro de conexão API | Verificar URL base e chave API |

## 📖 Ficheiros Importantes

- [README.md](./README.md) - Documentação completa
- [CONFIG.md](./CONFIG.md) - Configuração e endpoints
- [lib/main.dart](./lib/main.dart) - Estrutura principal

## 🎓 Para Personalizar

1. **Mudar cores**: `lib/main.dart` - `primaryColor`
2. **Adicionar serviços**: `lib/models/service.dart`
3. **Novos endpoints**: `lib/services/api_service.dart`
4. **Novas telas**: Adicionar em `lib/screens/`

## 📦 Build para Release

**macOS:**
```bash
flutter build macos --release
```

**Windows:**
```bash
flutter build windows --release
```

## 🚀 Deploy

- **macOS**: Usar notarização da Apple
- **Windows**: Assinar com certificado digital (recomendado)

---

**Status**: ✅ Pronto para desenvolvimento e testes
**Última atualização**: 5 de maio de 2025
**Versão**: 1.0.0
