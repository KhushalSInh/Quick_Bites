import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/modules/home/FoodDetails.dart' show FoodDetailScreen;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Data> _searchResults = [];
  List<Data> _recentSearches = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
    
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadRecentSearches() {
    _recentSearches = [];
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _performSearch(query);
  }

  void _performSearch(String query) {
    final box = Hive.box<Data>('itemsBox');
    final allItems = box.values.toList();

    final results = allItems.where((item) {
      final name = item.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      
      return name.contains(searchQuery);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  void _addToRecentSearches(Data item) {
    if (!_recentSearches.any((element) => element.itemId == item.itemId)) {
      setState(() {
        _recentSearches.insert(0, item);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _searchResults.clear();
    });
    _searchFocusNode.unfocus();
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
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
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search_rounded, color: Colors.grey[500], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Search for food...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear_rounded, color: Colors.grey[500], size: 20),
                      onPressed: _clearSearch,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const SizedBox();
    }

    if (_searchResults.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _buildSearchResultItem(item);
      },
    );
  }

  Widget _buildSearchResultItem(Data item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () {
          _addToRecentSearches(item);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(foodItem: item),
            ),
          );
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _getImageUrl(item.img),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.fastfood_rounded,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "₹${item.price}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            "View",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Searches Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Searches",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (_recentSearches.isNotEmpty)
                        TextButton(
                          onPressed: _clearRecentSearches,
                          child: Text(
                            "Clear All",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Recent Searches List
                if (_recentSearches.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        final item = _recentSearches[index];
                        return _buildRecentSearchItem(item);
                      },
                    ),
                  )
                else
                  // Empty State - Centered with proper spacing
                  Container(
                    height: constraints.maxHeight * 0.6,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for your favorite food',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Find delicious meals and add them to your cart',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Popular Categories - Only show if there's space
                if (_recentSearches.isEmpty || _recentSearches.length <= 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                        child: Text(
                          "Popular Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildCategoryChip("Pizza", Icons.local_pizza_rounded),
                            _buildCategoryChip("Burger", Icons.fastfood_rounded),
                            _buildCategoryChip("Pasta", Icons.restaurant_rounded),
                            _buildCategoryChip("Salad", Icons.eco_rounded),
                            _buildCategoryChip("Dessert", Icons.cake_rounded),
                            _buildCategoryChip("Drinks", Icons.local_drink_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentSearchItem(Data item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(foodItem: item),
            ),
          );
        },
        leading: Icon(Icons.history_rounded, color: Colors.grey[500]),
        title: Text(
          item.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close_rounded, size: 18, color: Colors.grey[500]),
          onPressed: () {
            setState(() {
              _recentSearches.remove(item);
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minLeadingWidth: 0,
      ),
    );
  }

  Widget _buildCategoryChip(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        _searchController.text = title;
        _searchFocusNode.requestFocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.orange),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrl(String imagePath) {
    try {
      String cleanedPath = imagePath.replaceAll(r'\', '/');
      var ImageBase = ApiDetails.ip;
      
      if (cleanedPath.startsWith('http')) return cleanedPath;
      
      while (cleanedPath.startsWith('/')) {
        cleanedPath = cleanedPath.substring(1);
      }
      
      if (!cleanedPath.contains('quickbites')) {
        cleanedPath = 'quickbites/$cleanedPath';
      }
      
      return 'http://$ImageBase/$cleanedPath';
      
    } catch (e) {
      return 'https://via.placeholder.com/150?text=No+Image';
    }
  }
}