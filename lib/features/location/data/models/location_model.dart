import 'package:equatable/equatable.dart';
import 'package:onceinmind/core/constants/app_keys.dart';

class LocationModel extends Equatable {
  const LocationModel(this.lat, this.lng, this.address);
  final double lat;
  final double lng;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      AppKeys.latitude: lat,
      AppKeys.longitude: lng,
      AppKeys.address: address,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      map[AppKeys.latitude]?.toDouble() ?? 0.0,
      map[AppKeys.longitude]?.toDouble() ?? 0.0,
      map[AppKeys.address] ?? '',
    );
  }
  @override
  List<Object?> get props => [address];
}
