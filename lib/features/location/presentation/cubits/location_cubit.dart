// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:onceinmind/features/location/data/models/location_model.dart';
// import 'package:onceinmind/features/location/presentation/cubits/location_states.dart';
// import 'package:weather/weather.dart';

// class LocationCubit extends Cubit<LocationStates> {
//   LocationCubit() : super(LocationInitial());

//   Position? currentPosition;
//   double? celsius;
//   String formatedCelsius = '';

//   Future<void> getLocation() async {
//     emit(LocationLoading());

//     try {
//       // 1) هل خدمة الموقع مفعّلة؟
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // نطلب من المستخدم تفعيل الخدمة (لا نطلب فتح الإعدادات هنا تلقائياً)
//         emit(LocationError('Location service is disabled. Please enable it.'));
//         return;
//       }

//       // 2) تحقق واطلب الإذن
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           emit(LocationError('Location permission denied.'));
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         emit(LocationError(
//             'Location permission permanently denied. Open app settings to enable it.'));
//         return;
//       }

//       // 3) احصل على الموقع (مع timeout)
//       emit(LocationLoading());
//       currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       ).timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           emit(LocationError('Can\'t catch any location, try again!'));
//           // رجّع خطأ عن طريق رمي استثناء أو null؛ هنا نرمي استثناء لانه await يحتاج قيمة
//           throw TimeoutException('getCurrentPosition timed out');
//         },
//       );

//       double lat = currentPosition!.latitude;
//       double lng = currentPosition!.longitude;

//       // 4) تحويل الإحداثيات إلى عنوان
//       String address = await getAddress(lat, lng);
//       if (address == 'Address not found' || address == 'error getting address') {
//         emit(LocationError('Can\'t catch any location, try again!'));
//         return;
//       }

//       final locationModel = LocationModel(lat, lng, address);
//       emit(LocationLoaded(locationModel));

//       // 5) جلب الطقس بعدين
//       await getCurrentWeather(lat, lng);
//     } catch (e) {
//       // طباعة الخطأ للمطوّر + إظهار حالة خطأ
//       print('LocationCubit.getLocation Error: $e');
//       if (state is! LocationError) {
//         emit(LocationError('Error getting location: $e'));
//       }
//     }
//   }

//   // جلب الطقس الآن يستقبل lat,lng بدل الاعتماد على currentLocation من حزمة أخرى
//   Future<void> getCurrentWeather(double lat, double lng) async {
//     try {
//       WeatherFactory wf = WeatherFactory("3117871fcf5c5c7027946e61b433701e");
//       Weather w = await wf.currentWeatherByLocation(lat, lng);
//       celsius = w.temperature?.celsius;
//       formatedCelsius = '${w.temperature?.celsius?.round()}\u2103';
//       print(formatedCelsius);
//     } catch (e) {
//       print('getCurrentWeather Error: $e');
//       // ليست حالة قاتلة للـ UI — يمكن إبقاء الحالة كما هي أو إصدار حالة خطأ منفصلة إذا أردت
//     }
//   }

//   // تحويل الإحداثيات إلى عنوان باستخدام geocoding
//   Future<String> getAddress(double lat, double lng) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         final placemark = placemarks.first;

//         String subLocality =
//             (placemark.subLocality != null && placemark.subLocality!.isNotEmpty)
//                 ? '${placemark.subLocality},'
//                 : '';
//         String thoroughfare =
//             (placemark.thoroughfare != null && placemark.thoroughfare!.isNotEmpty)
//                 ? '${placemark.thoroughfare},'
//                 : '';
//         String subThoroughfare =
//             (placemark.subThoroughfare != null && placemark.subThoroughfare!.isNotEmpty)
//                 ? '${placemark.subThoroughfare},'
//                 : '';
//         String postalCode =
//             (placemark.postalCode != null && placemark.postalCode!.isNotEmpty)
//                 ? '${placemark.postalCode},'
//                 : '';
//         String subAdministrativeArea =
//             (placemark.subAdministrativeArea != null &&
//                     placemark.subAdministrativeArea!.isNotEmpty)
//                 ? '${placemark.subAdministrativeArea},'
//                 : '';
//         String administrativeArea =
//             (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty)
//                 ? '${placemark.administrativeArea},'
//                 : '';
//         String country =
//             (placemark.country != null && placemark.country!.isNotEmpty) ? '${placemark.country}' : '';

//         final address =
//             '$subLocality $thoroughfare $subThoroughfare $postalCode $subAdministrativeArea $administrativeArea $country'
//                 .replaceAll(RegExp(r'\s+'), ' ')
//                 .trim();
//         return address.isEmpty ? 'Address not found' : address;
//       } else {
//         return 'Address not found';
//       }
//     } catch (e) {
//       print('getAddress Error: $e');
//       return 'error getting address';
//     }
//   }
// }
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';
import 'package:onceinmind/features/location/presentation/cubits/location_states.dart';
import 'package:weather/weather.dart';

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
      print('Selected Location: $address');
      await _updateWeather(lat, lng);
    } catch (e) {
      emit(LocationError('Error updating location: $e'));
    }
  }

  Future<String> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return 'Address not found';
      final p = placemarks.first;
      return [
        if (p.subLocality?.isNotEmpty ?? false) p.subLocality,
        if (p.thoroughfare?.isNotEmpty ?? false) p.thoroughfare,
        if (p.subThoroughfare?.isNotEmpty ?? false) p.subThoroughfare,
        if (p.postalCode?.isNotEmpty ?? false) p.postalCode,
        if (p.subAdministrativeArea?.isNotEmpty ?? false)
          p.subAdministrativeArea,
        if (p.administrativeArea?.isNotEmpty ?? false) p.administrativeArea,
        if (p.country?.isNotEmpty ?? false) p.country,
      ].join(', ');
    } catch (e) {
      return 'error getting address';
    }
  }

  Future<void> _updateWeather(double lat, double lng) async {
    try {
      WeatherFactory wf = WeatherFactory(dotenv.env['WEATHER_API_KEY']!);
      Weather w = await wf.currentWeatherByLocation(lat, lng);
      celsius = w.temperature?.celsius;
      formatedCelsius = '${w.temperature?.celsius?.round()}\u2103';
      print('Current Temperature: $formatedCelsius');
    } catch (_) {
      formatedCelsius = '';
    }
  }

  void clearLocation() {
    emit(LocationInitial());
  }
}
