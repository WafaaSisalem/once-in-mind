import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:onceinmind/core/utils/date_utils.dart';

class StaticCalendar extends StatefulWidget {
  const StaticCalendar({
    super.key,
    required this.onDayPressed,
    required this.eventList,
  });
  final Function(DateTime) onDayPressed;
  final EventList<Event> eventList;
  @override
  State<StaticCalendar> createState() => _StaticCalendarState();
}

class _StaticCalendarState extends State<StaticCalendar> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print('build stateic');
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x26000000), //
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: SizedBox(width: double.infinity, height: 365),
          ),
          calendarCarouselWidget(theme),
        ],
      ),
    );
  }

  CalendarCarousel<Event> calendarCarouselWidget(ThemeData theme) {
    return CalendarCarousel(
      todayButtonColor: theme.colorScheme.secondary,
      showOnlyCurrentMonthDate: false,
      dayPadding: 4,
      targetDateTime: dateTime,
      showHeader: true,
      headerTitleTouchable: true,
      pageSnapping: true,
      markedDatesMap: widget.eventList,
      onHeaderTitlePressed: () async {
        var value = await floatingCalendarWidget(
          context: context,
          initialDate: dateTime,
          showTime: false,
        );
        dateTime = value;
        widget.onDayPressed(value);
        setState(() {});
      },
      height: 365,
      width: 290,
      iconColor: theme.colorScheme.secondary,
      weekdayTextStyle: calendarTextStyle(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.w600,
      ),
      selectedDateTime: dateTime,
      selectedDayButtonColor: theme.primaryColor,
      selectedDayTextStyle: calendarTextStyle(),
      daysTextStyle: calendarTextStyle(
        color: const Color(0xFFC192DA), //
      ),
      markedDateShowIcon: true,
      markedDateCustomShapeBorder: CircleBorder(
        side: BorderSide(color: theme.colorScheme.secondary),
      ),
      todayTextStyle: calendarTextStyle(),
      headerTextStyle: calendarTextStyle(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.w700,
      ),
      weekendTextStyle: calendarTextStyle(color: const Color(0xFFC192DA)),

      onDayPressed: (date, events) {
        dateTime = date;
        widget.onDayPressed(date);
        setState(() {});
      },
    );
  }
}

calendarTextStyle({color = Colors.white, fontWeight = FontWeight.w500}) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontSize: 15,
    fontFamily: 'Poppins',
  );
}
