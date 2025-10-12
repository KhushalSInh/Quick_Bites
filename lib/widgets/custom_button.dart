import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isLoading;
  final Color? foregroundColor;
  final int elevation;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.height = 55,
    this.width,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.borderRadius = 8,
    this.isLoading = false,
    this.foregroundColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation.toDouble(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
