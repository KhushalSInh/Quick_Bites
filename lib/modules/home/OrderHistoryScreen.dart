// OrderHistoryScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("user_id");

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'User not found. Please login again.';
        });
        return;
      }

      final response = await ApiService.request(
        url: ApiDetails.OrderHistory,
        method: "POST",
        body: {"user_id": userId},
      );

      if (response['success'] == true) {
        setState(() {
          _orders = response['orders'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = response['message'] ?? 'Failed to load order history';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Network error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.orange),
            onPressed: _loadOrderHistory,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
          : _hasError
              ? _buildError()
              : _orders.isEmpty
                  ? _buildEmpty()
                  : _buildOrderList(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          SizedBox(height: 16),
          Text(
            'Loading your orders...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadOrderHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            "No Orders Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven't placed any orders yet",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return RefreshIndicator(
      onRefresh: _loadOrderHistory,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderNumber = order['order_number'] ?? 'N/A';
    final totalAmount = order['total_amount'] ?? '0.00';
    final orderStatus = order['order_status'] ?? 'pending';
    final createdAt = order['created_at'] ?? '';
    final paymentMethod = order['payment_method'] ?? 'cash_on_delivery';
    final items = order['items'] is List ? order['items'] : [];

    // Parse items if they're stored as JSON string
    List<dynamic> parsedItems = [];
    if (items is String) {
      try {
        parsedItems = json.decode(items);
      } catch (e) {
        parsedItems = [];
      }
    } else {
      parsedItems = items;
    }

    final itemCount = parsedItems.fold<int>(0, (int sum, dynamic item) {
      final int qty = item['qty'] is int ? item['qty'] as int : int.tryParse(item['qty'].toString()) ?? 0;
      return sum + qty;
    });


    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #$orderNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(orderStatus),
              ],
            ),

            const SizedBox(height: 12),

            // Order Details
            Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  '$itemCount item${itemCount != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.payment_rounded,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  _getPaymentMethodText(paymentMethod),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Items Preview
            if (parsedItems.isNotEmpty) ...[
              _buildItemsPreview(parsedItems),
              const SizedBox(height: 12),
            ],

            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹$totalAmount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showOrderDetails(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        statusText = 'Confirmed';
        break;
      case 'preparing':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        statusText = 'Preparing';
        break;
      case 'out_for_delivery':
        backgroundColor = Colors.deepOrange.withOpacity(0.1);
        textColor = Colors.deepOrange;
        statusText = 'Out for Delivery';
        break;
      case 'delivered':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        statusText = 'Delivered';
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        statusText = _capitalizeFirstLetter(status);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildItemsPreview(List<dynamic> items) {
    final previewItems = items.take(2).toList();
    final remainingItems = items.length - 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: previewItems.map<Widget>((item) {
            final itemName = _getItemName(item['item_id']);
            final quantity = item['qty']?.toString() ?? '1';
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    '• $itemName',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (remainingItems > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+ $remainingItems more item${remainingItems != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  String _getItemName(dynamic itemId) {
    // You can replace this with actual item names from your database
    // For now, using generic names based on item ID
    final id = itemId is int ? itemId : int.tryParse(itemId.toString()) ?? 0;
    final names = {
      1: 'Margherita Pizza',
      2: 'Pepperoni Pizza',
      3: 'Chicken Burger',
      4: 'Veg Burger',
      5: 'French Fries',
      6: 'Coca Cola',
    };
    return names[id] ?? 'Item #$itemId';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year} at ${_formatTime(date)}';
    } catch (e) {
      return dateString;
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'online_payment':
        return 'Online Payment';
      default:
        return _capitalizeFirstLetter(method.replaceAll('_', ' '));
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }
}

// Order Details Bottom Sheet
class OrderDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsBottomSheet({super.key, required this.order});

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'online_payment':
        return 'Online Payment';
      default:
        return _capitalizeFirstLetter(method.replaceAll('_', ' '));
    }
  }

  String _getItemName(dynamic itemId) {
    final id = itemId is int ? itemId : int.tryParse(itemId.toString()) ?? 0;
    final names = {
      1: 'Margherita Pizza',
      2: 'Pepperoni Pizza',
      3: 'Chicken Burger',
      4: 'Veg Burger',
      5: 'French Fries',
      6: 'Coca Cola',
    };
    return names[id] ?? 'Item #$itemId';
  }

  @override
  Widget build(BuildContext context) {
    final orderNumber = order['order_number'] ?? 'N/A';
    final totalAmount = order['total_amount'] ?? '0.00';
    final orderStatus = order['order_status'] ?? 'pending';
    final createdAt = order['created_at'] ?? '';
    final paymentMethod = order['payment_method'] ?? 'cash_on_delivery';
    final items = order['items'] is List ? order['items'] : [];

    // Parse items
    List<dynamic> parsedItems = [];
    if (items is String) {
      try {
        parsedItems = json.decode(items);
      } catch (e) {
        parsedItems = [];
      }
    } else {
      parsedItems = items;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  "Order Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Order Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Order Number', orderNumber),
                    _buildDetailRow('Order Date', _formatDate(createdAt)),
                    _buildDetailRow('Payment Method', _getPaymentMethodText(paymentMethod)),
                    _buildDetailRow('Status', _capitalizeFirstLetter(orderStatus)),
                  ],
                ),
              ),
            ),
          ),

          // Items List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...parsedItems.map<Widget>((item) {
                      final itemName = _getItemName(item['item_id']);
                      final quantity = item['qty']?.toString() ?? '1';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                itemName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'Qty: $quantity',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Total Amount
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹$totalAmount',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}