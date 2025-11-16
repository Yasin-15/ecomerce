import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _couponController = TextEditingController();
  String _paymentMethod = 'Credit Card';
  bool _isLoading = false;
  bool _isValidatingCoupon = false;
  double _discount = 0;
  String? _appliedCoupon;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your full address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Coupon Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        border: const OutlineInputBorder(),
                        enabled: _appliedCoupon == null,
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _appliedCoupon == null
                        ? (_isValidatingCoupon ? null : _validateCoupon)
                        : _removeCoupon,
                    child: _isValidatingCoupon
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_appliedCoupon == null ? 'Apply' : 'Remove'),
                  ),
                ],
              ),
              if (_appliedCoupon != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Coupon "$_appliedCoupon" applied! You saved \$${_discount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              RadioListTile(
                title: const Text('Credit Card'),
                value: 'Credit Card',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              RadioListTile(
                title: const Text('Debit Card'),
                value: 'Debit Card',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              RadioListTile(
                title: const Text('Cash on Delivery'),
                value: 'Cash on Delivery',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('\$${cart.total.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping:'),
                        Text('\$${(5.00).toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(cart.total + 5.00).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Place Order', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateCoupon() async {
    if (_couponController.text.isEmpty) return;

    setState(() => _isValidatingCoupon = true);

    try {
      final apiService = ApiService();
      final cart = context.read<CartProvider>();
      final result = await apiService.validateCoupon(
        _couponController.text,
        cart.total + 5.00,
      );

      if (result['valid'] == true) {
        setState(() {
          _discount = double.parse(result['coupon']['discount']);
          _appliedCoupon = _couponController.text.toUpperCase();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coupon applied successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() => _isValidatingCoupon = false);
    }
  }

  void _removeCoupon() {
    setState(() {
      _discount = 0;
      _appliedCoupon = null;
      _couponController.clear();
    });
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final cart = context.read<CartProvider>();
      final totalAmount = cart.total + 5.00 - _discount;

      final order = await apiService.createOrder(
        _addressController.text,
        _paymentMethod,
        couponCode: _appliedCoupon,
        discount: _discount > 0 ? _discount : null,
      );

      if (_appliedCoupon != null) {
        await apiService.applyCoupon(_appliedCoupon!);
      }

      if (mounted) {
        await context.read<CartProvider>().fetchCart();

        // Navigate to payment method selection
        Navigator.pushNamed(
          context,
          '/payment-method',
          arguments: {'orderId': order['_id'], 'totalAmount': totalAmount},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
