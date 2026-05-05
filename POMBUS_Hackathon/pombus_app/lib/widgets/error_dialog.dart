import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const ErrorDialog({
    Key? key,
    this.title = 'Erro',
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: onDismiss, child: const Text('OK'))],
    );
  }
}

void showErrorDialog(
  BuildContext context,
  String message, {
  String title = 'Erro',
}) {
  showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      title: title,
      message: message,
      onDismiss: () => Navigator.of(context).pop(),
    ),
  );
}
