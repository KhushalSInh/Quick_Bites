// FoodDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quick_bites/Data/Api/CartModel.dart';
import 'package:quick_bites/Data/Api/FavoriteModel.dart';
import 'package:quick_bites/Data/Api/Hive_Service.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/Data/Api/api.dart';

class FoodDetailScreen extends StatefulWidget {
  final Data foodItem;

  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;
  bool _isCheckingFavorite = true;
  late bool _initialFavoriteState;

  @override
  void initState() {
    super.initState();
    _initialFavoriteState = false;
    _checkIfFavorite().then((_) {
      _initialFavoriteState = isFavorite;
    });
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favoriteBox = await HiveService.getBox<FavoriteItem>('favoriteBox');
      final currentFoodId = int.parse(widget.foodItem.itemId); // Parse to int

      final isItemFavorite = favoriteBox.values.any(
        (item) => item.foodId == currentFoodId, // Compare int with int
      );

      if (mounted) {
        setState(() {
          isFavorite = isItemFavorite;
          _isCheckingFavorite = false;
        });
      }
    } catch (e) {
      print('Error checking favorite: $e');
      if (mounted) {
        setState(() {
          isFavorite = false;
          _isCheckingFavorite = false;
        });
      }
    }
  }
void _toggleFavorite() async {
  try {
    final favoriteBox = await HiveService.getBox<FavoriteItem>('favoriteBox');
    final existingItemKey = _findExistingFavoriteItem(favoriteBox);

    if (existingItemKey != null) {
      // Remove from favorites
      await favoriteBox.delete(existingItemKey);
      if (mounted) {
        setState(() {
          isFavorite = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed ${widget.foodItem.name} from favorites'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      // Add to favorites - keep foodId as String
      final favoriteItem = FavoriteItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodId: int.parse(widget.foodItem.itemId), // Keep as String
        name: widget.foodItem.name,
        description: widget.foodItem.description,
        price: widget.foodItem.price,
        image: widget.foodItem.img,
        addedAt: DateTime.now(),
      );
      await favoriteBox.add(favoriteItem);
      if (mounted) {
        setState(() {
          isFavorite = true;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${widget.foodItem.name} to favorites'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } catch (e) {
    print('Error toggling favorite: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: Could not update favorites - $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

String? _findExistingFavoriteItem(Box<FavoriteItem> favoriteBox) {
  for (var i = 0; i < favoriteBox.length; i++) {
    final item = favoriteBox.getAt(i);
    if (item?.foodId == widget.foodItem.itemId) { // String comparison
      return favoriteBox.keyAt(i) as String;
    }
  }
  return null;
}
  @override
  Widget build(BuildContext context) {
    var ImageBase = ApiDetails.ip;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context, isFavorite != _initialFavoriteState);
                },
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: _isCheckingFavorite
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: _toggleFavorite,
                      ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      _getImageUrl(widget.foodItem.img, ImageBase),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.orange,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fastfood_rounded,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.foodItem.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "₹${widget.foodItem.price}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.orange[700],
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Popular",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.foodItem.description.isNotEmpty == true
                        ? widget.foodItem.description
                        : "Indulge in this delicious ${widget.foodItem.name}. Made with fresh ingredients and prepared with care, this dish is sure to satisfy your cravings. Perfect for any time of the day!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildIngredientChip("Fresh Vegetables"),
                      _buildIngredientChip("Premium Spices"),
                      _buildIngredientChip("Natural Oils"),
                      _buildIngredientChip("Herbs"),
                      _buildIngredientChip("Secret Sauce"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nutrition Facts",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNutritionItem("Calories", "250"),
                            _buildNutritionItem("Protein", "15g"),
                            _buildNutritionItem("Carbs", "30g"),
                            _buildNutritionItem("Fat", "8g"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: quantity > 1 ? Colors.orange : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: quantity > 1 ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _addToCart(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_rounded, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "₹${(int.parse(widget.foodItem.price) * quantity)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Text(
        ingredient,
        style: TextStyle(
          fontSize: 14,
          color: Colors.green[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Also update _addToCart method to ensure consistency:
  void _addToCart(BuildContext context) async {
    try {
      final cartBox = await HiveService.getBox<CartItem>('cartBox');
      final existingItemKey = _findExistingCartItem(cartBox);

      if (existingItemKey != null) {
        final existingItem = cartBox.get(existingItemKey);
        if (existingItem != null) {
          cartBox.put(
              existingItemKey,
              existingItem.copyWith(
                  quantity: existingItem.quantity + quantity));
        }
      } else {
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          foodId: widget.foodItem.itemId, // Keep as string for CartItem
          name: widget.foodItem.name,
          description: widget.foodItem.description,
          price: widget.foodItem.price,
          image: widget.foodItem.img,
          quantity: quantity,
          addedAt: DateTime.now(),
        );
        cartBox.add(cartItem);
      }
      // ... rest of _addToCart method
    } catch (e) {
      // ... error handling
    }
  }

  String? _findExistingCartItem(Box<CartItem> cartBox) {
    for (var i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (item?.foodId == widget.foodItem.itemId) {
        // Keep as string comparison
        return cartBox.keyAt(i) as String;
      }
    }
    return null;
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
      return 'https://via.placeholder.com/400?text=No+Image';
    }
  }
}
