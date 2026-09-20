import 'package:flutter/material.dart';

/// Legacy screens — delegates to global [ThemeData.appBarTheme] (teal DLS).
class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleAppBar({super.key, this.title = ''});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
