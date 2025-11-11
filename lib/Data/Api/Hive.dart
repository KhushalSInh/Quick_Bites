// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:quick_bites/Data/Api/AddModel.dart';
import 'package:quick_bites/Data/Api/CategoryModel.dart';
import 'package:quick_bites/Data/Api/Model.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiveKey {
  static String db = "QuickBites";

  static Future<void> storeItemsInHive(String jsonString) async {
    final jsonData = jsonDecode(jsonString);
    final itemsList =
        (jsonData['data'] as List).map((item) => Data.fromJson(item)).toList();

    var box = Hive.box<Data>('itemsBox');

    await box.clear(); // optional: clear previous data
    await box.addAll(itemsList); // store list of Data
  }

  List<Data> getItemsFromHive() {
    var box = Hive.box<Data>('itemsBox');
    return box.values.toList(); // returns List<Data>
  }

 static Future<void> storeAddressesInHive(String jsonString) async {
  final jsonData = jsonDecode(jsonString);
  final addressList = (jsonData['data'] as List)
      .map((item) => UserAdd.fromJson(item))
      .toList();

  final box = Hive.box<UserAdd>('userAddressBox');

  await box.clear(); // optional
  await box.addAll(addressList); // add list of addresses
}

 static List<UserAdd> getAddressesFromHive() {
  final box = Hive.box<UserAdd>('userAddressBox');
  return box.values.toList();
}

  static Future<void> storeCategoriesInHive(String jsonString) async {
    final jsonData = jsonDecode(jsonString);
    final categoriesList = (jsonData['data'] as List)
        .map((item) => FoodCategory.fromJson(item))
        .toList();

    var box = Hive.box<FoodCategory>('categoriesBox');
    await box.clear();
    await box.addAll(categoriesList);
  }

  static List<FoodCategory> getCategoriesFromHive() {
    var box = Hive.box<FoodCategory>('categoriesBox');
    return box.values.toList();
  }
}

class DataManage {
  static Future<void> fetchFoodItems() async {
    try {
      var response = await ApiService.request(
        url: ApiDetails.fooditems,
        method: "GET",
      );

      // Store in Hive using your existing method
      await HiveKey.storeItemsInHive(jsonEncode(response));

      // print('✅ Items fetched and stored in Hive successfully');
    } catch (e) {
      print('❌ Error fetching or storing food items: $e');
    }
  }

  static Future<void> fetchUserAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? a = prefs.getInt("user_id") ;
    try {
      // Replace with your actual POST request
      var response = await ApiService.request(
        url: ApiDetails.getAddress, // <-- endpoint that accepts POST
        method: "POST",
        body: {
          "userid": a, // Pass user ID here
        },
      );
      // Store in Hive using your existing method
      await HiveKey.storeAddressesInHive(jsonEncode(response));

      // print('✅ User profile fetched and stored in Hive');
    } catch (e) {
      print('❌ Error fetching or storing user profile: $e');
    }
  }
  // Addres API
  static Future<bool> addUserAddress({
    required String name,
    required String pincode,
    required String state,
    required String district,
    required String city,
    required String al1,
    required String al2,
    required String type,
    required String isDefault,
  }) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? a = prefs.getInt("user_id") ;
    try {
      var response = await ApiService.request(
        url: ApiDetails.addAddress,
        method: "POST",
        body: {
          "user_id": a, // Replace with actual user ID
          "name": name,
          "pincode": pincode,
          "state": state,
          "district": district,
          "city": city,
          "al1": al1,
          "al2": al2,
          "type": type,
          "is_default": isDefault,
        },
      );

      if (response != null && response['status'] == 'success') {
        return true;
      } else {
        print("Add address failed: ${response?['message']}");
        return false;
      }
    } catch (e) {
      print("Error adding address: $e");
      return false;
    }
  }

  // Update user address
  static Future<bool> updateUserAddress({

    required String addressId,
    required String name,
    required String pincode,
    required String state,
    required String district,
    required String city,
    required String al1,
    required String al2,
    required String type,
    required String isDefault,
  }) async {
    
    try {
      var response = await ApiService.request(
        url: ApiDetails.updateAddress,
        method: "POST",
        body: {
          "id": addressId,
          "name": name,
          "pincode": pincode,
          "state": state,
          "district": district,
          "city": city,
          "al1": al1,
          "al2": al2,
          "type": type,
          "is_default": isDefault,
        },
      );

     

      if (response != null && response['status'] == 'success') {
        return true;
      } else {
        print("Update address failed: ${response?['message']}");
        return false;
      }
    } catch (e) {
      print("Error updating address: $e");
      return false;
    }
  }


  static Future<bool> deleteUserAddress(String addressId) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? a = prefs.getInt("user_id") ;
    try {
      var response = await ApiService.request(
        url: ApiDetails.deleteAddress,
        method: "POST",
        body: {
          "id": addressId,
        },
      );

    
      if (response != null && response['status'] == 'success') {
        return true;
      } else {
        print("Delete address failed: ${response?['message']}");
        return false;
      }
    } catch (e) {
      print("Error deleting address: $e");
      return false;
    }
  }

  // Set default address
  static Future<bool> setDefaultAddress(String addressId) async {
    try {
      var response = await ApiService.request(
        url: "http://localhost/quickbites/set_default_address.php",
        method: "POST",
        body: {
          "user_id": "current_user_id", // Replace with actual user ID
          "address_id": addressId,
        },
      );

     
      if (response != null && response['status'] == 'success') {
        return true;
      } else {
        print("Set default address failed: ${response?['message']}");
        return false;
      }
    } catch (e) {
      print("Error setting default address: $e");
      return false;
    }
  }

static Future<void> fetchFoodCategories() async {
    try {
      var response = await ApiService.request(
        url: ApiDetails.foodCategories,
        method: "GET",
      );

      await HiveKey.storeCategoriesInHive(jsonEncode(response));
      print('✅ Categories fetched and stored in Hive successfully');
    } catch (e) {
      print('❌ Error fetching or storing categories: $e');
    }
  }

  // OPTIONAL: Method to fetch items by category
  static Future<void> fetchItemsByCategory(String categoryId) async {
    try {
      var response = await ApiService.request(
        url: ApiDetails.itemsByCategory,
        method: "POST",
        body: {
          "category_id": categoryId,
        },
      );

      await HiveKey.storeItemsInHive(jsonEncode(response));
      print('✅ Items for category $categoryId fetched successfully');
    } catch (e) {
      print('❌ Error fetching items by category: $e');
    }
  }

}
