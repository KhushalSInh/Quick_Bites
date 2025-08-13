import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_bites/screens/welcome_screen.dart';

class AnimatedSplashScreenWidget extends StatelessWidget{
  const AnimatedSplashScreenWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
      return AnimatedSplashScreen(
        splash: Center(
          child: Lottie.asset("assets/animation/Burger loader.json"),
        ),
        nextScreen:  WelcomeScreen(),
        splashIconSize: 400,
        backgroundColor: Colors.white,
        duration: 5000,
      );
  }
}