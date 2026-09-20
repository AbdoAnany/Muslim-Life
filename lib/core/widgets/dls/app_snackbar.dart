import 'package:azkar/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: isError ? AppTokens.error : null,
    ),
  );
}
