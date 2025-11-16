import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _selectedCategory;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchProducts({String? category, String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.getProducts(
        category: category,
        search: search,
      );
      _selectedCategory = category;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    fetchProducts(category: category);
  }
}
