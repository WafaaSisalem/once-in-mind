import 'package:flutter/material.dart';

floatingCalendarWidget({
  required BuildContext context,
  required DateTime initialDate,
  bool showTime = true,
}) async {
  ThemeData theme = Theme.of(context);
  var value = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1950),
    lastDate: DateTime(2050),
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: ColorScheme.light(
          primary: theme.primaryColor,
          secondary: theme.colorScheme.secondary,
        ),
      ),
      child: child!,
    ),
  ).then((value) => value);

  //if the user did not select date dont show time
  TimeOfDay? time;
  if (value != null && showTime) {
    time = await timePickerWidget(context, value);
  }
  time ??= TimeOfDay.now();
  DateTime dateTime = value ?? DateTime.now();

  return dateTime.copyWith(hour: time.hour, minute: time.minute);
}

timePickerWidget(BuildContext context, DateTime initialDate) async {
  var value =
      await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              secondary: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: child!,
        ),
      ).then((value) {
        return value;
      });
  return value;
}
