import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _cart;
  bool _isLoading = false;

  Map<String, dynamic>? get cart => _cart;
  bool get isLoading => _isLoading;
  int get itemCount => _cart?['items']?.length ?? 0;
  double get total => (_cart?['total'] ?? 0).toDouble();

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cart = await _apiService.getCart();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    try {
      _cart = await _apiService.addToCart(productId, quantity);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      _cart = await _apiService.removeFromCart(productId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
