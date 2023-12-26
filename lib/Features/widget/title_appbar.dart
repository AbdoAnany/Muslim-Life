import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/core/widgets/title.dart';
import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  TitleAppBar({super.key, this.title = ""});
  final title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomTitle(
          title: title,
        ));
  }

  Size get preferredSize => Size(SizeConfig.screenWidth, 60);
}
