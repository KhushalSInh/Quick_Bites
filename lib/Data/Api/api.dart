// ignore_for_file: unused_catch_clause, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiDetails {
  static String ip = "10.91.9.123";

  static String get loginApi => "http://$ip/quickbites/login.php";
  static String get singupApi => "http://$ip/quickbites/singup.php";
  static String get forgetPassword => "http://$ip/quickbites/sendOtp.php";
  static String get changePasswordApi =>"http://$ip/quickbites/Change_password.php";
  static String get ResetPasswordApi =>"http://$ip/quickbites/ResetPassword.php";

  static String get fooditems => "http://$ip/quickbites/Items.php";

  static String get getAddress => "http://$ip/quickbites/GetAddress.php";
  static String get addAddress => "http://$ip/quickbites/InsertAddress.php";
  static String get updateAddress => "http://$ip/quickbites/UpdateAddress.php";
  static String get deleteAddress => "http://$ip/quickbites/DeleteAddress.php";

  static String get order => "http://$ip/quickbites/order.php";
  static String get OrderHistory => "http://$ip/quickbites/OrderHistory.php";
  static String get cancelorder => "http://$ip/quickbites/CancelOrder.php";

  static String get foodCategories => "http://$ip/quickbites/Categories.php";
  static String get itemsByCategory =>"http://$ip/quickbites/ItemsByCategory.php";

  static String get getprofile => "http://$ip/quickbites/GetUser.php";
  static String get updateuser => "http://$ip/quickbites/UpdateUser.php";
}

class ApiService {
  static Future<Map<String, dynamic>> request({
    required String url,
    String method = "GET", // Default is GET
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final defaultHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final requestHeaders = {...defaultHeaders, ...?headers};

      late http.Response response;

      // Set a consistent timeout for all requests
      const requestTimeout = Duration(seconds: 10);

      if (method.toUpperCase() == "POST") {
        response = await http
            .post(
              Uri.parse(url),
              headers: requestHeaders,
              body: jsonEncode(body ?? {}),
            )
            .timeout(requestTimeout);
      } else if (method.toUpperCase() == "GET") {
        response = await http
            .get(
              Uri.parse(url),
              headers: requestHeaders,
            )
            .timeout(requestTimeout);
      } else {
        return {
          "error": true,
          "message": "Unsupported HTTP method: $method",
        };
      }

      // Check for successful status codes (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        // Handle server-side errors
        return {
          "error": true,
          "statusCode": response.statusCode,
          "message": response.reasonPhrase ?? "Unknown server error",
        };
      }
    } on SocketException {
      // Handles network-related errors like no internet connection or server offline.
      return {
        "error": true,
        "message":
            "Connection Error: Please check your internet connection or server status.",
      };
    } on TimeoutException {
      // Handles cases where the request takes too long to respond.
      return {
        "error": true,
        "message": "Request timed out. Please try again.",
      };
    } on FormatException {
      // Handles cases where the server response is not valid JSON.
      return {
        "error": true,
        "message": "Invalid server response format.",
      };
    } catch (e) {
      // A general catch-all for any other unexpected errors.
      return {
        "error": true,
        "message": "An unexpected error occurred: ${e.toString()}",
      };
    }
  }
}
// POST


// void loginUser() async {
//   var response = await ApiService.request(
//     url: "http://localhost/quickbites/login.php",
//     method: "POST",
//     body: {
//       "email": "test@example.com",
//       "password": "123456",
//     },
//   );

//   print(response);
// }

// GET 

// void fetchUsers() async {
//   var response = await ApiService.request(
//     url: "http://localhost/quickbites/getUsers.php",
//     method: "GET",f
//   );

//   print(response);
// }
 // adjust the path to your Data model

