import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quick_bites/modules/auth/AuthScreen.dart';
import 'package:quick_bites/modules/home/MainLayout.dart';
import 'screens/welcome_screen.dart';
import 'core/routs/routs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("IsLogin") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Bites',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const MainLayout(); // ✅ User already logged in
          } else {
            return const WelcomeScreen(); // Show welcome/login/signup
          }
        },
      ),
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.LoginAuth: (context) => AuthScreen(mode: AuthMode.login),
        AppRoutes.SignupAuth: (context) => AuthScreen(mode: AuthMode.signup),
        AppRoutes.ForgotAuth: (context) => AuthScreen(mode: AuthMode.forgot),
        AppRoutes.OtpFillAuth: (context) => AuthScreen(mode: AuthMode.otp),
        AppRoutes.ChangePassAuth: (context) => AuthScreen(mode: AuthMode.changePass),
        AppRoutes.mainLayout: (context) => const MainLayout(),
        
      },
    );
  }
}
