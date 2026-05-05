import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class ServicesProvider extends ChangeNotifier {
  final ApiService apiService;

  List<Service> _services = [];
  List<Service> _filteredServices = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';
  int _currentPage = 1;

  ServicesProvider({required this.apiService});

  // Getters
  List<Service> get services =>
      _filteredServices.isEmpty ? _services : _filteredServices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  Future<void> loadServices({String? category}) async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    try {
      _services = await apiService.getServices(
        category: category,
        page: _currentPage,
      );
      _selectedCategory = category ?? '';
      _filteredServices = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreServices() async {
    _currentPage++;
    try {
      final moreServices = await apiService.getServices(
        category: _selectedCategory.isEmpty ? null : _selectedCategory,
        page: _currentPage,
      );
      _services.addAll(moreServices);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      _filteredServices = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredServices = await apiService.searchServices(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _filteredServices = [];
    notifyListeners();
  }
}
