// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool showSuffixIcon;
  final VoidCallback? onSuffixTap;
  final IconData? suffixIcon;
  final FormFieldValidator<String>? validator;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.onSuffixTap,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(.2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(prefixIcon),
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: showSuffixIcon && suffixIcon != null
              ? IconButton(
                  onPressed: onSuffixTap,
                  icon: Icon(suffixIcon),
                )
              : null,
        ),
      ),
    );
  }
}

