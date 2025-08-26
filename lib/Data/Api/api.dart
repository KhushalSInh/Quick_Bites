import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiDetails {

   static String ip = "10.16.73.123"; 

  static String get loginApi => "http://$ip/quickbites/login.php";
  static String get singupApi => "http://$ip/quickbites/singup.php";
 
}

class ApiService {
  /// Generic API call method
  static Future<Map<String, dynamic>> request({
    required String url,
    String method = "GET", // Default is GET
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      // Default headers
      final defaultHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Merge default and custom headers
      final requestHeaders = {...defaultHeaders, ...?headers};

      late http.Response response;

      if (method.toUpperCase() == "POST") {
        response = await http.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: jsonEncode(body ?? {}),
        );
      } else if (method.toUpperCase() == "GET") {
        response = await http.get(Uri.parse(url), headers: requestHeaders);
      } else {
        throw Exception("Unsupported HTTP method: $method");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "statusCode": response.statusCode,
          "message": response.reasonPhrase ?? "Unknown error",
        };
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
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
//     method: "GET",
//   );

//   print(response);
// }

