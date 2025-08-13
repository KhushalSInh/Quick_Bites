
import 'package:flutter/material.dart';
import '../../widgets/custom_message_dialog.dart';

void showCustomMessageDialog(
    BuildContext context, {
      required String message,
      required MessageType type,
      String title = '',
    }) {
  showDialog(
    context: context,
    builder: (context) => CustomMessageDialog(
      message: message,
      type: type,
      title: title,
      onClose: () => Navigator.of(context).pop(),
    ),
  );
}
