// change_password_controller.dart

// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/Data/Api/api.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

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

    if (newPassword.length < 6) {
      showCustomMessageDialog(
        context,
        message: "Password must be at least 6 characters long.",
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

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString("user_email"); // Changed to getString

      // Validate email
      if (userEmail == null || userEmail.isEmpty) {
        showCustomMessageDialog(
          context,
          message: "User email not found. Please login again.",
          type: MessageType.error,
        );
        return;
      }

      // Call API
      final Map<String, dynamic> responseData = await ApiService.request(
        url: ApiDetails.ResetPasswordApi,
        method: "POST",
        body: {
          "email": userEmail,
          "new_password": newPassword,
        },
      );

      ;

      // Handle response based on 'success' field
      if (responseData['success'] == true) {
        showCustomMessageDialog(
          context,
          message: responseData['message'] ?? "Password updated successfully.",
          type: MessageType.success,
        );

        // Clear form and navigate back
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.LoginAuth,
            (route) => false,
          );
        });
      } else {
        showCustomMessageDialog(
          context,
          message: responseData['message'] ?? 'Password change failed.',
          type: MessageType.error,
        );
      }
    } catch (e) {
      print("Error changing password: $e");
      showCustomMessageDialog(
        context,
        message: "Network error: Please check your connection.",
        type: MessageType.error,
      );
    }
  }
}
