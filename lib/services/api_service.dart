import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _handleResponse(response);
  }

  // Products
  Future<List<dynamic>> getProducts({String? category, String? search}) async {
    String url = '$baseUrl/products';
    if (category != null || search != null) {
      url += '?';
      if (category != null) url += 'category=$category&';
      if (search != null) url += 'search=$search';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProduct(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Cart
  Future<Map<String, dynamic>> getCart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: await getHeaders(),
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> removeFromCart(String productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/remove/$productId'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Orders
  Future<List<dynamic>> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createOrder(
    String address,
    String paymentMethod, {
    String? couponCode,
    double? discount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await getHeaders(),
      body: jsonEncode({
        'shippingAddress': address,
        'paymentMethod': paymentMethod,
        if (couponCode != null) 'couponCode': couponCode,
        if (discount != null) 'discount': discount,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId/track'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Admin - Dashboard Stats
  Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/stats'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Admin - Products
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/products'),
      headers: await getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/products/$id'),
      headers: await getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/products/$id'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Admin - Orders
  Future<List<dynamic>> getAdminOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/orders'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/orders/$orderId/status'),
      headers: await getHeaders(),
      body: jsonEncode({'status': status}),
    );
    return _handleResponse(response);
  }

  // Admin - Users
  Future<List<dynamic>> getAdminUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateUserAdminStatus(
    String userId,
    bool isAdmin,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/users/$userId/admin'),
      headers: await getHeaders(),
      body: jsonEncode({'isAdmin': isAdmin}),
    );
    return _handleResponse(response);
  }

  // Wishlist
  Future<List<dynamic>> getWishlist() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addToWishlist(String productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wishlist/add/$productId'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> removeFromWishlist(String productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/remove/$productId'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> checkWishlist(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/check/$productId'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  // Payments
  Future<List<dynamic>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/methods'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> processPayment(
    String orderId,
    String paymentMethod,
    Map<String, dynamic> paymentDetails,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/process'),
      headers: await getHeaders(),
      body: jsonEncode({
        'orderId': orderId,
        'paymentMethod': paymentMethod,
        'paymentDetails': paymentDetails,
      }),
    );
    return _handleResponse(response);
  }

  // Coupons
  Future<Map<String, dynamic>> validateCoupon(
    String code,
    double orderAmount,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coupons/validate'),
      headers: await getHeaders(),
      body: jsonEncode({'code': code, 'orderAmount': orderAmount}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> applyCoupon(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coupons/apply'),
      headers: await getHeaders(),
      body: jsonEncode({'code': code}),
    );
    return _handleResponse(response);
  }

  // Admin - Coupons
  Future<List<dynamic>> getAdminCoupons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/coupons'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createCoupon(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/coupons'),
      headers: await getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateCoupon(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/coupons/$id'),
      headers: await getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteCoupon(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/coupons/$id'),
      headers: await getHeaders(),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Request failed');
    }
  }
}
