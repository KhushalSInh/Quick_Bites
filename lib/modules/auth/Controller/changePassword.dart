// change_password_controller.dart

// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  var isPasswordVisible = false.obs;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  Future<void> changePassword(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = '';

    // Simple validation checks
    if (newPasswordController.text != confirmNewPasswordController.text) {
      errorMessage.value = 'New password and confirm password do not match.';
      isLoading.value = false;
      return;
    }

    if (newPasswordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters long.';
      isLoading.value = false;
      return;
    }

    void changePassword(BuildContext context) async {
      final newPassword = newPasswordController.text.trim();
      final confirmPassword = confirmNewPasswordController.text.trim();

      // Validation
      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        showCustomMessageDialog(
          context,
          message: "Please fill in all fields.",
          type: MessageType.error,
        );
        return;
      }

      if (newPassword != confirmPassword) {
        showCustomMessageDialog(
          context,
          message: "Passwords do not match.",
          type: MessageType.error,
        );
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? uid = prefs.getInt("user_id");

      final Map<String, dynamic> responseData = await ApiService.request(
        url: ApiDetails.changePasswordApi,
        method: "POST",
        body: {
          "id": uid.toString(),
          "new_password": newPassword,
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

      if (responseData['message'] == "Password updated successfully") {
        showCustomMessageDialog(
          context,
          message: "Password updated successfully.",
          type: MessageType.success,
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); // Go back after success
        });
      } else {
        showCustomMessageDialog(
          context,
          message: responseData['message'] ?? 'Password change failed.',
          type: MessageType.error,
        );
      }
    }

    
  }
}