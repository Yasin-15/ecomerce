import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _trackingData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracking();
  }

  Future<void> _loadTracking() async {
    try {
      final data = await _apiService.trackOrder(widget.orderId);
      setState(() {
        _trackingData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_trackingData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Tracking')),
        body: const Center(child: Text('Unable to load tracking information')),
      );
    }

    final statusHistory = _trackingData!['statusHistory'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${widget.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Status: ${_trackingData!['status']}'),
                    if (_trackingData!['trackingNumber'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tracking Number: ${_trackingData!['trackingNumber']}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length,
              itemBuilder: (context, index) {
                final history = statusHistory[statusHistory.length - 1 - index];
                return _buildTimelineItem(
                  history['status'] ?? '',
                  history['note'] ?? '',
                  history['timestamp'] ?? '',
                  index == 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String status,
    String note,
    String timestamp,
    bool isLatest,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isLatest ? Colors.pink : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            Container(width: 2, height: 60, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isLatest ? Colors.pink : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(note, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                _formatDate(timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
