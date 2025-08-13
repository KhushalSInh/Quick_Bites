import '../../../Data/Api/api.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;




class AuthService {
   static Future<String> login(String email, String password) async {
    var url = Uri.parse(ApiDetails.loginApi);


    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          // Optional: Save token or user info
          return "success"; // Indicate successful login
        } else {
          return data['message'] ?? 'Login failed';
        }
      } else {
        return data['message'] ?? 'An unexpected error occurred';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }


  static Future<bool> signUp(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}





