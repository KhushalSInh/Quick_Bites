// ignore_for_file: non_constant_identifier_names, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/Hive.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/modules/home/FoodDetails.dart';
import 'package:quick_bites/Data/Api/CategoryModel.dart'; // Import your CategoryModel

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
    DataManage.fetchFoodCategories(); // Fetch categories
  }

  // Dynamic categories - will be loaded from Hive
  List<Map<String, dynamic>> categories = [
    {"id": "0", "name": "All", "color": Colors.orange}
  ];

  final List<Color> categoryColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
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
          builder: (context, Box<Data> itemsBox, _) {
            final allItems = itemsBox.values.toList();

            return ValueListenableBuilder(
              valueListenable: Hive.box<FoodCategory>('categoriesBox').listenable(), // Fixed: Specify type
              builder: (context, Box<FoodCategory> categoriesBox, _) { // Fixed: Specify type
                // Load categories from Hive
                _loadCategories(categoriesBox);

                // Filter items by selected category
                final filteredItems = _getFilteredItems(allItems);

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
                          "Quick Bites",
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
                            final category = categories[index];
                            final isSelected = index == selectedCategoryIndex;
                            final color = _getCategoryColor(index);
                            
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
                                            ? color
                                            : color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: isSelected
                                            ? Border.all(
                                                color: color,
                                                width: 2)
                                            : null,
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category['name']),
                                        color: isSelected
                                            ? Colors.white
                                            : color,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Category Name
                                    Text(
                                      category['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? color
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
                              _getCategoryTitle(),
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

                    // Grid View
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
                                        // Image Section
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

                                        // Text Section
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Food Name
                                                Flexible(
                                                  child: Text(
                                                    item.name,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),

                                                // Price
                                                Text(
                                                  "₹${item.price}",
                                                  style: TextStyle(
                                                    fontSize: 20,
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
                            childAspectRatio: 0.65,
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
            );
          },
        ),
      ),
    );
  }

  // Load categories from Hive
  void _loadCategories(Box<FoodCategory> categoriesBox) {
    final hiveCategories = categoriesBox.values.toList();
    
    if (hiveCategories.isNotEmpty) {
      // Update categories list with data from Hive
      categories = [
        {"id": "0", "name": "All", "color": Colors.orange}
      ];
      
      for (int i = 0; i < hiveCategories.length; i++) {
        final category = hiveCategories[i];
        categories.add({
          "id": category.id, // Use the id from FoodCategory
          "name": category.name,
          "color": categoryColors[(i % (categoryColors.length - 1)) + 1],
        });
      }
    } else {
      // Fallback to default categories if Hive is empty
      categories = [
        {"id": "0", "name": "All", "color": Colors.orange},
        {"id": "1", "name": "Pizza", "color": Colors.blue},
        {"id": "2", "name": "Burgers", "color": Colors.green},
        {"id": "3", "name": "Drinks", "color": Colors.purple},
        {"id": "4", "name": "Lunch", "color": Colors.red},
      ];
    }
  }

  // Filter items based on selected category
  List<Data> _getFilteredItems(List<Data> allItems) {
    if (selectedCategoryIndex == 0) {
      return allItems; // "All" category
    }
    
    final selectedCategory = categories[selectedCategoryIndex];
    final categoryId = selectedCategory['id'];
    
    return allItems.where((item) => item.categoryId == categoryId).toList();
  }

  // Get category title based on selection
  String _getCategoryTitle() {
    if (selectedCategoryIndex == 0) {
      return "All Items";
    }
    return "${categories[selectedCategoryIndex]['name']} Items";
  }

  // Get color for category
  Color _getCategoryColor(int index) {
    if (index < categories.length) {
      return categories[index]['color'] ?? categoryColors[index % categoryColors.length];
    }
    return categoryColors[index % categoryColors.length];
  }

  // Helper method to get category icons
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "all":
        return Icons.all_inclusive_rounded;
      case "pizza":
        return Icons.local_pizza_rounded;
      case "burgers":
        return Icons.fastfood_rounded;
      case "drinks":
        return Icons.local_drink_rounded;
      case "lunchs":
      case "lunch":
        return Icons.lunch_dining_rounded;
      case "breakfast":
        return Icons.breakfast_dining_rounded;
      case "dinner":
        return Icons.dinner_dining_rounded;
      case "snacks":
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