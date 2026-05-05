import 'package:intl/intl.dart';
import '../models/index.dart';

class MockData {
  static List<Service> getMockServices() {
    final now = DateTime.now();
    return [
      Service(
        id: 'service_1',
        name: 'Ônibus Premium Lisboa-Porto',
        description:
            'Viagem confortável com WiFi, tomadas e assentos reclinável',
        category: 'onibus',
        price: 25.50,
        iconUrl: 'https://via.placeholder.com/150',
        available: true,
        createdAt: now,
      ),
      Service(
        id: 'service_2',
        name: 'Comboio Alfa Lisboa-Covilhã',
        description: 'Viagem rápida e segura com primeira classe incluída',
        category: 'comboio',
        price: 45.00,
        iconUrl: 'https://via.placeholder.com/150',
        available: true,
        createdAt: now,
      ),
      Service(
        id: 'service_3',
        name: 'Voo TAP Lisboa-Porto',
        description: 'Voo direto com bebidas incluídas',
        category: 'aviao',
        price: 89.99,
        iconUrl: 'https://via.placeholder.com/150',
        available: true,
        createdAt: now,
      ),
      Service(
        id: 'service_4',
        name: 'Ferry Setúbal-Tróia',
        description: 'Travessia rápida com vistas panorâmicas',
        category: 'barco',
        price: 12.00,
        iconUrl: 'https://via.placeholder.com/150',
        available: false,
        createdAt: now,
      ),
      Service(
        id: 'service_5',
        name: 'Ônibus Express Porto-Braga',
        description: 'Serviço expresso com paradas mínimas',
        category: 'onibus',
        price: 15.75,
        iconUrl: 'https://via.placeholder.com/150',
        available: true,
        createdAt: now,
      ),
    ];
  }

  static List<Booking> getMockBookings() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrow4h = tomorrow.add(const Duration(hours: 4));

    return [
      Booking(
        id: 'booking_1',
        userId: 'user_1',
        serviceId: 'service_1',
        origin: 'Lisboa',
        destination: 'Porto',
        departureTime: tomorrow,
        arrivalTime: tomorrow4h,
        passengers: 2,
        totalPrice: 51.00,
        status: BookingStatus.confirmed,
        notes: 'Assento de janela preferido',
        createdAt: now,
      ),
      Booking(
        id: 'booking_2',
        userId: 'user_1',
        serviceId: 'service_3',
        origin: 'Lisboa - Humberto Delgado',
        destination: 'Porto - Francisco Sá Carneiro',
        departureTime: tomorrow.add(const Duration(days: 2)),
        arrivalTime: tomorrow
            .add(const Duration(days: 2))
            .add(const Duration(hours: 1, minutes: 15)),
        passengers: 1,
        totalPrice: 89.99,
        status: BookingStatus.pending,
        notes: '',
        createdAt: now,
      ),
      Booking(
        id: 'booking_3',
        userId: 'user_1',
        serviceId: 'service_2',
        origin: 'Lisboa - Santa Apolónia',
        destination: 'Covilhã',
        departureTime: now.subtract(const Duration(days: 7)),
        arrivalTime: now
            .subtract(const Duration(days: 7))
            .add(const Duration(hours: 3)),
        passengers: 1,
        totalPrice: 45.00,
        status: BookingStatus.completed,
        notes: 'Viagem completada com sucesso',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }

  static User getMockUser() {
    return User(
      id: 'user_1',
      email: 'utilisateur@pombus.com',
      name: 'João Silva',
      token: 'mock_jwt_token_123456',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}
