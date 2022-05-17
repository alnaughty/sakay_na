import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreAccountInfoModel {
  final int id;
  final LatLng location;
  final String name;
  final String firebaseId;
  final int accountType;
  const FirestoreAccountInfoModel({
    required this.id,
    required this.location,
    required this.name,
    required this.firebaseId,
    required this.accountType,
  });
  factory FirestoreAccountInfoModel.fromJson(Map json) =>
      FirestoreAccountInfoModel(
        id: int.parse(json['id'].toString()),
        location: LatLng(
          double.parse(json['lat'].toString()),
          double.parse(json['long'].toString()),
        ),
        name: json['name'],
        firebaseId: json['firebase_id'],
        accountType: json['account_type'],
      );
  Map<String, Object> toJSON() => {
        "id": id,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "name": name,
        "firebase_id": firebaseId,
        "account_type": accountType.toString(),
      };
}
