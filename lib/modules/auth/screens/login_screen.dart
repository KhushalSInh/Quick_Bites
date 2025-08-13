import 'package:flutter/material.dart';
import 'package:quick_bites/core/routs/routs.dart';

import 'package:quick_bites/widgets/custom_button.dart';
import 'package:quick_bites/widgets/custom_input.dart';
import 'package:get/get.dart';
import 'package:quick_bites/modules/auth/Controller/login_controller.dart';

// import '../auth/auth_service.dart';
import 'signup_screen.dart';

// import '../utils/dialog_helper.dart'; // import helper
// import '../widgets/custom_message_dialog.dart'; // import enum

// add the import statement
// import  'package:delightful_toast/delight_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //We need two text editing controller

  //TextEditing controller to control the text when we enter into it
  final username = TextEditingController();
  final password = TextEditingController();
  bool rememberMe = false;

  //A bool variable for show and hide password
  bool isVisible = false;

  //Here is our bool variable
  bool isLoginTrue = false;

  //Now we should call this function in login button

  //We have to create global key for our form
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final loginCtrl = Get.put(LoginController()); // Inject controller
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
                    Container(
                      width: double.infinity,
                      color: Color(0xFF0C0D2B),
                      padding: const EdgeInsets.only(top: 120, bottom: 40),
                      child: const Column(
                        children: [
                          Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Please sign in to your existing account",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

               
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
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                        child: Form(
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
                                  obscureText:
                                      !loginCtrl.isPasswordVisible.value,
                                  showSuffixIcon: true,
                                  suffixIcon: loginCtrl.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onSuffixTap:
                                      loginCtrl.togglePasswordVisibility,
                                  validator: loginCtrl.validatePassword,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.forgetPassword,
                                    );
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              const Center(child: Text("Or")),
                              const SizedBox(height: 15),

                              Wrap(
                                spacing: 20,
                                alignment: WrapAlignment.center,
                                children: [
                                  // socialIcon(Icons.facebook, Colors.blue),
                                  // socialIcon(
                                  // Icons.alternate_email,
                                  // Colors.teal,
                                  // ),
                                  // socialIcon(Icons.apple, Colors.black),
                                ],
                              ),
                            ],
                          ),
                        ),
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
