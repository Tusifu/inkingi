import 'package:flutter/material.dart';

class TToast {
  static void show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final backgroundColor = isSuccess ? Colors.green : Colors.red;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
    );
  }
}
