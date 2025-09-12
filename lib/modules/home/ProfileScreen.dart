import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // for nice icons

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
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
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/32.jpg"), // replace with real user
                ),
                SizedBox(height: 10),
                Text(
                  "Vishal Khadok",
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
              _buildMenuItem(
                  icon: LucideIcons.user, title: "Personal Info", onTap: () {}),
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
              _buildMenuItem(icon: LucideIcons.helpCircle, title: "FAQs"),
              _buildMenuItem(icon: LucideIcons.star, title: "User Reviews"),
              _buildMenuItem(icon: LucideIcons.settings, title: "Settings"),
            ]),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
