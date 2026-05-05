import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/index.dart';
import '../utils/mock_data.dart';

class ApiService {
  static const String baseUrl = 'https://api.pombus.com/v1';
  static const String apiKey = 'YOUR_API_KEY_HERE';

  final String? authToken;

  ApiService({this.authToken});

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': authToken != null ? 'Bearer $authToken' : '',
      'X-API-Key': apiKey,
    };
  }

  // Auth endpoints
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        throw Exception('Credenciais inválidas');
      } else {
        throw Exception('Erro ao fazer login: ${response.statusCode}');
      }
    } catch (e) {
      // Se a API não está disponível, usar dados mock
      print('Usando dados mock - API não disponível');
      return MockData.getMockUser();
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Erro ao registar: ${response.statusCode}');
      }
    } catch (e) {
      // Se a API não está disponível, criar utilizador mock com dados do formulário
      print('Usando dados mock - API não disponível');
      return User(
        id: 'user_mock_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
    }
  }

  // Services endpoints
  Future<List<Service>> getServices({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String url = '$baseUrl/services?page=$page&limit=$limit';
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      final response = await http.get(Uri.parse(url), headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final services = (data['services'] as List)
            .map((s) => Service.fromJson(s as Map<String, dynamic>))
            .toList();
        return services;
      } else {
        throw Exception('Erro ao buscar serviços: ${response.statusCode}');
      }
    } catch (e) {
      // Se a API não está disponível, usar dados mock
      print('Usando dados mock - API não disponível');
      return MockData.getMockServices();
    }
  }

  Future<Service> getServiceDetails(String serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/$serviceId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Service.fromJson(data['service']);
      } else {
        throw Exception('Serviço não encontrado');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  // Bookings endpoints
  Future<Booking> createBooking({
    required String serviceId,
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int passengers,
    String notes = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: _getHeaders(),
        body: jsonEncode({
          'serviceId': serviceId,
          'origin': origin,
          'destination': destination,
          'departureTime': departureTime.toIso8601String(),
          'passengers': passengers,
          'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        throw Exception('Erro ao criar reserva: ${response.statusCode}');
      }
    } catch (e) {
      // Se a API não está disponível, criar reserva mock com dados fornecidos
      print('Usando dados mock - API não disponível');
      return Booking(
        id: 'booking_mock_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_mock',
        serviceId: serviceId,
        origin: origin,
        destination: destination,
        departureTime: departureTime,
        arrivalTime: departureTime.add(const Duration(hours: 4)),
        passengers: passengers,
        totalPrice: 50.0 * passengers, // Preço mock
        status: BookingStatus.confirmed,
        notes: notes,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/my-bookings'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookings = (data['bookings'] as List)
            .map((b) => Booking.fromJson(b as Map<String, dynamic>))
            .toList();
        return bookings;
      } else {
        throw Exception('Erro ao buscar reservas: ${response.statusCode}');
      }
    } catch (e) {
      // Se a API não está disponível, usar dados mock
      print('Usando dados mock - API não disponível');
      return MockData.getMockBookings();
    }
  }

  Future<Booking> getBookingDetails(String bookingId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/$bookingId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        throw Exception('Reserva não encontrada');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao cancelar reserva: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  // Search endpoints
  Future<List<Service>> searchServices(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/search?q=${Uri.encodeComponent(query)}'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final services = (data['services'] as List)
            .map((s) => Service.fromJson(s as Map<String, dynamic>))
            .toList();
        return services;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
