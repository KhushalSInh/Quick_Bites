// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';

class LoginController extends GetxController {
  final emialController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // For password visibility toggle
  var isPasswordVisible = false.obs;

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
    // Do login logic
    try {
      var url = Uri.parse(ApiDetails.loginApi);

      http.Response result = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emialController.text,
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(result.body);
      if (result.statusCode == 200) {
        if (data['message'] == "successful") {
          showCustomMessageDialog(
            context,
            message: "Login sucessfully.",
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
            // "Login failed. Incorrect username or password."
            context,
            message:data['message'],
            type: MessageType.error,
          );
        }
      } else {
         showCustomMessageDialog(
            context,
            message:data['message'],
            type: MessageType.error,
          );
        print(data['message'] ?? 'An unexpected error occurred');
      }
    } catch (e) {
       showCustomMessageDialog(
            context,
            message:"Connection Error $e",
            type: MessageType.error,
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
