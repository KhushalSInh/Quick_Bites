// ignore_for_file: unused_catch_clause

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiDetails {
  static String ip = "10.73.58.123";

  static String get loginApi => "http://$ip/quickbites/login.php";
  static String get singupApi => "http://$ip/quickbites/singup.php";
  static String get forgetPassword => "http://$ip/quickbites/sendOtp.php";
  static String get changePasswordApi => "http://$ip/quickbites/Change_password.php";
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
        "message": "Connection Error: Please check your internet connection or server status.",
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

