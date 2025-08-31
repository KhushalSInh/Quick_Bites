// // change_password_controller.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChangePasswordController extends GetxController {
 
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmNewPasswordController = TextEditingController();

//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   @override
//   void onClose() {
//     newPasswordController.dispose();
//     confirmNewPasswordController.dispose();
//     super.onClose();
//   }

//   Future<void> changePassword() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     // Simple validation checks
//     if (newPasswordController.text != confirmNewPasswordController.text) {
//       errorMessage.value = 'New password and confirm password do not match.';
//       isLoading.value = false;
//       return;
//     }

//     if (newPasswordController.text.length < 6) {
//       errorMessage.value = 'Password must be at least 6 characters long.';
//       isLoading.value = false;
//       return;
//     }

//     try {
//       // Your password change logic
//       // No need to pass currentPassword
//       await Future.delayed(const Duration(seconds: 2));

//       Get.snackbar(
//         'Success',
//         'Password changed successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

// ignore_for_file: file_names

//       // Clear text fields after success
//       newPasswordController.clear();
//       confirmNewPasswordController.clear();
//     } catch (e) {
//       errorMessage.value = 'Failed to change password: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }