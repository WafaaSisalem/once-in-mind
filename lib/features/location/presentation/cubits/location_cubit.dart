import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onceinmind/core/utils/address.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';
import 'package:onceinmind/features/location/presentation/cubits/location_states.dart';

class LocationCubit extends Cubit<LocationStates> {
  LocationCubit() : super(LocationInitial());

  Position? currentPosition;
  double? celsius;
  String formatedCelsius = '';

  // Get GPS location
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        emit(
          LocationError(
            'Location service is disabled. Go to settings to enable it.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            LocationError(
              'Location permission denied. Go to settings to enable it.',
            ),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(
          LocationError(
            'Location permission permanently denied. Go to settings to enable it.',
          ),
        );
        return;
      }

      currentPosition =
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Location fetch timed out'),
          );

      await _updateLocationModel(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
    } catch (e) {
      emit(LocationError('Error getting location: $e'));
    }
  }

  // Set manually selected location (from Map)
  Future<void> setSelectedLocation(double lat, double lng) async {
    await _updateLocationModel(lat, lng);
  }

  Future<void> _updateLocationModel(double lat, double lng) async {
    try {
      String address = await _getAddressFromCoordinates(lat, lng);
      LocationModel selectedLocation = LocationModel(lat, lng, address);
      emit(LocationLoaded(selectedLocation));
    } catch (e) {
      emit(LocationError('Error updating location: $e'));
    }
  }

  Future<String> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return 'Address not found';
      final p = placemarks.first;
      return formattedAdderss(p);
    } catch (e) {
      return 'error getting address';
    }
  }

  setLocation(LocationModel? location) {
    if (location != null) {
      if (location.address.isNotEmpty) {
        emit(LocationLoaded(location));
      }
    } else {
      emit(LocationInitial());
    }
  }

  void clearLocation() {
    emit(LocationInitial());
  }
}
