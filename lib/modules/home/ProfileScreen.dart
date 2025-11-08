// ignore_for_file: fileNames, use_build_context_synchronously, deprecated_member_use

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
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isLogout 
              ? Colors.red.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : iconColor ?? Colors.orange,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: subtitle != null ? Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ) : null,
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isLogout ? Colors.red : Colors.grey,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("IsLogin");
                await prefs.remove("user_id");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.LoginAuth,
                  (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 30),
                  
            //       // User Profile Section
            //       Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 16),
            //         padding: const EdgeInsets.all(24),
            //         decoration: BoxDecoration(
            //           gradient: const LinearGradient(
            //             begin: Alignment.topLeft,
            //             end: Alignment.bottomRight,
            //             colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
            //           ),
            //           borderRadius: BorderRadius.circular(24),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.orange.withOpacity(0.3),
            //               blurRadius: 20,
            //               offset: const Offset(0, 8),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           children: [
            //             Container(
            //               width: 80,
            //               height: 80,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 border: Border.all(color: Colors.white, width: 3),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: Colors.black.withOpacity(0.1),
            //                     blurRadius: 10,
            //                     offset: const Offset(0, 4),
            //                   ),
            //                 ],
            //               ),
            //               child: const CircleAvatar(
            //                 backgroundImage: AssetImage("assets/images/user.png"),
            //               ),
            //             ),
            //             const SizedBox(width: 16),
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: const [
            //                   Text(
            //                     "User Name",
            //                     style: TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   SizedBox(height: 4),
            //                   Text(
            //                     "I love fast food 🍔",
            //                     style: TextStyle(
            //                       color: Colors.white70,
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                   SizedBox(height: 8),
            //                   LinearProgressIndicator(
            //                     value: 0.7,
            //                     backgroundColor: Colors.white30,
            //                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //                     borderRadius: BorderRadius.all(Radius.circular(10)),
            //                   ),
            //                   SizedBox(height: 4),
            //                   Text(
            //                     "Profile 70% complete",
            //                     style: TextStyle(
            //                       color: Colors.white70,
            //                       fontSize: 12,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Account",
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.user,
                    title: "Personal Info",
                    subtitle: "Update your personal details",
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
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuItem(
                    icon: LucideIcons.mapPin,
                    title: "Addresses",
                    subtitle: "Manage your delivery addresses",
                    onTap: () {
                       Navigator.pushNamed(context, AppRoutes.Address);
                    },
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: _buildSection(
                title: "Preferences",
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.listOrdered,
                    title: "Orders",
                    subtitle: "items waiting",
                     onTap: () {
                       Navigator.pushNamed(context, AppRoutes.orderhistory);
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuItem(
                    icon: LucideIcons.heart,
                    title: "Favourite",
                    subtitle: "liked items",
                    onTap: () {
                       Navigator.pushNamed(context, AppRoutes.Favorite);
                    },
                  ),
                  
                 
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: _buildSection(
                title: "More",
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.settings,
                    title: "Settings",
                    subtitle: "App preferences",
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: _buildSection(
                title: "",
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.logOut,
                    title: "Logout",
                    isLogout: true,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}