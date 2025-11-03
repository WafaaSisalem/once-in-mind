import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_picker_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class AddJournalPage extends StatelessWidget {
  AddJournalPage({super.key});
  final TextEditingController controller = TextEditingController();
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(),
            SizedBox(width: 70),
            DatePickerButton(
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
              onPressed: () => saveJournal(context),
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
        child: WritingArea(controller: controller),
      ),
    );
  }

  void saveJournal(BuildContext context) {
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
}
