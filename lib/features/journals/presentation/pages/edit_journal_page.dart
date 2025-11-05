import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_picker_button.dart';
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(),
            const SizedBox(width: 70),
            DatePickerButton(
              initialDate: date,
              onChangeDate: (newDate) {
                date = newDate;
              },
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
