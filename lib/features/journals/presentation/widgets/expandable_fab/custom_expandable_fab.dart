import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:onceinmind/core/utils/status_enum.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
import 'package:onceinmind/features/journals/data/models/journal_attachment.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/gallery_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/location_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/status_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/weather_button.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';

class CustomExpandableFab extends StatelessWidget {
  final Function(Status status) onStatusChanged;
  final Function(List<JournalAttachment> attachments) onImageSelected;
  final List<JournalAttachment> attachments;
  final Function(LocationModel location) onLocationPressed;
  final Function(String temperature) onWeatherLoaded;
  final Status initialStatus;
  const CustomExpandableFab({
    super.key,
    required this.onStatusChanged,
    required this.onImageSelected,
    required this.attachments,
    required this.onLocationPressed,
    required this.onWeatherLoaded,
    required this.initialStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      initialOpen: true,
      openButtonBuilder: buildOpenBtn(), //Done
      closeButtonBuilder: buildCloseBtn(), // Done
      children: [
        GalleryButton(
          attachments: attachments,
          onPressed: (attachments) {
            onImageSelected(List<JournalAttachment>.from(attachments));
          },
        ),
        LocationButton(
          onPressed: (location) {
            onLocationPressed(location);
          },
        ),
        WeatherButton(
          onWeatherLoaded: (temperature) {
            onWeatherLoaded(temperature);
          },
        ),
        StatusButton(
          initialStatus: initialStatus,
          onPressed: (status) {
            onStatusChanged(status);
          },
        ),
      ],
    );
  }

  FloatingActionButtonBuilder buildCloseBtn() {
    return FloatingActionButtonBuilder(
      builder: (context, onPressed, progress) => FabWidget(
        heroTag: 'close btn',
        onPressed: onPressed!,
        icon: Icons.close_rounded,
      ),
      size: 20,
    );
  }

  FloatingActionButtonBuilder buildOpenBtn() {
    return FloatingActionButtonBuilder(
      builder: (context, onPressed, progress) =>
          FabWidget(onPressed: onPressed!, heroTag: 'open btn '),
      size: 20,
    );
  }
}
