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
import 'package:onceinmind/features/location/presentation/cubits/location_cubit.dart';
import 'package:onceinmind/features/location/presentation/cubits/location_states.dart';
import 'package:onceinmind/features/location/presentation/cubits/weather_cubit.dart';

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
  String temperature = '';
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
      temperature = widget.journal!.weather;
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
    if (isEditing) {
      context.read<LocationCubit>().setLocation(widget.journal!.location);
      context.read<WeatherCubit>().setWeather(widget.journal!.weather);
    }
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [
            CustomBackButton(
              onPressed: () {
                if (!isEditing) {
                  if (controller.text.trim() == '' && attachments.isEmpty) {
                    clearDataAndPop();

                    return;
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                          dialogType: DialogType.discard,

                          onOkPressed: (value) {
                            clearDataAndPop();
                            context.pop();
                            //or navigate to home context.go
                          },
                        );
                      },
                    );
                  }
                } else {
                  //لازم تشوفي اذا فش تغييرات خلص بيعمل بوب اذا في تغييرات بيطلعلو متاكد بدك تتجاهلهم
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogWidget(
                        dialogType: DialogType.discard,

                        onOkPressed: (value) {
                          clearDataAndPop();
                          context.pop();
                          //or navigate to home context.go
                        },
                      );
                    },
                  );
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
        child: Column(
          children: [
            BlocBuilder<LocationCubit, LocationStates>(
              builder: (context, state) => Align(
                alignment: Alignment.centerLeft,
                child: state is LocationLoading
                    ? SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : state is LocationLoaded
                    ? Text(
                        state.location.address,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
            Expanded(child: WritingArea(controller: controller)),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: CustomExpandableFab(
        onWeatherLoaded: (temperature) {
          this.temperature = temperature;
        },
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
        showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
              dialogType: DialogType.delete,
              onOkPressed: (value) {
                context.read<JournalsCubit>().deleteJournal(
                  widget.journal!.id,
                  widget.journal!.imagesUrls.map((e) => e.toString()).toList(),
                );
                // Navigator.pop until we reach the home page not the previous page or context.go home
                clearDataAndPop();
                context.pop();
                context.pop();
              },
            );
          },
        );

        return;
      }
      final baseJournal = widget.journal!.copyWith(
        content: content,
        date: date,
        status: status.name,
        location: location,
        weather: temperature,
      );

      final updatedJournal = await cubit.updateJournalWithAttachments(
        journal: baseJournal,
        attachments: attachments,
        originalRemotePaths: originalRemotePaths,
      );
      if (mounted) {
        context.read<LocationCubit>().clearLocation();
        context.read<WeatherCubit>().clearWeather();
        clearDataAndPop(popedValue: updatedJournal);
      }
    } else {
      if (content.isEmpty) {
        clearDataAndPop();

        return;
      }
      context.read<JournalsCubit>().saveJournal(
        content: content,
        date: date,
        status: status,
        attachments: attachments,
        location: location,
        weather: temperature,
      );

      clearDataAndPop();
    }
  }

  clearDataAndPop({dynamic popedValue}) {
    context.read<LocationCubit>().clearLocation();
    context.read<WeatherCubit>().clearWeather();
    context.pop(popedValue);
  }
}
