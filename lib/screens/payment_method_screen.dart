import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;

  const PaymentMethodScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<dynamic> _paymentMethods = [];
  String? _selectedMethod;
  bool _isLoading = true;
  bool _isProcessing = false;

  // Payment form controllers
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _paypalEmailController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _cardNameController.dispose();
    _paypalEmailController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final apiService = ApiService();
      final methods = await apiService.getPaymentMethods();
      setState(() {
        _paymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading payment methods: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._paymentMethods.map(
                    (method) => _buildPaymentMethodCard(method),
                  ),
                  const SizedBox(height: 24),
                  if (_selectedMethod != null) _buildPaymentForm(),
                  const SizedBox(height: 24),
                  if (_selectedMethod != null)
                    ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Complete Payment',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPaymentMethodCard(dynamic method) {
    final isSelected = _selectedMethod == method['id'];
    final processingFee = method['processingFee'] ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.pink : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedMethod = method['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _getPaymentIcon(method['icon']),
                size: 32,
                color: isSelected ? Colors.pink : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.pink : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (processingFee > 0)
                      Text(
                        'Processing fee: \$${processingFee.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.pink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedMethod) {
      case 'stripe':
        return _buildCardForm();
      case 'paypal':
        return _buildPayPalForm();
      case 'bank_transfer':
        return _buildBankTransferForm();
      case 'cash_on_delivery':
        return _buildCashOnDeliveryInfo();
      case 'apple_pay':
      case 'google_pay':
        return _buildDigitalWalletInfo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              maxLength: 16,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cardExpiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cardCvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    maxLength: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PayPal Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _paypalEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'PayPal Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankTransferForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bank Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: 'Bank Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bankAccountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Account Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashOnDeliveryInfo() {
    return Card(
      color: Colors.orange.shade50,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'You will pay in cash when your order is delivered to your address. Please keep the exact amount ready.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalWalletInfo() {
    final walletName = _selectedMethod == 'apple_pay'
        ? 'Apple Pay'
        : 'Google Pay';
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  walletName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'You will be redirected to $walletName to complete your payment securely.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String icon) {
    switch (icon) {
      case 'credit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.payment;
      case 'apple':
        return Icons.apple;
      case 'google':
        return Icons.g_mobiledata;
      case 'account_balance':
        return Icons.account_balance;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.payment;
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      final apiService = ApiService();
      Map<String, dynamic> paymentDetails = {};

      switch (_selectedMethod) {
        case 'stripe':
          if (_cardNumberController.text.isEmpty ||
              _cardExpiryController.text.isEmpty ||
              _cardCvvController.text.isEmpty ||
              _cardNameController.text.isEmpty) {
            throw Exception('Please fill in all card details');
          }
          paymentDetails = {
            'cardNumber': _cardNumberController.text,
            'expiry': _cardExpiryController.text,
            'cvv': _cardCvvController.text,
            'name': _cardNameController.text,
          };
          break;
        case 'paypal':
          if (_paypalEmailController.text.isEmpty) {
            throw Exception('Please enter your PayPal email');
          }
          paymentDetails = {'email': _paypalEmailController.text};
          break;
        case 'bank_transfer':
          if (_bankAccountController.text.isEmpty ||
              _bankNameController.text.isEmpty) {
            throw Exception('Please fill in all bank details');
          }
          paymentDetails = {
            'accountNumber': _bankAccountController.text,
            'bankName': _bankNameController.text,
          };
          break;
        case 'cash_on_delivery':
          paymentDetails = {'confirmed': true};
          break;
        case 'apple_pay':
        case 'google_pay':
          // Simulate wallet token
          paymentDetails = {
            'token':
                'simulated_wallet_token_${DateTime.now().millisecondsSinceEpoch}',
          };
          break;
      }

      final result = await apiService.processPayment(
        widget.orderId,
        _selectedMethod!,
        paymentDetails,
      );

      if (mounted) {
        if (result['success'] == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/order-success',
            (route) => false,
          );
        } else {
          throw Exception(result['message'] ?? 'Payment failed');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
