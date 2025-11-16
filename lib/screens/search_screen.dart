import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final products = await _apiService.getProducts(search: query);
      setState(() {
        _results = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
          ? const Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final product = _results[index];
                return ListTile(
                  leading: Image.network(product['image'], width: 50),
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price']}'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/product',
                    arguments: product['_id'],
                  ),
                );
              },
            ),
    );
  }
}
