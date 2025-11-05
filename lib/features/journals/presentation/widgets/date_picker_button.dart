import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/utils/date_utils.dart';

class DatePickerButton extends StatefulWidget {
  final Function(DateTime newDate) onChangeDate;
  final DateTime? initialDate;
  const DatePickerButton({
    super.key,
    required this.onChangeDate,
    this.initialDate,
  });

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late DateTime initialDate;
  @override
  void initState() {
    initialDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        DateTime dateTime = await floatingCalendarWidget(
          context: context,
          initialDate: initialDate,
        );

        setState(() {
          initialDate = dateTime;
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
                DateFormat('MMMM d, y').format(initialDate),
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
}
