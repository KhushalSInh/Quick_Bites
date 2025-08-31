// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingupController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // For password visibility toggle
  var isPasswordVisible = false.obs;

  // For form validation (optional)
  final formKey = GlobalKey<FormState>();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validateEmial(String? value) {
    if (value == null || value.isEmpty) {
      return 'email is required';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signup2(BuildContext context) async {
    try {
      var url = Uri.parse(ApiDetails.singupApi);

      http.Response result = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );


      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        if (data['message'] == "Email already registered") {
          showCustomMessageDialog(
            context,
            message: data['message'],
            type: MessageType.info,
          );
        } else if (data['message'] == "Signup successful") {
          showCustomMessageDialog(
            context,
            message: data['message'],
            type: MessageType.success,
          );
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          });
        } else {
          showCustomMessageDialog(
            context,
            message: data['message'],
            type: MessageType.error,
          );
        }
      } else {
        showCustomMessageDialog(
          context,
          message: "Server error: ${result.statusCode}",
          type: MessageType.error,
        );
      }
    } catch (e) {
      showCustomMessageDialog(
        context,
        message: "Connection Error: $e",
        type: MessageType.error,
      );
    }
  }


  void signup(BuildContext context) async {
  // Show a loading indicator to the user while the request is in progress.


  final Map<String, dynamic> responseData = await ApiService.request(
    url: ApiDetails.singupApi,
    method: "POST",
    body: {
      'name': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    },
  );

  

  if (responseData.containsKey('error') && responseData['error'] == true) {
    
    showCustomMessageDialog(
      context,
      message: responseData['message'] ?? 'An unknown network error occurred.',
      type: MessageType.error,
    );
    
    return;
  }

  // Handle the successful API response based on the 'message' field from the server.
  final String message = responseData['message'] ?? 'An unexpected server response.';
  if (message == "Signup successful") {
    showCustomMessageDialog(
      context,
      message: message,
      type: MessageType.success,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsLogin", true);
    
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    });
  } else if (message == "Email already registered") {
    showCustomMessageDialog(
      context,
      message: message,
      type: MessageType.info,
    );
  } else {
    // Catch any other messages from the server.
    showCustomMessageDialog(
      context,
      message: message,
      type: MessageType.error,
    );
  }
}
  
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
