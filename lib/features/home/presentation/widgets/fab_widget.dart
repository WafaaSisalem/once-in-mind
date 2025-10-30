import 'package:flutter/material.dart';

class FabWidget extends StatelessWidget {
  const FabWidget({
    super.key,
    required this.onPressed,
    this.heroTag,
    this.icon = Icons.add_rounded,
  });

  final Function() onPressed;
  final IconData icon;
  final String? heroTag;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor,
            offset: Offset(0, 0),
            blurRadius: 6,
          ),
        ],
      ),
      child: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          backgroundColor: theme.primaryColor,
          shape: CircleBorder(),
          heroTag: heroTag,
          onPressed: onPressed,
          child: Icon(icon, size: 30, color: Colors.white), //
        ),
      ),
    );
  }
}
