// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names, unused_local_variable



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emialController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // For password visibility toggle
  var isPasswordVisible = false.obs;
  bool? isLogin = false;

  // For form validation (optional)
  final formKey = GlobalKey<FormState>();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
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



void login(BuildContext context) async {

  final Map<String, dynamic> responseData = await ApiService.request(
    url: ApiDetails.loginApi,
    method: "POST",
    body: {
      'email': emialController.text,
      'password': passwordController.text,
    },
  );


  if (responseData.containsKey('error') && responseData['error'] == true) {
    // This block handles all types of errors (network, server status codes > 299)
    showCustomMessageDialog(
      context,
      message: responseData['message'] ?? 'An unknown network error occurred.',
      type: MessageType.error,
    );
    print(responseData['message']);
    return;
  }

  // Handle successful API response with the "message" field from the server
  if (responseData['message'] == "successful") {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsLogin", true);
    prefs.setInt("user_id", responseData['id']);
    
    showCustomMessageDialog(
      context,
      message: "Login successful.",
      type: MessageType.success,
    );

    Future.delayed(Duration(seconds: 2), () {
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   AppRoutes.home,
      //   (route) => false,
      // );
      Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
    

    });
  } else {
    // This handles the server-side logic of "Invalid credentials"
    showCustomMessageDialog(
      context,
      message: responseData['message'] ?? 'Login failed.',
      type: MessageType.error,
    );
  }
}
  


  void skipLogin(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isLogin = prefs.getBool("IsLogin");

    if (isLogin == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    }
  }

  @override
  void onClose() {
    emialController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
