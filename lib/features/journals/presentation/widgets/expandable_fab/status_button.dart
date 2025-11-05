import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';

enum Status { angry, happy, sad, normal, smile }

class StatusButton extends StatefulWidget {
  const StatusButton({super.key});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  Status status = Status.smile;

  @override
  Widget build(BuildContext context) {
    return CustomChildFab(
      heroTag: 'btn4',
      child: switch (status) {
        Status.angry => AppAssets.svgAngry,
        Status.happy => AppAssets.svgHappy,
        Status.sad => AppAssets.svgSad,
        Status.normal => AppAssets.svgNormal,
        Status.smile => AppAssets.svgSmile,
      },
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
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgNormal,
                onTap: () {
                  status = Status.normal;
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgAngry,
                onTap: () {
                  status = Status.angry;
                  setState(() {});
                },
              ),
              StatusItem(
                widget: AppAssets.svgSad,
                onTap: () {
                  status = Status.sad;
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
