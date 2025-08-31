import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

import 'package:quick_bites/modules/auth/Controller/forgetPassword_controller.dart';
import 'package:quick_bites/widgets/custom_button.dart';
import 'package:quick_bites/widgets/custom_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final forgetPass =Get.put( ForgetpasswordController()); 

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Lottie.asset("assets/animation/Burger.json",width: 210),
                
                  const SizedBox(height: 15),

                  CustomInputField(
                    controller: forgetPass.emialController,
                    hintText: "Email",
                    prefixIcon: Icons.person,
                    validator: forgetPass.validateEmail,
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                     label: "Send Email", onPressed: () { 
                        forgetPass.sendEmial(context);
                      },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
