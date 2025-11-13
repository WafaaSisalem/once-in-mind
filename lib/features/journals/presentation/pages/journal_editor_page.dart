import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/widgets/custom_back_button.dart';
import 'package:onceinmind/core/widgets/dialog_widget.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/data/models/journal_attachment.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_expandable_fab.dart';
import 'package:onceinmind/features/journals/presentation/widgets/date_picker_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/writing_area.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';

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
  List<JournalAttachment> attachments = [];
  List<String> originalRemotePaths = [];
  bool isEditing = false;
  LocationModel? location;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.journal != null) {
      location = widget.journal!.location;
      isEditing = true;
      controller = TextEditingController(text: widget.journal!.content);
      date = widget.journal!.date;
      status = stringToStatus(widget.journal!.status);
      final journal = widget.journal!;
      final paths = journal.imagesUrls.map((e) => e.toString()).toList();
      originalRemotePaths = List<String>.from(paths);
      final signedUrls = journal.signedUrls ?? [];
      attachments = List.generate(
        paths.length,
        (index) => JournalAttachment.remote(
          storagePath: paths[index],
          signedUrl: index < signedUrls.length ? signedUrls[index] : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(
              onPressed: () {
                if (!isEditing) {
                  if (controller.text.trim() == '' && attachments.isEmpty) {
                    context.pop();
                    return;
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                          dialogType: DialogType.discard,
                          entryType: 'journal',
                          onOkPressed: (value) {
                            context.pop();
                            context.pop();
                            //or navigate to home context.go
                          },
                        );
                      },
                    );
                  }
                } else {
                  context.pop();
                }
              },
            ),
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
      floatingActionButton: CustomExpandableFab(
        onLocationPressed: (location) {
          this.location = location;
        },
        attachments: attachments,
        onImageSelected: (newAttachments) async {
          attachments = List<JournalAttachment>.from(newAttachments);
        },
        onStatusChanged: (status) {
          this.status = status;
        },
      ),
    );
  }

  void saveJournal() async {
    final content = controller.text.trim();

    if (isEditing) {
      final cubit = context.read<JournalsCubit>();

      if (content.isEmpty) {
        cubit.deleteJournal(widget.journal!.id);
        //TODO: show the delete dialog
        // Navigator.pop until we reach the home page not the previous page or context.go home
        context.pop();
        context.pop();

        return;
      }
      final baseJournal = widget.journal!.copyWith(
        content: content,
        date: date,
        status: status.name,
      );
      // if (baseJournal == widget.journal) {
      //   context.pop();
      //   return;
      // }
      final updatedJournal = await cubit.updateJournalWithAttachments(
        journal: baseJournal,
        attachments: attachments,
        originalRemotePaths: originalRemotePaths,
      );

      context.pop(updatedJournal);
    } else {
      if (content.isEmpty) {
        context.pop();

        return;
      }
      context.read<JournalsCubit>().saveJournal(
        content: content,
        date: date,
        status: status,
        attachments: attachments,
        location: location,
      );

      context.pop();
    }
  }
}
