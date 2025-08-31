// ignore_for_file: avoid_print, use_build_context_synchronously



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quick_bites/core/routs/routs.dart';


class ForgetpasswordController extends GetxController {
  final emialController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // For password visibility toggle
  var isPasswordVisible = false.obs;

  // For form validation (optional)
  final formKey = GlobalKey<FormState>();

  String? validateEmail (String? value) {
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

  void sendEmial(BuildContext context)  {
   Navigator.pushNamed(
                                      context,
                                      AppRoutes.fillOtp,
                                    );
  }

  @override
  void onClose() {
    emialController.dispose();
    
    super.onClose();
  }
}
