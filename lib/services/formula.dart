import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vmath;

double calculateDistanceHaversine({required LatLng src, required LatLng tar}) {
  const double R = 6371000;

  final double phi1 = vmath.radians(src.latitude);
  final double phi2 = vmath.radians(tar.latitude);
  final double delta_phi = vmath.radians(tar.latitude - src.latitude);
  final double delta_lambda = vmath.radians(tar.longitude - src.longitude);
  final double a =
      double.parse(math.pow(math.sin(delta_phi / 2.0), 2).toString()) +
          math.cos(phi2) * math.pow(math.sin(delta_lambda / 2.0), 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final double km = (R * c) / 1000;
  print("DISTANCE IN KM : $km");
  return km;
}
