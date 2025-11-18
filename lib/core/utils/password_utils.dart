import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:onceinmind/core/utils/toast.dart';

passwordEmptyToast(context) {
  showMyToast(
    position: StyledToastPosition.top,

    message: 'Password can not be empty!',
    context: context,
  );
}

wrongPasswordToast(context) {
  showMyToast(
    position: StyledToastPosition.top,

    message: 'Wrong Password!',
    context: context,
  );
}
