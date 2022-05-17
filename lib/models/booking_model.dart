import 'package:sakayna/models/destination_model.dart';

class BookingModel {
  final DestinationModel dest;
  final int driverId;
  const BookingModel({
    required this.dest,
    required this.driverId,
  });
}
