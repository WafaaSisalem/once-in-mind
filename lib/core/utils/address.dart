import 'package:geocoding/geocoding.dart';

formattedAdderss(Placemark p) {
  return [
    if (p.subLocality?.isNotEmpty ?? false) p.subLocality,
    if (p.thoroughfare?.isNotEmpty ?? false) p.thoroughfare,
    if (p.subThoroughfare?.isNotEmpty ?? false) p.subThoroughfare,
    if (p.postalCode?.isNotEmpty ?? false) p.postalCode,
    if (p.subAdministrativeArea?.isNotEmpty ?? false) p.subAdministrativeArea,
    if (p.administrativeArea?.isNotEmpty ?? false) p.administrativeArea,
    if (p.country?.isNotEmpty ?? false) p.country,
  ].join(', ').trim();
}
