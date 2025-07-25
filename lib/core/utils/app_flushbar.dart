import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class AppFlushbar {
  static Future<void> showSuccess(BuildContext context, String message) {
    return Flushbar(
      message: message,
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      messageSize: 16,
    ).show(context);
  }

  static Future<void> showError(BuildContext context, String message) {
    return Flushbar(
      message: message,
      backgroundColor: Colors.red,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      messageSize: 16,
    ).show(context);
  }
}
