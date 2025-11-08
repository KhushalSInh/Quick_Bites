// ignore_for_file: non_constant_identifier_names, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/Hive.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/modules/home/FoodDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    
    DataManage.fetchUserAddress();
    DataManage.fetchFoodItems();
  }
  final List<String> categories = const [
    "All",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snacks",
  ];

  final List<Color> categoryColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
  ];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {

    
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Data>('itemsBox').listenable(),
          builder: (context, Box<Data> box, _) {
            final allItems = box.values.toList();

            // Filter by sloat/category
            final filteredItems = selectedCategoryIndex == 0
                ? allItems
                : allItems
                    .where((item) =>
                        item.sloat == categories[selectedCategoryIndex])
                    .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: Text(
                      "Quick Bites ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade50,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Welcome Section
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Afternoon! 👋",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "What would you like to eat today?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categories Section
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedCategoryIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                // Category Icon
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? categoryColors[index]
                                        : categoryColors[index]
                                            .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: isSelected
                                        ? Border.all(
                                            color: categoryColors[index],
                                            width: 2)
                                        : null,
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(categories[index]),
                                    color: isSelected
                                        ? Colors.white
                                        : categoryColors[index],
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Category Name
                                Text(
                                  categories[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? categoryColors[index]
                                        : Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Popular Items Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular Items",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "${filteredItems.length} items",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid View - BULLETPROOF SOLUTION
                if (filteredItems.isNotEmpty)
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];
                          var ImageBase = ApiDetails.ip;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FoodDetailScreen(foodItem: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section - Fixed aspect ratio
                                    AspectRatio(
                                      aspectRatio: 1.2,
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                        child: Container(
                                          color: Colors.grey[100],
                                          child: Image.network(
                                            _getImageUrl(item.img, ImageBase),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                  color: Colors.orange,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.fastfood_rounded,
                                                      size: 40,
                                                      color: Colors.grey[400],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'No Image',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Text Section - FLEXIBLE & SAFE
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Food Name - BIG TEXT with proper constraints
                                            Flexible(
                                              child: Text(
                                                item.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18, // BIG TEXT
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ),

                                            // Price - BIG TEXT
                                            Text(
                                              "₹${item.price}",
                                              style: TextStyle(
                                                fontSize: 20, // BIG TEXT
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: filteredItems.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65, // PERFECT RATIO FOR BIG TEXT
                      ),
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fastfood_rounded,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try selecting a different category',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper method to get category icons
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "All":
        return Icons.all_inclusive_rounded;
      case "Breakfast":
        return Icons.breakfast_dining_rounded;
      case "Lunch":
        return Icons.lunch_dining_rounded;
      case "Dinner":
        return Icons.dinner_dining_rounded;
      case "Snacks":
        return Icons.local_cafe_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  // Helper method to format image URL
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
