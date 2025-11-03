import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/app_assets.dart';

class FallbackWidget extends StatelessWidget {
  final String text;
  final Widget image;

  const FallbackWidget({super.key, required this.text, required this.image});
  FallbackWidget.noJouranl({super.key})
    : image = AppAssets.svgNoJournal,
      text = 'No journal entries';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        SizedBox(height: 20),
        Text(text, style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }
}
