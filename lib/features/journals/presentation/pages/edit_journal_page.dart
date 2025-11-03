import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class EditJournalPage extends StatefulWidget {
  final JournalModel journal;
  const EditJournalPage({super.key, required this.journal});

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController controller;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.journal.content);
    date = widget.journal.date;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(),
            const SizedBox(width: 70),
            InkWell(
              onTap: () async {
                final newDate = await _pickDate(context, date);
                if (newDate != null) {
                  setState(() {
                    date = newDate;
                  });
                }
              },
              child: Container(
                height: 23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    const SizedBox(width: 5),
                    Container(height: 15, width: 1, color: Colors.grey[200]),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.check_rounded,
                size: 28,
                color: Colors.white,
              ),
              onPressed: _saveChanges,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: WritingArea(controller: controller),
      ),
    );
  }

  Future<DateTime?> _pickDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return pickedDate;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  void _saveChanges() {
    final content = controller.text.trim();
    if (content.isEmpty) return;

    final updatedJournal = widget.journal.copyWith(
      content: content,
      date: date,
    );

    final cubit = context.read<JournalsCubit>();
    cubit.updateJournal(updatedJournal);

    context.pop(updatedJournal);
  }
}
