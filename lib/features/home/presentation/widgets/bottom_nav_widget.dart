import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            color: Colors.grey[200]!, //
            offset: Offset(0, -4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      child: BottomAppBar(
        color: Colors.white, //
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
            : Colors.white, //
        child: TextButton(
          onPressed: () {
            widget.onTap(index);
            selectedIndex = index;
            setState(() {});
          },
          child: SvgPicture.asset(
            widget.svgs[index],
            colorFilter: ColorFilter.mode(
              selectedIndex == index ? Colors.white : theme.primaryColor, //
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
