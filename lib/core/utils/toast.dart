import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

showMyToast({
  required String message,
  required BuildContext context,
  position = StyledToastPosition.bottom,
}) {
  return showToast(
    message,
    context: context,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    position: position,
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 4),
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
    backgroundColor: Colors.grey[300],
    textStyle: Theme.of(context).textTheme.titleSmall,
  );
}
