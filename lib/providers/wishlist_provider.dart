import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WishlistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _wishlist = [];
  bool _isLoading = false;

  List<dynamic> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  Future<void> fetchWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      _wishlist = await _apiService.getWishlist();
    } catch (e) {
      print('Error fetching wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist(String productId) async {
    try {
      await _apiService.addToWishlist(productId);
      await fetchWishlist();
      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  Future<bool> removeFromWishlist(String productId) async {
    try {
      await _apiService.removeFromWishlist(productId);
      await fetchWishlist();
      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item['_id'] == productId);
  }

  void clearWishlist() {
    _wishlist = [];
    notifyListeners();
  }
}
