import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/utils/address.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? mapController;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(27.6602292, 85.308027),
  );
  LatLng startLocation = const LatLng(27.6602292, 85.308027);
  String formatedAddress = "Location Name:";
  late double lat;
  late double lng;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    lat = cameraPosition.target.latitude;
    lng = cameraPosition.target.longitude;
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        formatedAddress = formattedAdderss(p);
        print('Address: $formatedAddress');
      } else {
        formatedAddress = 'Address not found';
      }
    } catch (_) {
      formatedAddress = 'error getting address';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        actions: [],
        titlePlace: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 30,
                color: AppColors.white,
              ),
              onPressed: () => context.pop(),
            ),
            Text(
              'Pick a Place',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: startLocation,
              zoom: 2,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (pos) => cameraPosition = pos,
            onCameraIdle: _updateAddress,
          ),
          Center(child: AppAssets.svgFlagPin),
          Positioned(
            bottom: 100,
            left: 15,
            right: 15,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    formatedAddress,
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  dense: true,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            right: 15,
            child: FabWidget(
              onPressed: () {
                if (formatedAddress != 'Address not found' &&
                    formatedAddress != 'error getting address') {
                  context.pop(LocationModel(lat, lng, formatedAddress));
                } else {
                  context.pop();
                }
              },
              icon: Icons.check_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
