// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:quick_bites/modules/home/CartScreen.dart';
import 'package:quick_bites/modules/home/Home_Screen.dart';
import 'package:quick_bites/modules/home/ProfileScreen.dart';
import 'package:quick_bites/modules/home/SearchScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Overlay form screen
  Widget? _currentForm;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _currentForm = null; // Close form if switching tabs
    });
  }

  void openForm(Widget form) {
    setState(() {
      _currentForm = form;
    });
  }

  void closeForm() {
    setState(() {
      _currentForm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_currentForm != null)
            // Form overlay
            Positioned.fill(
              child: Material(
                color: Colors.white,
                child: Column(
                  children: [
                    AppBar(
                      title: const Text("Form"),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: closeForm,
                      ),
                    ),
                    Expanded(child: _currentForm!),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _currentForm == null ? buildBottomNav() : null,
    );
  }

  Widget buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 26), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
