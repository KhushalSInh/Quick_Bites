// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/core/utils/dialog_helper.dart';
import 'package:quick_bites/modules/auth/Controller/forgetPassword_controller.dart';
import 'package:quick_bites/widgets/custom_message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  final int otpLength;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  var start = 30.obs;
  var isResendAvailable = false.obs;
  Timer? _resendTimer;

  OtpController({this.otpLength = 4});

  @override
  void onInit() {
    super.onInit();
    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    _startResendTimer();
  }

  void onOtpChange(String value, int index, BuildContext context) {
    if (value.length == 1 && index < otpLength - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    if (controllers.every((c) => c.text.length == 1)) {
      submitOtp(context);
    }
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  Future<String?> getStoredOTP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_otp');
  }

  Future<void> submitOtp(BuildContext context) async {
    final userOtp = getOtp();
    final prefs = await SharedPreferences.getInstance();
    final otp = await getStoredOTP();

    if (!context.mounted) return; // <--- prevents crash

    if (otp != null && userOtp == otp) {
      showCustomMessageDialog(
        context,
        message: "OTP Verified Successfully",
        type: MessageType.success,
      );
      prefs.remove('user_otp');
      prefs.remove('user_email');
    } else {
      showCustomMessageDialog(
        context,
        message: "Invalid OTP. Please try again.",
        type: MessageType.error,
      );
    }
  }

  Future<void> handleResend(BuildContext context) async {
    if (!isResendAvailable.value) return;

    final pasw = Get.put(ForgetpasswordController());
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    
    pasw.sendEmial(context, email: email.toString());

    if (!context.mounted) return; // <--- prevents crash

    showCustomMessageDialog(
      context,
      message: "OTP Sent Successfully",
      type: MessageType.success,
    );

    for (var c in controllers) {
      c.clear();
    }
    focusNodes[0].requestFocus();
    _startResendTimer();
  }

  void _startResendTimer() {
    isResendAvailable.value = false;
    start.value = 30;
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        isResendAvailable.value = true;
        timer.cancel();
      } else {
        start.value--;
      }
    });
  }

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.onClose();
  }
}