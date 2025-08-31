// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/modules/auth/Controller/login_controller.dart';
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
                Navigator.pushNamed(context, AppRoutes.forgetPassword);
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
      child:  Column(
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
}
