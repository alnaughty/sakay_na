import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakayna/models/user_model.dart';

class BookingDataModel {
  final int id;
  final LatLng passengerDest;
  final String pickUpArea;
  final double fare;
  final double distance;
  final int totalPassengers;
  final bool isOnGoing;
  final UserModel? driver;
  final UserModel? passenger;

  const BookingDataModel({
    required this.id,
    required this.passengerDest,
    required this.pickUpArea,
    required this.fare,
    required this.distance,
    required this.totalPassengers,
    required this.isOnGoing,
    required this.driver,
    required this.passenger,
  });
  factory BookingDataModel.fromJson(Map<String, dynamic> json) =>
      BookingDataModel(
        distance: double.parse(json['distance'].toString()),
        driver:
            json['driver'] == null ? null : UserModel.fromJson(json['driver']),
        fare: double.parse(json['fare'].toString()),
        id: int.parse(json["id"].toString()),
        isOnGoing: int.parse(json["status"].toString()) == 1,
        passenger: json['passenger'] == null
            ? null
            : UserModel.fromJson(json['passenger']),
        passengerDest: LatLng(double.parse(json['latitude'].toString()),
            double.parse(json['longitude'].toString())),
        pickUpArea: json['picked_up_area'] ?? "UNDEFINED",
        totalPassengers: int.parse(json['total_passenger'].toString()),
      );
}
