import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_expandable_fab.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_picker_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/status_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';
import 'package:onceinmind/services/media/supabase_storage_service.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final TextEditingController controller = TextEditingController();
  Status status = Status.smile;
  DateTime date = DateTime.now();
  List<File> selectedFiles = [];

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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: CustomExpandableFab(
        onImageSelected: (files) async {
          selectedFiles = files;
        },
        onStatusChanged: (status) {
          this.status = status;
        },
      ),
    );
  }

  void saveJournal(BuildContext context) async {
    final content = controller.text.trim();
    if (content.isEmpty) return;

    context.read<JournalsCubit>().saveJournal(
      content: content,
      date: date,
      status: status,
      files: selectedFiles,
    );

    context.pop();
    // final cubit = context.read<JournalsCubit>();

    // final userId = context.read<AuthCubit>().getCurrentUser().uid;

    // List<String> imagePaths = [];
    // if (selectedFiles.isNotEmpty) {
    //   final storageService = SupabaseStorageService();
    //   imagePaths = await storageService.uploadImageAndGetPaths(
    //     selectedFiles,
    //     userId,
    //   );
    // }
    // final content = controller.text.trim();
    // if (content.isEmpty) return;
    // final journal = JournalModel(
    //   id: DateTime.now().toString(), // استخدام الوقت كـ ID
    //   content: content,
    //   date: date,
    //   imagesUrls: imagePaths,
    //   isLocked: false,
    //   location: null,
    //   status: status.name,
    // );

    // await cubit.addJournal(journal);
    // if (context.mounted) context.pop();
  }
}
