// FavoriteScreen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/FavoriteModel.dart';
import 'package:quick_bites/Data/Api/Hive_Service.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/modules/home/FoodDetails.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<Box<FavoriteItem>> _favoriteBoxFuture;

  @override
  void initState() {
    super.initState();
    _favoriteBoxFuture = HiveService.getBox<FavoriteItem>('favoriteBox');
  }

  void _refreshFavorites() {
    setState(() {
      _favoriteBoxFuture = HiveService.getBox<FavoriteItem>('favoriteBox');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Favorites',
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
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: FutureBuilder<Box<FavoriteItem>>(
        future: _favoriteBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError) {
            return _buildError();
          }

          if (!snapshot.hasData) {
            return _buildEmptyFavorites();
          }

          final favoriteBox = snapshot.data!;

          return ValueListenableBuilder(
            valueListenable: favoriteBox.listenable(),
            builder: (context, Box<FavoriteItem> box, _) {
              final favoriteItems = box.values.toList();

              if (favoriteItems.isEmpty) {
                return _buildEmptyFavorites();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return _buildFavoriteItem(item, box);
                },
              );
            },
          );
        },
      ),
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
            'Loading favorites...',
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
          const Text(
            'Error loading favorites',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshFavorites,
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

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            "No Favorites Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the heart icon to add items to favorites",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Browse Items'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(FavoriteItem item, Box<FavoriteItem> box) {
    var ImageBase = ApiDetails.ip;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _openFoodDetails(item, box),
          splashColor: Colors.orange.withOpacity(0.2),
          highlightColor: Colors.orange.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                        "₹${item.price}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: () => _removeFromFavorites(box, item),
                  tooltip: 'Remove from favorites',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openFoodDetails(
      FavoriteItem favoriteItem, Box<FavoriteItem> box) async {
    // Convert FavoriteItem to Data model for FoodDetailScreen
    final foodItem = Data(
      itemId: favoriteItem.foodId.toString(),
      sloat: "0",
      name: favoriteItem.name,
      description: favoriteItem.description,
      price: favoriteItem.price,
      img: favoriteItem.image, 
      categoryId: favoriteItem.id,  //jduegdygedgedgedguiedgyehd
    );

    // Wait for result from FoodDetailScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(foodItem: foodItem),
      ),
    );

    // Refresh favorites if favorite status changed
    if (result == true) {
      _refreshFavorites();
    }
  }

  void _removeFromFavorites(Box<FavoriteItem> box, FavoriteItem item) async {
    try {
      final itemKey = _findFavoriteItemKey(box, item);
      if (itemKey != null) {
        await box.delete(itemKey);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${item.name} from favorites'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error removing favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Could not remove ${item.name} from favorites'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  dynamic _findFavoriteItemKey(Box<FavoriteItem> box, FavoriteItem item) {
    for (var i = 0; i < box.length; i++) {
      final currentItem = box.getAt(i);
      if (currentItem?.foodId == item.foodId) {
        // Direct string comparison
        return box.keyAt(i);
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
      return 'https://via.placeholder.com/150?text=No+Image';
    }
  }
}
