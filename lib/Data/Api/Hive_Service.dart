// hive_service.dart
// ignore_for_file: avoid_print

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_bites/Data/Api/CartModel.dart';
import 'package:quick_bites/Data/Api/AddModel.dart';
import 'package:quick_bites/Data/Api/CategoryModel.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'FavoriteModel.dart';

class HiveService {
  static bool _isInitialized = false;

  static Future<void> initHive() async {
    if (_isInitialized) return;
    
    try {
      await Hive.initFlutter();
      
      // Register adapters with UNIQUE typeIds
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DataAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(CartItemAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(FavoriteItemAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(UserAddAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) { // NEW - Category adapter
        Hive.registerAdapter(FoodCategoryAdapter());
      }
      
      // Open boxes
      await Hive.openBox<Data>("itemsBox");
      await Hive.openBox<UserAdd>('userAddressBox');
      await Hive.openBox<CartItem>('cartBox');
      await Hive.openBox<FavoriteItem>('favoriteBox');
      await Hive.openBox<FoodCategory>('categoriesBox'); // NEW - Categories box
      
      _isInitialized = true;
      print('Hive initialized successfully');
    } catch (e) {
      print('Hive initialization error: $e');
      rethrow;
    }
  }

  // ... rest of the code remains same ...

  

  static Future<Box<T>> getBox<T>(String boxName) async {
    if (!_isInitialized) {
      await initHive();
    }
    
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  static Future<void> closeBoxes() async {
    await Hive.close();
    _isInitialized = false;
  }

  static Future<void> resetHive() async {
    await Hive.close();
    _isInitialized = false;
    await initHive();
  }
}