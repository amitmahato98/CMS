import 'package:flutter/material.dart';

class AppErrorHandler {
  static DateTime? _lastErrorTime;
  static String? _lastErrorMessage;
  static const _throttleDuration = Duration(seconds: 4);

  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    bool force = false,
  }) {
    final now = DateTime.now();

    // Throttling and deduplication
    if (!force && _lastErrorTime != null && _lastErrorMessage == message) {
      if (now.difference(_lastErrorTime!) < _throttleDuration) {
        return; // Ignore duplicate error within 4 seconds
      }
    }

    _lastErrorTime = now;
    _lastErrorMessage = message;

    // Must be on next frame if we might be in build phase,
    // but better to avoid calling from build phase entirely.
    // If called from build phase, this is a fallback safety net.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  // Clear tracking
  static void clearState() {
    _lastErrorMessage = null;
    _lastErrorTime = null;
  }
}
