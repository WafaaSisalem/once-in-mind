import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/loading_widget.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/journal_item.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  double lat = 0.0;
  double lng = 0.0;
  Set<Marker> markers = {};
  List<JournalModel> selectedLoc = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      builder: (context, state) {
        return state is JournalsLoaded
            ? Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: (controller) async {
                        markers = await getAllMarkers(state.journals);
                        setState(() {});
                        lat = markers.first.position.latitude;
                        lng = markers.first.position.longitude;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: LatLng(lat, lng), zoom: 7),
                          ),
                        );
                      },
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 2,
                      ),
                      markers: markers,
                    ),
                  ),
                  if (selectedLoc.isNotEmpty)
                    Expanded(
                      child: selectedLoc.isEmpty
                          ? Center(child: FallbackWidget.noJouranl())
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              padding: const EdgeInsets.all(16),
                              itemCount: selectedLoc.length,
                              itemBuilder: (context, index) =>
                                  JournalItem(journal: selectedLoc[index]),
                            ),
                    ),
                ],
              )
            : LoadingWidget();
      },
    );
  }

  Future<Set<Marker>> getAllMarkers(List<JournalModel> journals) async {
    List<JournalModel> allJournalsWithLocation = journals
        .where((journal) => journal.location!.address != '')
        .toList();
    final markerList = await Future.wait(
      allJournalsWithLocation.map((journal) async {
        return Marker(
          onTap: () {
            selectedLoc = context.read<JournalsCubit>().getJournalsByLocation(
              journal.location,
            );
            setState(() {});
          },
          icon: await getMarkerIcon(journal),
          markerId: MarkerId(journal.id),
          position: LatLng(journal.location!.lat, journal.location!.lng),
        );
      }).toList(),
    );

    return Set<Marker>.from(markerList);
  }

  getMarkerIcon(JournalModel journal) async {
    return await MarkerIcon.downloadResizePictureCircle(
      journal.imagesUrls.isNotEmpty
          ? journal.signedUrls![0]
          : AppAssets.urlPlaceholderImage,
      size: 150,
      addBorder: true,
      borderColor: Colors.white,
      borderSize: 15,
    );
  }
}
