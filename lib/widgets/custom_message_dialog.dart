import 'package:flutter/material.dart';

enum MessageType { error, success, info, warning }

class CustomMessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final MessageType type;
  final VoidCallback onClose;

  const CustomMessageDialog({
    super.key,
    required this.message,
    required this.type,
    required this.onClose,
    this.title = '',
  });

  IconData get _icon {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle_outline;
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  Color get _color {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.redAccent;
      case MessageType.info:
        return Colors.blueAccent;
      case MessageType.warning:
        return Colors.orangeAccent;
    }
  }

  String get _defaultTitle {
    switch (type) {
      case MessageType.success:
        return "Success";
      case MessageType.error:
        return "Error";
      case MessageType.info:
        return "Information";
      case MessageType.warning:
        return "Warning";
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = title.isEmpty ? _defaultTitle : title;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ), // Increased padding for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 60, color: _color),
            const SizedBox(height: 15), // Adjusted spacing
            Text(
              displayTitle,
              textAlign: TextAlign
                  .center, // Center align the title for better aesthetics
              style: TextStyle(
                fontSize: 24, // Slightly larger font size for the title
                fontWeight: FontWeight.bold,
                color: _color,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    3,
                  ), // Adjusted border radius to 3
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ), // Increased padding for a larger button
              ),
              onPressed: onClose,
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Make the button text bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
