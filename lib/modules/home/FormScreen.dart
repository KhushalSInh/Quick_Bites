import 'package:flutter/material.dart';

import 'package:quick_bites/modules/home/UserAppForms.dart';
enum FormMode {
  personalInfo,
  addresses,
  cart,
  favourite,
  notifications,
  paymentMethod,
  userReviews,
  settings,
}


class FormScreen extends StatelessWidget {
  final FormMode mode;

  const FormScreen({super.key, required this.mode, required String title, Widget? formWidget});

  Widget _buildFormContent() {
    switch (mode) {
      case FormMode.personalInfo:
        final formKey = GlobalKey<FormState>();
        final nameCtrl = TextEditingController();
        final emailCtrl = TextEditingController();
        return ProfileForms.personalInfoForm(formKey: formKey, nameCtrl: nameCtrl, emailCtrl: emailCtrl);
      case FormMode.addresses:
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Address Line 1"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Address Line 2"),
            ),
          ],
        );
      case FormMode.cart:
        return const Center(child: Text("Cart is empty"));
      case FormMode.favourite:
        return const Center(child: Text("No favourites yet"));
      case FormMode.notifications:
        return const Center(child: Text("Notification settings here"));
      case FormMode.paymentMethod:
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Card Number"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Expiry Date"),
            ),
          ],
        );
      case FormMode.userReviews:
        return const Center(child: Text("User reviews form here"));
      case FormMode.settings:
        return const Center(child: Text("Settings form here"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mode.toString().split('.').last.replaceAll(RegExp('([A-Z])'), '').trim()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildFormContent(),
      ),
    );
  }
}

