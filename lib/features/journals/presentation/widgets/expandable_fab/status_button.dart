import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';

class StatusButton extends StatefulWidget {
  final Function(Status status) onPressed;

  const StatusButton({super.key, required this.onPressed});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  Status status = Status.smile;

  @override
  Widget build(BuildContext context) {
    return CustomChildFab(
      heroTag: 'btn4',
      child: SizedBox(
        width: 22,
        height: 22,
        child: AppAssets.statusToSvg(status),
      ),
      onPressed: () {
        onStatusBtnPressed(context: context);
      },
    );
  }

  onStatusBtnPressed({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusItem(
                widget: AppAssets.svgHappy,
                onTap: () {
                  status = Status.happy;
                  widget.onPressed(status);
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgNormal,
                onTap: () {
                  status = Status.normal;
                  widget.onPressed(status);
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgAngry,
                onTap: () {
                  status = Status.angry;
                  widget.onPressed(status);
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgSad,
                onTap: () {
                  status = Status.sad;
                  widget.onPressed(status);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatusItem extends StatelessWidget {
  final Widget widget;
  final VoidCallback onTap;
  const StatusItem({super.key, required this.widget, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
          Navigator.pop(context);
        },
        child: SizedBox(width: 30, height: 30, child: widget),
      ),
    );
  }
}
