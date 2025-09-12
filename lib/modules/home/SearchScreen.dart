import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: Text("🔍 Search Screen",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      );
}