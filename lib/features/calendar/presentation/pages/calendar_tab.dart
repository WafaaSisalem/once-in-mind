import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:onceinmind/core/widgets/loading_widget.dart';
import 'package:onceinmind/features/calendar/presentation/widgets/static_calendar.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/journal_item.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      builder: (context, state) {
        if (state is JournalsLoading) {
          return const LoadingWidget();
        } else if (state is JournalsLoaded) {
          final journals = state.journals;

          final events = EventList<Event>(events: {});
          for (final journal in journals) {
            final date = DateTime(
              journal.date.year,
              journal.date.month,
              journal.date.day,
            );
            events.add(date, Event(date: date, title: journal.id));
          }

          final dayJournals = journals
              .where(
                (j) =>
                    j.date.year == selectedDate.year &&
                    j.date.month == selectedDate.month &&
                    j.date.day == selectedDate.day,
              )
              .toList();

          return Column(
            children: [
              StaticCalendar(
                eventList: events,
                onDayPressed: (date) {
                  setState(() => selectedDate = date);
                },
              ),
              Expanded(
                child: dayJournals.isEmpty
                    ? Center(child: FallbackWidget.noCalendarEntries())
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        padding: const EdgeInsets.all(16),
                        itemCount: dayJournals.length,
                        itemBuilder: (context, index) =>
                            JournalItem(journal: dayJournals[index]),
                      ),
              ),
            ],
          );
        } else if (state is JournalsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
