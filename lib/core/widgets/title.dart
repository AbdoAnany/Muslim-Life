import 'package:azkar/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: Theme.of(context).appBarTheme.titleTextStyle ??
          const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );
  }
}

/// Large section title on light surfaces (not app bars).
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTokens.brand,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
