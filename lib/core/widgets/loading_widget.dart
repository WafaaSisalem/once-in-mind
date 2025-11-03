import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.flickr(
        leftDotColor: Theme.of(context).primaryColor,
        rightDotColor: Theme.of(context).colorScheme.secondary,
        size: 60,
      ),
    );
  }
}
