// ignore_for_file: file_names, non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/CartModel.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/Data/Api/AddModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  UserAdd? _selectedAddress;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
    _loadUserId();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  void _loadDefaultAddress() async {
    final addressBox = Hive.box<UserAdd>('userAddressBox');
    final addresses = addressBox.values.toList();
    
    // Find default address or select first one
    final defaultAddress = addresses.firstWhere(
      (address) => address.isDefault == "1",
      orElse: () => addresses.isNotEmpty ? addresses.first : UserAdd(
        id: '',
        userId: '',
        type: '',
        name: '',
        pincode: '',
        state: '',
        district: '',
        city: '',
        al1: '',
        al2: '',
        createdAt: '',
        isDefault: '',
      ),
    );
    
    if (mounted) {
      setState(() {
        _selectedAddress = defaultAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Cart Items
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<CartItem>('cartBox').listenable(),
                builder: (context, Box<CartItem> box, _) {
                  final cartItems = box.values.toList();
                  
                  if (cartItems.isEmpty) {
                    return _buildEmptyCart();
                  }
                  
                  return Column(
                    children: [
                      // Cart Items List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _buildCartItem(item, box);
                          },
                        ),
                      ),
                      
                      // Checkout Section
                      _buildCheckoutSection(cartItems),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey[700],
          ),
          const SizedBox(width: 8),
          const Text(
            "My Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: Hive.box<CartItem>('cartBox').listenable(),
            builder: (context, Box<CartItem> box, _) {
              final itemCount = box.values.fold<int>(0, (sum, item) => sum + item.quantity);
              return Badge(
                label: Text(itemCount.toString()),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded),
                  onPressed: () {},
                  color: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, Box<CartItem> box) {
    var ImageBase = ApiDetails.ip;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Food Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _getImageUrl(item.image, ImageBase),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.fastfood_rounded,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${item.price} each",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      // Decrease Button
                      GestureDetector(
                        onTap: () => _updateQuantity(box, item, item.quantity - 1),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: item.quantity > 1 ? Colors.orange : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: item.quantity > 1 ? Colors.white : Colors.grey[500],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Quantity Display
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Increase Button
                      GestureDetector(
                        onTap: () => _updateQuantity(box, item, item.quantity + 1),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Total Price
                      Text(
                        "₹${item.totalPrice}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Remove Button
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
                        onPressed: () => _removeItem(box, item),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(List<CartItem> cartItems) {
    final subtotal = cartItems.fold<int>(0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 40;
    final tax = (subtotal * 0.05).round();
    final total = subtotal + deliveryFee + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price Breakdown
          _buildPriceRow("Subtotal", "₹$subtotal"),
          _buildPriceRow("Delivery Fee", "₹$deliveryFee"),
          _buildPriceRow("Tax (5%)", "₹$tax"),
          const Divider(height: 20),
          _buildPriceRow(
            "Total Amount",
            "₹$total",
            isTotal: true,
          ),
          
          const SizedBox(height: 16),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCheckoutBottomSheet(context, total),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add some delicious food to get started!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Start Shopping",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(Box<CartItem> box, CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(box, item);
      return;
    }

    final itemKey = _findItemKey(box, item);
    if (itemKey != null) {
      box.put(itemKey, item.copyWith(quantity: newQuantity));
    }
  }

  void _removeItem(Box<CartItem> box, CartItem item) {
    final itemKey = _findItemKey(box, item);
    if (itemKey != null) {
      box.delete(itemKey);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed ${item.name} from cart'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  dynamic _findItemKey(Box<CartItem> box, CartItem item) {
    for (var i = 0; i < box.length; i++) {
      final currentItem = box.getAt(i);
      if (currentItem?.id == item.id) {
        return box.keyAt(i);
      }
    }
    return null;
  }

  void _showCheckoutBottomSheet(BuildContext context, int totalAmount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutBottomSheet(
        totalAmount: totalAmount,
        selectedAddress: _selectedAddress,
        userId: _userId,
        onAddressSelected: (address) {
          setState(() {
            _selectedAddress = address;
          });
        },
        onOrderConfirmed: () {
          _processOrder(context, totalAmount);
        },
      ),
    );
  }

  void _processOrder(BuildContext context, int totalAmount) {
    final cartBox = Hive.box<CartItem>('cartBox');
    cartBox.clear();
    
    Navigator.pop(context); // Close bottom sheet
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed successfully! Total: ₹$totalAmount'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _getImageUrl(String imagePath, String imageBase) {
    try {
      String cleanedPath = imagePath.replaceAll(r'\', '/');
      
      if (cleanedPath.startsWith('http')) return cleanedPath;
      
      while (cleanedPath.startsWith('/')) {
        cleanedPath = cleanedPath.substring(1);
      }
      
      if (!cleanedPath.contains('quickbites')) {
        cleanedPath = 'quickbites/$cleanedPath';
      }
      
      return 'http://$imageBase/$cleanedPath';
      
    } catch (e) {
      return 'https://via.placeholder.com/150?text=No+Image';
    }
  }
}

// Checkout Bottom Sheet Widget
class CheckoutBottomSheet extends StatefulWidget {
  final int totalAmount;
  final UserAdd? selectedAddress;
  final int? userId;
  final Function(UserAdd) onAddressSelected;
  final VoidCallback onOrderConfirmed;

  const CheckoutBottomSheet({
    super.key,
    required this.totalAmount,
    required this.selectedAddress,
    required this.userId,
    required this.onAddressSelected,
    required this.onOrderConfirmed,
  });

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  UserAdd? _selectedAddress;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.selectedAddress;
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          
          // Address Section
          _buildAddressSection(),
          
          // Payment Method Section
          _buildPaymentSection(),
          
          // Order Summary
          _buildOrderSummary(),
          
          // Confirm Button
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            "Checkout",
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
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Delivery Address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (_selectedAddress != null && _selectedAddress!.id.isNotEmpty)
                    _buildAddressDetails()
                  else
                    _buildNoAddress(),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _showAddressSelection,
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text("Change Address"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _selectedAddress!.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _selectedAddress!.type.toUpperCase(),
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_selectedAddress!.isDefault == "1") ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "DEFAULT",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${_selectedAddress!.al1}, ${_selectedAddress!.al2}",
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          "${_selectedAddress!.city}, ${_selectedAddress!.district}",
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          "${_selectedAddress!.state} - ${_selectedAddress!.pincode}",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildNoAddress() {
    return Column(
      children: [
        const Icon(
          Icons.location_off_rounded,
          size: 40,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        const Text(
          "No address selected",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _showAddressSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text("Select Address"),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Cash on Delivery
                _buildPaymentOption(
                  method: PaymentMethod.cashOnDelivery,
                  title: "Cash on Delivery",
                  subtitle: "Pay when you receive your order",
                  icon: Icons.money_rounded,
                  isEnabled: true,
                ),
                
                // Online Payment (Disabled)
                _buildPaymentOption(
                  method: PaymentMethod.onlinePayment,
                  title: "Online Payment",
                  subtitle: "Pay securely online",
                  icon: Icons.credit_card_rounded,
                  isEnabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
  }) {
    final isSelected = _selectedPaymentMethod == method;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled 
              ? (isSelected ? Colors.orange : Colors.grey[100])
              : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled 
              ? (isSelected ? Colors.white : Colors.grey[600])
              : Colors.grey[400],
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isEnabled ? Colors.black87 : Colors.grey[400],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isEnabled ? Colors.grey[600] : Colors.grey[400],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: Colors.orange)
          : null,
      onTap: isEnabled
          ? () {
              setState(() {
                _selectedPaymentMethod = method;
              });
            }
          : null,
    );
  }

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Amount"),
                  Text(
                    "₹${widget.totalAmount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isAddressSelected = _selectedAddress != null && _selectedAddress!.id.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (isAddressSelected && !_isPlacingOrder) ? _confirmOrder : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: (isAddressSelected && !_isPlacingOrder) ? Colors.orange : Colors.grey[400],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
          ),
          child: _isPlacingOrder
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  isAddressSelected 
                      ? "Confirm Order - ₹${widget.totalAmount}"
                      : "Select Address First",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _showAddressSelection() {
    final addressBox = Hive.box<UserAdd>('userAddressBox');
    final addresses = addressBox.values.toList();

    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No addresses found. Please add an address first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Delivery Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        address.type.toLowerCase() == 'home' 
                            ? Icons.home_rounded
                            : address.type.toLowerCase() == 'work'
                                ? Icons.work_rounded
                                : Icons.location_on_rounded,
                        color: Colors.orange,
                      ),
                      title: Text(
                        address.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${address.al1}, ${address.city}"),
                          if (address.isDefault == "1")
                            const Text(
                              "Default Address",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      trailing: _selectedAddress?.id == address.id
                          ? const Icon(Icons.check_circle_rounded, color: Colors.orange)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedAddress = address;
                        });
                        widget.onAddressSelected(address);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmOrder() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Amount: ₹${widget.totalAmount}"),
            const SizedBox(height: 8),
            Text("Payment Method: ${_selectedPaymentMethod == PaymentMethod.cashOnDelivery ? 'Cash on Delivery' : 'Online Payment'}"),
            const SizedBox(height: 8),
            const Text("Delivery to:"),
            Text(
              "${_selectedAddress!.al1}, ${_selectedAddress!.city}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isPlacingOrder ? null : () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _isPlacingOrder ? null : () => _placeOrder(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: _isPlacingOrder
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text("Place Order"),
          ),
        ],
      ),
    );
  }

  void _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // Get cart items
      final cartBox = Hive.box<CartItem>('cartBox');
      final cartItems = cartBox.values.toList();

      // Prepare items in required format
      List<Map<String, dynamic>> orderItems = [];
      for (var item in cartItems) {
        orderItems.add({
          "item_id": int.parse(item.foodId),
          "qty": item.quantity,
        });
      }

      // Prepare order data
      Map<String, dynamic> orderData = {
        "user_id": widget.userId,
        "address_id": int.parse(_selectedAddress!.id),
        "items": orderItems,
        "total_amount": widget.totalAmount.toStringAsFixed(2),
        "payment_method": _selectedPaymentMethod == PaymentMethod.cashOnDelivery 
            ? "cash_on_delivery" 
            : "online_payment",
      };

      // Send order to API
      final response = await ApiService.request(
        url: ApiDetails.order,
        method: "POST",
        body: orderData,
      );

      setState(() {
        _isPlacingOrder = false;
      });

      Navigator.pop(context); // Close confirmation dialog

      if (response['success'] == true) {
        // Show success screen
        _showOrderSuccessScreen(response);
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order failed: ${response['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isPlacingOrder = false;
      });
      Navigator.pop(context); // Close confirmation dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderSuccessScreen(Map<String, dynamic> response) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderData: response,
          onContinueShopping: () {
            // Clear cart and go back to home
            final cartBox = Hive.box<CartItem>('cartBox');
            cartBox.clear();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}

enum PaymentMethod {
  cashOnDelivery,
  onlinePayment,
}

// Order Success Screen
class OrderSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback onContinueShopping;

  const OrderSuccessScreen({
    super.key,
    required this.orderData,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Success Message
            const Text(
              "Order Placed Successfully!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Order Number
            Text(
              "Order #${orderData['order_number']}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Confirmation Message
            const Text(
              "Your order has been confirmed",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Order Details Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Total Amount
                  _buildDetailRow(
                    "Total Amount",
                    "₹${orderData['order']['total_amount']}",
                    isTotal: true,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Payment Method
                  _buildDetailRow(
                    "Payment Method",
                    _getPaymentMethodText(orderData['order']['payment_method']),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Order Status
                  _buildDetailRow(
                    "Status",
                    _getStatusText(orderData['order']['order_status']),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Estimated Delivery
                  _buildDetailRow(
                    "Estimated Delivery",
                    "30-45 minutes",
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Continue Shopping Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinueShopping,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.orange : Colors.black87,
          ),
        ),
      ],
    );
  }

  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'online_payment':
        return 'Online Payment';
      default:
        return method;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return status;
    }
  }
}