# Configuração da Aplicação POMBUS

## Variáveis de Ambiente

Criar arquivo `.env` na raiz do projeto (opcional para desenvolvimento local):

```
API_BASE_URL=https://api.pombus.com/v1
API_KEY=sua_chave_api_aqui
DEBUG=true
```

## Endpoints da API

A aplicação espera os seguintes endpoints:

### Autenticação
- `POST /auth/login` - Login do utilizador
- `POST /auth/register` - Registro de novo utilizador

### Serviços
- `GET /services` - Listar serviços
- `GET /services/:id` - Detalhes do serviço
- `GET /services/search?q=query` - Buscar serviços

### Reservas
- `POST /bookings` - Criar reserva
- `GET /bookings/my-bookings` - Listar minhas reservas
- `GET /bookings/:id` - Detalhes da reserva
- `POST /bookings/:id/cancel` - Cancelar reserva

## Formato de Resposta Esperado

### User
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "token": "jwt_token",
  "createdAt": "2025-05-05T10:00:00Z"
}
```

### Service
```json
{
  "id": "service_id",
  "name": "Service Name",
  "description": "Service Description",
  "category": "onibus|comboio|aviao|barco",
  "price": 29.99,
  "iconUrl": "https://...",
  "available": true,
  "createdAt": "2025-05-05T10:00:00Z"
}
```

### Booking
```json
{
  "id": "booking_id",
  "userId": "user_id",
  "serviceId": "service_id",
  "origin": "Origin City",
  "destination": "Destination City",
  "departureTime": "2025-05-10T14:00:00Z",
  "arrivalTime": "2025-05-10T18:00:00Z",
  "passengers": 2,
  "totalPrice": 59.98,
  "status": "confirmed|pending|completed|cancelled",
  "notes": "Additional notes",
  "createdAt": "2025-05-05T10:00:00Z"
}
```

## Desenvolvimento Local

Para testar sem API real, comentar as chamadas HTTP e retornar dados mock em `lib/services/api_service.dart`.

## Build e Deploy

### macOS
```bash
flutter build macos --release
# App disponível em: build/macos/Build/Products/Release/pombus_app.app
```

### Windows
```bash
flutter build windows --release
# Executável disponível em: build\windows\runner\Release\pombus_app.exe
```
