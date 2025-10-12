// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'dart:math';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetpasswordController extends GetxController {
  final emialController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // For password visibility toggle
  var isPasswordVisible = false.obs;

  // For form validation (optional)
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
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

  void sendEmial(BuildContext context, {required String email}) async {
    final int otp = generateAndStoreOTP();
    final String otpString = otp.toString();
    final Map<String, dynamic> responseData = await ApiService.request(
      url: ApiDetails.forgetPassword,
      method: "POST",
      body: {'email': email, 'otp':otpString},
    );

    if (responseData.containsKey('error') && responseData['error'] == true) {
      showCustomMessageDialog(
        context,
        message:
            responseData['message'] ?? 'An unknown network error occurred.',
        type: MessageType.error,
      );
    }

    if (responseData['message'] == "OTP Send Succesfully") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email.toString());
      await prefs.setString('user_otp', otp.toString());

      showCustomMessageDialog(
        context,
        message: responseData['message'] ?? 'OTP sent successfully.',
        type: MessageType.success,
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.OtpFillAuth,
          (route) => false,
        );
      });
    } else {
      showCustomMessageDialog(
        context,
        message: responseData['message'] ?? 'Login failed.',
        type: MessageType.error,
      );
    }
  }

  int generateAndStoreOTP() {
    final random = Random();
    final int otp = 1000 + random.nextInt(9000); // Generates a 4-digit OTP
    return otp;
  }

  @override
  void onClose() {
    emialController.dispose();

    super.onClose();
  }
}