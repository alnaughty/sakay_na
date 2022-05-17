import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationModel {
  final String? locationName;
  final LatLng coordinate;

  const DestinationModel({
    required this.coordinate,
    this.locationName,
  });
}
