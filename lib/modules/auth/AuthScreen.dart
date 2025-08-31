// ignore: duplicate_ignore
// ignore: file_names


// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/modules/auth/AuthFroms.dart';
import 'package:quick_bites/modules/auth/Controller/forgetPassword_controller.dart';
import 'package:quick_bites/modules/auth/Controller/login_controller.dart';
import 'package:quick_bites/modules/auth/Controller/otp_controller.dart';
import 'package:quick_bites/modules/auth/Controller/singup_controller.dart';


enum AuthMode { login, signup, forgot, otp ,changePass }

class AuthScreen extends StatefulWidget {
  final AuthMode mode; 

  const AuthScreen({super.key, required this.mode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthMode _authMode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  final SingupCtrl = Get.put(SingupController());
  final loginCtrl = Get.put(LoginController());
  final OtpController otpController = Get.put(OtpController(otpLength: 4));
  final  forgetCtrl  = Get.put(ForgetpasswordController());

  bool isVisible = false;
  //Here is our bool variable
  bool isLoginTrue = false;

  @override
  void initState() {
    super.initState();
    _authMode = widget.mode; // initialize with passed parameter
  }

  String get _title {
    switch (_authMode) {
      case AuthMode.login:
        return "Log In";
      case AuthMode.signup:
        return "Sign Up";
      case AuthMode.forgot:
        return "Forgot Password";
      case AuthMode.otp:
         return "OTP Verification";
      case AuthMode.changePass:
          return "Change Password";
    }
  }
  // 📝 Dynamic Subtitle
  String get _subtitle {
    switch (_authMode) {
      case AuthMode.login:
        return "Please sign in to your account";
      case AuthMode.signup:
        return "Create your account";
      case AuthMode.forgot:
        return "Reset your password here";
      case AuthMode.otp:
         return "Please enter the OTP sent to your email";
      case AuthMode.changePass:
          return "Set your new password";
    }
  }

  // 📝 Dynamic Form
  Widget get _form {
    switch (_authMode) {
      case AuthMode.login:
        return AuthForms.loginForm(
          formKey: formKey,
          loginCtrl: loginCtrl,
          context: context,
          isLoginTrue: isLoginTrue,
        );

      case AuthMode.signup:
        return AuthForms.signupForm(
          formKey: formKey,
          signupCtrl: SingupCtrl,
          context: context,
        );
      case AuthMode.forgot:
        return AuthForms.forgetPassword(
          formKey: formKey,
          forgetCtrl: forgetCtrl,
          context: context,
        );
      case AuthMode.otp:
          return AuthForms.otpFillUpForm(
            formKey: formKey,
            otpController: otpController,
            context: context,
          );
    case AuthMode.changePass:
      return AuthForms.changePasswordForm(
        formKey: formKey,
        loginCtrl: loginCtrl,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D2B),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // 🔵 Top Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 120, bottom: 40),
                      child: Column(
                        children: [
                          Text(
                            _title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ⚪ Bottom Section
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 40,
                        ),
                        child: _form,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
