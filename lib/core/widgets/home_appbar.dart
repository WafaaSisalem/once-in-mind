import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({
    super.key,
    required this.titlePlace,
    required this.actions,
  });
  final Widget titlePlace;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titlePlace,
      actions: actions,

      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(58);
}
