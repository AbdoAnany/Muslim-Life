import 'package:azkar/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// RTL-aware scaffold with consistent app bar styling from [ThemeData].
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppTokens.surface,
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

/// Home hub — no app bar, branded surface background.
class AppHomeShell extends StatelessWidget {
  const AppHomeShell({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTokens.surface,
        body: body,
      ),
    );
  }
}
