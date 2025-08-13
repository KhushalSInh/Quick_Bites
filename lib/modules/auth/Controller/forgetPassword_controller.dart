// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';

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
