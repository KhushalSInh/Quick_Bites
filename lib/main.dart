import 'package:flutter/material.dart';
import 'package:quick_bites/modules/auth/AuthScreen.dart';
import 'package:quick_bites/modules/home/MainLayout.dart';
// import 'modules/home/Home_Screen.dart';
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
      initialRoute: AppRoutes.welcome,
       routes: {
        // AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.LoginAuth: (context) => AuthScreen(mode: AuthMode.login), 
        AppRoutes.SignupAuth: (context) => AuthScreen(mode: AuthMode.signup), 
        AppRoutes.ForgotAuth: (context) => AuthScreen(mode: AuthMode.forgot), 
        AppRoutes.OtpFillAuth: (context) => AuthScreen(mode: AuthMode.otp),
        AppRoutes.ChangePassAuth: (context) => AuthScreen(mode: AuthMode.changePass),

         /// Add this route for the post-login main area
        AppRoutes.mainLayout: (context) => const MainLayout(),
      },
    );
    
  }
}


