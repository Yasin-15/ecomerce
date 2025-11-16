import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _product;
  bool _isLoading = true;
  int _quantity = 1;
  bool _isInWishlist = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
    _checkWishlist();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await _apiService.getProduct(widget.productId);
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkWishlist() async {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    await wishlistProvider.fetchWishlist();
    setState(() {
      _isInWishlist = wishlistProvider.isInWishlist(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_product!['name']),
        actions: [
          IconButton(
            icon: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: _isInWishlist ? Colors.red : null,
            ),
            onPressed: _toggleWishlist,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              _product!['image'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product!['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        ' ${_product!['rating']} (${_product!['reviews']} reviews)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${_product!['price']}',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _product!['description'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Quantity: ', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    try {
      await context.read<CartProvider>().addToCart(_product!['_id'], _quantity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _toggleWishlist() async {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );

    if (_isInWishlist) {
      final success = await wishlistProvider.removeFromWishlist(
        widget.productId,
      );
      if (success && mounted) {
        setState(() => _isInWishlist = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
      }
    } else {
      final success = await wishlistProvider.addToWishlist(widget.productId);
      if (success && mounted) {
        setState(() => _isInWishlist = true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Added to wishlist')));
      }
    }
  }
}
