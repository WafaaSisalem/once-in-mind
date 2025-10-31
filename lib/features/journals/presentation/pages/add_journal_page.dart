import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final TextEditingController controller = TextEditingController();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 28,
                color: Colors.white, //
              ),
              onPressed: () {
                context.pop();
              },
            ),
            SizedBox(width: 70),
            InkWell(
              onTap: () async {
                DateTime dateTime = await floatingCalendarWidget(
                  context,
                  initialDate: date,
                );

                setState(() {
                  date = dateTime;
                });
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
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: saveJournal,
              icon: const Icon(
                Icons.check_rounded,
                size: 28,
                color: Colors.white, //
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: WritingArea(
          controller: controller,
          hintText: 'What happened with you today?',
        ),
      ),
    );
  }

  void saveJournal() {
    final content = controller.text.trim();
    if (content.isEmpty) return;

    final journal = JournalModel(
      id: DateTime.now().toString(), // استخدام الوقت كـ ID
      content: content,
      date: date,
      imagesUrls: [],
      isLocked: false,
      location: null,
    );

    final cubit = context.read<JournalsCubit>();
    cubit.addJournal(journal);

    context.pop();
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
          colorScheme: ColorScheme.light(primary: theme.primaryColor),
        ),
        child: child!,
      ),
    ).then((value) => value);
    TimeOfDay? time;
    if (value != null) {
      time = await timePickerWidget(context, initialTime: TimeOfDay.now());
    }
    time ??= TimeOfDay.now();
    DateTime dateTime = value != null
        ? DateTime(value.year, value.month, value.day, time.hour, time.minute)
        : DateTime.now();
    return dateTime;
  }

  timePickerWidget(BuildContext context, {required initialTime}) {
    var value = showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    ).then((value) => value);
    return value;
  }
}
