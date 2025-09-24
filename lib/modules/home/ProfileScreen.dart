// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:quick_bites/modules/home/FormScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_bites/core/routs/routs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 0,
      color: Colors.grey[100],
      child: Column(children: children),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("IsLogin"); // or prefs.clear() if you want to clear everything
    await prefs.remove("user_id");
    // Navigate back to welcome/login screen and remove previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.LoginAuth,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // User Profile Section
            Column(
              children: const [
                CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/user.png")),
                SizedBox(height: 10),
                Text(
                  "User Name",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  "I love fast food",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
              ],
            ),

            // First Card
            _buildCard([
              // Example inside _buildMenuItem onTap:
              _buildMenuItem(
                icon: LucideIcons.user,
                title: "Personal Info",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormScreen(
                        title: "Personal Info",
                        mode: FormMode.personalInfo,
                      ),
                    ),
                  );
                },
              ),

              _buildMenuItem(
                  icon: LucideIcons.mapPin, title: "Addresses", onTap: () {}),
            ]),

            // Second Card
            _buildCard([
              _buildMenuItem(icon: LucideIcons.shoppingCart, title: "Cart"),
              _buildMenuItem(icon: LucideIcons.heart, title: "Favourite"),
              _buildMenuItem(icon: LucideIcons.bell, title: "Notifications"),
              _buildMenuItem(
                  icon: LucideIcons.creditCard, title: "Payment Method"),
            ]),

            // Third Card
            _buildCard([
              _buildMenuItem(icon: LucideIcons.star, title: "User Reviews"),
              _buildMenuItem(icon: LucideIcons.settings, title: "Settings"),
            ]),

            // Logout Card (Separate & Highlighted)
            _buildCard([
              _buildMenuItem(
                icon: LucideIcons.logOut,
                title: "Logout",
                color: Colors.red, // Make it stand out
                onTap: () => _logout(context),
              ),
            ]),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
