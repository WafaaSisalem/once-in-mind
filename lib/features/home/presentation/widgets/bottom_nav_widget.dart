import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onceinmind/core/config/theme.dart';

class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({
    super.key,
    required this.svgs,
    required this.onTap,
    // required this.tabElements,
  });
  final List<String> svgs;
  final Function(int) onTap;

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int selectedIndex = 0;

  final placeHolder = const Opacity(
    opacity: 0,
    child: IconButton(onPressed: null, icon: Icon(Icons.no_cell)),
  );
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: 64,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200,
            offset: Offset(0, -4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      child: BottomAppBar(
        color: AppColors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tabElementMethod(theme, index: 0),
              tabElementMethod(theme, index: 1),
              placeHolder,
              placeHolder,
              tabElementMethod(theme, index: 2),
              tabElementMethod(theme, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox tabElementMethod(ThemeData theme, {required int index}) {
    return SizedBox(
      width: 65,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: selectedIndex == index
            ? theme.primaryColor
            : AppColors.white,
        child: TextButton(
          onPressed: () {
            widget.onTap(index);
            selectedIndex = index;
            setState(() {});
          },
          child: SvgPicture.asset(
            widget.svgs[index],
            color: selectedIndex == index
                ? AppColors.white
                : theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
