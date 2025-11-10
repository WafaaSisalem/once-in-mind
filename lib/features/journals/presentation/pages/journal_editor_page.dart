import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_expandable_fab.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_picker_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';

class JournalEditorPage extends StatefulWidget {
  final JournalModel? journal;

  const JournalEditorPage({super.key, this.journal});

  @override
  State<JournalEditorPage> createState() => _JournalEditorPageState();
}

class _JournalEditorPageState extends State<JournalEditorPage> {
  TextEditingController controller = TextEditingController();
  Status status = Status.smile;
  DateTime date = DateTime.now();
  List<File> selectedFiles = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.journal != null) {
      controller = TextEditingController(text: widget.journal!.content);
      date = widget.journal!.date;
      status = stringToStatus(widget.journal!.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(),
            SizedBox(width: 70),
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
        child: WritingArea(controller: controller),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: CustomExpandableFab(
      //   onImageSelected: (files) async {
      //     selectedFiles = files;
      //   },
      //   onStatusChanged: (status) {
      //     this.status = status;
      //   },
      // ),
    );
  }

  void saveJournal() async {
    final content = controller.text.trim();
    if (content.isEmpty) {
      context.pop();

      return;
    }
    // update existing journal
    if (widget.journal != null) {
      final updatedJournal = widget.journal!.copyWith(
        content: content,
        date: date,
        status: status.name,
      );
      final cubit = context.read<JournalsCubit>();
      cubit.updateJournal(updatedJournal);

      context.pop(updatedJournal);
    } else {
      // add new journal
      context.read<JournalsCubit>().saveJournal(
        content: content,
        date: date,
        status: status,
        files: selectedFiles,
      );

      context.pop();
    }
  }
}
