// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:quick_bites/widgets/custom_button.dart';
import 'package:quick_bites/widgets/custom_input.dart';
import 'package:quick_bites/widgets/custom_input_field.dart';

class ProfileForms {
  /// ---------------- PERSONAL INFO FORM ----------------
   static Widget personalInfoForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputField(
            controller: nameCtrl,
            hintText: "Full Name",
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: emailCtrl,
            hintText: "Email",
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 20),
          CustomButton(label: "Save", onPressed: () {
            if (formKey.currentState!.validate()) {
              // Save personal info logic here
            }
          }),
        ],
      ),
    );
  }

  /// ---------------- ADDRESS FORM ----------------
  static Widget addressForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController addressCtrl,
    required TextEditingController cityCtrl,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputField(
            controller: addressCtrl,
            hintText: "Address Line 1", prefixIcon: Icons.home,
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: cityCtrl,
            hintText: "City", prefixIcon: Icons.location_city,
          ),
          const SizedBox(height: 20),
          CustomButton(label: "Save", onPressed: () {
            if (formKey.currentState!.validate()) {
              // Save address logic here
            }
          }),
        ],
      ),
    );
  }

  /// ---------------- PAYMENT METHOD FORM ----------------
  static Widget paymentMethodForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController cardNumberCtrl,
    required TextEditingController expiryCtrl,
    required TextEditingController cvvCtrl,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputField(
            controller: cardNumberCtrl,
            hintText: "Card Number",
            prefixIcon: Icons.credit_card,
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: expiryCtrl,
            hintText: "Expiry Date",
            prefixIcon: Icons.date_range,
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: cvvCtrl,
            hintText: "CVV",
            prefixIcon: Icons.lock,
          ),
          const SizedBox(height: 20),
          CustomButton(label: "Save", onPressed: () {
            if (formKey.currentState!.validate()) {
              // Save payment method logic here
            }
          }),
        ],
      ),
    );
  }

  /// ---------------- SETTINGS FORM ----------------
  static Widget settingsForm({
    required bool notificationsEnabled,
    required ValueChanged<bool> onNotificationsChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
          title: const Text("Enable Notifications"),
        ),
        const SizedBox(height: 20),
        CustomButton(label: "Save Settings", onPressed: () {
          // Save settings logic here
        }),
      ],
    );
  }
}
