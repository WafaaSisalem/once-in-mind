import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatefulWidget {
  final Function(DateTime newDate) onChangeDate;
  const DatePickerButton({super.key, required this.onChangeDate});

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        DateTime dateTime = await floatingCalendarWidget(
          context,
          initialDate: date,
        );

        setState(() {
          date = dateTime;
        });
        widget.onChangeDate(dateTime);
      },
      child: Container(
        height: 23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM d, y').format(date),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5),
              Container(height: 15, width: 1, color: Colors.grey[200]),
              Icon(
                Icons.keyboard_arrow_down,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  floatingCalendarWidget(BuildContext context, {required initialDate}) async {
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
    TimeOfDay? time;
    if (value != null) {
      time = await timePickerWidget(context);
    }
    time ??= TimeOfDay.now();
    DateTime dateTime = value ?? DateTime.now();
    // DateTime dateTime = value != null
    //     ? DateTime(value.year, value.month, value.day, time.hour, time.minute)
    //     : DateTime.now();
    return dateTime;
  }

  timePickerWidget(BuildContext context) {
    var value = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
            secondary: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: child!,
      ),
    ).then((value) => value);
    return value;
  }
}
