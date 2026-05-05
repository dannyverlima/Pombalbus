import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class BookingsProvider extends ChangeNotifier {
  final ApiService apiService;

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  BookingsProvider({required this.apiService});

  // Getters
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await apiService.getMyBookings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking({
    required String serviceId,
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int passengers,
    String notes = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final booking = await apiService.createBooking(
        serviceId: serviceId,
        origin: origin,
        destination: destination,
        departureTime: departureTime,
        passengers: passengers,
        notes: notes,
      );
      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await apiService.cancelBooking(bookingId);
      _bookings.removeWhere((b) => b.id == bookingId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
