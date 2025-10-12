// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/modules/auth/Controller/changePassword.dart';
import 'package:quick_bites/modules/auth/Controller/forgetPassword_controller.dart';
import 'package:quick_bites/modules/auth/Controller/login_controller.dart';
import 'package:quick_bites/modules/auth/Controller/otp_controller.dart';
import 'package:quick_bites/modules/auth/Controller/singup_controller.dart';
import 'package:quick_bites/widgets/custom_button.dart';
import 'package:quick_bites/widgets/custom_input.dart' show CustomInputField;

class AuthForms {

  /// ---------------- LOGIN FORM ----------------
  static Widget loginForm({
    required GlobalKey<FormState> formKey,
    required LoginController loginCtrl,
    required BuildContext context,
    required bool isLoginTrue,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInputField(
            controller: loginCtrl.emialController,
            hintText: "Email",
            prefixIcon: Icons.person,
            validator: loginCtrl.validateUsername,
          ),
          const SizedBox(height: 15),

          Obx(
            () => CustomInputField(
              controller: loginCtrl.passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock,
              obscureText: !loginCtrl.isPasswordVisible.value,
              showSuffixIcon: true,
              suffixIcon: loginCtrl.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              onSuffixTap: loginCtrl.togglePasswordVisibility,
              validator: loginCtrl.validatePassword,
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.ForgotAuth);
              },
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 10),

          CustomButton(
            label: "Login",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                loginCtrl.login(context);
              }
            },
          ),

          if (isLoginTrue)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Username or password is incorrect",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.SignupAuth);
                },
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const SizedBox(height: 15),

          Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              // Social login icons if needed
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- SIGNUP FORM ----------------
  static Widget signupForm({
    required GlobalKey<FormState> formKey,
    required SingupController signupCtrl,
    required BuildContext context,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInputField(
            controller: signupCtrl.usernameController,
            hintText: "Username",
            prefixIcon: Icons.person,
            validator: signupCtrl.validateUsername,
          ),

          CustomInputField(
            controller: signupCtrl.emailController,
            hintText: "Email",
            prefixIcon: Icons.email_outlined,
            validator: signupCtrl.validateEmial,
          ),

          Obx(
            () => CustomInputField(
              controller: signupCtrl.passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock,
              obscureText: !signupCtrl.isPasswordVisible.value,
              showSuffixIcon: true,
              suffixIcon: signupCtrl.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              onSuffixTap: signupCtrl.togglePasswordVisibility,
              validator: signupCtrl.validatePassword,
            ),
          ),

          const SizedBox(height: 10),

          CustomButton(
            label: "SIGN UP",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                signupCtrl.signup(context);
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.LoginAuth);
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- FORGETPASSWORD FORM ----------------
  static Widget forgetPassword({
    required GlobalKey<FormState> formKey,
    required ForgetpasswordController forgetCtrl,
    required BuildContext context,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInputField(
            controller: forgetCtrl.emialController,
            hintText: "Email",
            prefixIcon: Icons.person,
            validator: forgetCtrl.validateEmail,
          ),
          const SizedBox(height: 15),
          CustomButton(
            label: "Send OTP to Email",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                forgetCtrl.sendEmial(
                  context,
                  email: forgetCtrl.emialController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// ---------------- OTP FILL FORM ----------------
  static Widget otpFillUpForm({
    required GlobalKey<FormState> formKey,
    required OtpController otpController,
    required BuildContext context,
  }) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(otpController.otpLength, (index) {
            return SizedBox(
              width: 60,
              height: 60,
              child: TextField(
                controller: otpController.controllers[index],
                focusNode: otpController.focusNodes[index],
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
                onChanged: (value) =>
                    otpController.onOtpChange(value, index, context),
              ),
            );
          }),
        ),
        const SizedBox(height: 30),

        CustomButton(
          label: "Submit OTP",
          onPressed: () => otpController.submitOtp(context),
        ),
        const SizedBox(height: 20),

        Obx(
          () => TextButton(
            onPressed: otpController.isResendAvailable.value
                ? () => otpController.handleResend(context)
                : null,
            child: Text(
              otpController.isResendAvailable.value
                  ? "Resend OTP"
                  : "Resend in ${otpController.start.value} seconds",
              style: TextStyle(
                color: otpController.isResendAvailable.value
                    ? Colors.blue
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- CHANGEPASS FORM ----------------
  static Widget changePasswordForm({
    required GlobalKey<FormState> formKey,
    required ChangePasswordController ChangePassCtrl,
    required BuildContext context,
    // required bool isLoginTrue,
  }) {
    return Form(
     
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomInputField(
              controller: ChangePassCtrl.newPasswordController,
              hintText: "New Password",
              prefixIcon: Icons.lock,
              obscureText: !ChangePassCtrl.isPasswordVisible.value,
              showSuffixIcon: true,
              suffixIcon: ChangePassCtrl.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              onSuffixTap: ChangePassCtrl.togglePasswordVisibility,
              validator: ChangePassCtrl.validatePassword,
            ),
          ),

          Obx(
            () => CustomInputField(
              controller: ChangePassCtrl.confirmNewPasswordController,
              hintText: "Confirm Password",
              prefixIcon: Icons.lock,
              obscureText: !ChangePassCtrl.isPasswordVisible.value,
              showSuffixIcon: true,
              suffixIcon: ChangePassCtrl.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              onSuffixTap: ChangePassCtrl.togglePasswordVisibility,
              validator: ChangePassCtrl.validatePassword,
            ),
          ),

          const SizedBox(height: 15),

          CustomButton(
            label: "Change Password",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ChangePassCtrl.changePassword(context);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}