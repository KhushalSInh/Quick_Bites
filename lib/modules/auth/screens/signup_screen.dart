// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bites/core/routs/routs.dart';
import 'package:quick_bites/widgets/custom_button.dart';
import 'package:quick_bites/widgets/custom_input.dart';
import '../Controller/singup_controller.dart' show SingupController;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final SingupCtrl = Get.put(SingupController()); // Inject controller

    return Scaffold(
      //SingleChildScrollView to have an scrol in the screen
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //We will copy the previous textfield we designed to avoid time consuming
                  const ListTile(
                    title: Text(
                      "Register New Account",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  CustomInputField(
                    controller: SingupCtrl.usernameController,
                    hintText: "Username",
                    prefixIcon: Icons.person,
                    validator: SingupCtrl.validateUsername,
                  ),

                  CustomInputField(
                    controller: SingupCtrl.emailController,
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    validator: SingupCtrl.validateEmial,
                  ),
                  // password
                  Obx(
                    () => CustomInputField(
                      controller: SingupCtrl.passwordController,
                      hintText: "Password",
                      prefixIcon: Icons.lock,
                      obscureText: !SingupCtrl.isPasswordVisible.value,
                      showSuffixIcon: true,
                      suffixIcon: SingupCtrl.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixTap: SingupCtrl.togglePasswordVisibility,
                      validator: SingupCtrl.validatePassword,
                    ),
                  ),

                  const SizedBox(height: 10),
                  //singup button
                  CustomButton(
                    label: "SIGN UP",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        SingupCtrl.signup(context);
                      }
                    },
                  ),

                  //Sign up button
                  Container(
                    margin: EdgeInsets.only(top:20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
