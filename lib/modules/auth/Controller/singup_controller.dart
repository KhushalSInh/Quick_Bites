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
  final mobileController = TextEditingController();

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

 String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return "Mobile number is required";
  } 
  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return "Enter a valid 10-digit mobile number";
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


  void signup(BuildContext context) async {
    // Show a loading indicator to the user while the request is in progress.

    final Map<String, dynamic> responseData = await ApiService.request(
      url: ApiDetails.singupApi,
      method: "POST",
      body: {
        'name': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'mobile': '1234567890', // Placeholder mobile number
      },
    );

    if (responseData.containsKey('error') && responseData['error'] == true) {
      showCustomMessageDialog(
        context,
        message:
            responseData['message'] ?? 'An unknown network error occurred.',
        type: MessageType.error,
      );

      return;
    }

    // Handle the successful API response based on the 'message' field from the server.
    final String message =
        responseData['message'] ?? 'An unexpected server response.';
    if (message == "Signup successful") {
      usernameController.text = "";
      emailController.text = "";
      mobileController.text = ""; // ⚠ Add this
      passwordController.text = "";
      showCustomMessageDialog(
        context,
        message: message,
        type: MessageType.success,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("IsLogin", true);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.LoginAuth,
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
    usernameController.text = "";
    emailController.text = "";
    mobileController.text = ""; // ⚠ Add this
    passwordController.text = "";

    usernameController.dispose();
    emailController.dispose();
    mobileController.dispose(); // ⚠ Add this
    passwordController.dispose();
    super.onClose();
  }
}
