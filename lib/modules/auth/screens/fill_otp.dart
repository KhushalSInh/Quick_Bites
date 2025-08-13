import 'package:flutter/material.dart';
import 'dart:async';

import 'package:quick_bites/widgets/custom_button.dart';

// Dummy resend function (replace with your actual API call)
Future<void> resendOtp() async {
  print("OTP resent");
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _resendTimer;
  int _start = 30;
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _isResendAvailable = false;
      _start = 30;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onOtpChange(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto submit if all 4 digits are filled
    if (_controllers.every((c) => c.text.length == 1)) {
      _submitOtp();
    }
  }

  void _submitOtp() {
    if (_formKey.currentState!.validate()) {
      String otp = _controllers.map((c) => c.text).join();
      print("Auto-submitted OTP: $otp");
      // TODO: Add your API call logic here
    }
  }

  void _handleResend() {
    if (_isResendAvailable) {
      resendOtp();
      _controllers.forEach((c) => c.clear());
      _focusNodes[0].requestFocus();
      _startResendTimer();
    }
  }


    // ignore: dead_code
  @override
    Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: const Color(0xFF0C0D2B),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      color: Color(0xFF0C0D2B),
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 120, bottom: 40),
                      child: const Column(
                        children: [
                          Text(
                            "Enter OTP",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "A 4-digit code has been sent to your email",
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // White Body (no radius at top)
                    Expanded(
                      child: Container(
                        
                        width: double.infinity,

                        decoration:BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        )
                        ,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // OTP Boxes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(4, (index) {
                                  return SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: TextFormField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      style: const TextStyle(fontSize: 24),
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) => _onOtpChange(value, index),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 30),

                              // Custom Button
                              CustomButton(
                                label: "Submit OTP",
                                onPressed: _submitOtp,
                              ),

                              const SizedBox(height: 20),

                              // Resend OTP
                              TextButton(
                                onPressed: _isResendAvailable ? _handleResend : null,
                                child: Text(
                                  _isResendAvailable
                                      ? "Resend OTP"
                                      : "Resend in $_start seconds",
                                  style: TextStyle(
                                    color: _isResendAvailable ? Colors.blue : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
  }

