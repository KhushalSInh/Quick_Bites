import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_bites/modules/home/Home_Screen.dart';
import 'package:quick_bites/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedSplashScreenWidget extends StatefulWidget {
  const AnimatedSplashScreenWidget({super.key});

  @override
  State<AnimatedSplashScreenWidget> createState() =>
      _AnimatedSplashScreenWidgetState();
}

class _AnimatedSplashScreenWidgetState
    extends State<AnimatedSplashScreenWidget> {
  bool? isLoggedIn; // null = loading

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final islg = prefs.getBool("IsLogin") ?? false;

    setState(() {
      isLoggedIn = islg;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loader until SharedPreferences value is fetched
    if (isLoggedIn == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset("assets/animation/Burger loader.json"),
      ),
      nextScreen: isLoggedIn! ? HomeScreen() : WelcomeScreen(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 5000,
    );
  }
}
