import 'package:flutter/material.dart';
import 'package:quick_bites/modules/auth/screens/fill_otp.dart';
import 'package:quick_bites/modules/auth/screens/forget_password.dart';
import 'screens/splash_screen.dart';
import 'modules/auth/screens/login_screen.dart';
import 'modules/auth/screens/signup_screen.dart';
import 'modules/home/Home_Screen.dart';
import 'screens/welcome_screen.dart';
import 'core/routs/routs.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Bites',
     
      // home: SplashScreen(),
       debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
       routes: {
        AppRoutes.splash: (context) =>  AnimatedSplashScreenWidget(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignUpScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.forgetPassword: (context) => const ForgetPassword(),
        AppRoutes.fillOtp: (context) => const OtpScreen(),
      },
    );
    
  }
}


