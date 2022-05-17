import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/global/widget.dart';
import 'package:sakayna/models/booking_model.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';
import 'package:sakayna/services/API/driver_api.dart';
import 'package:sakayna/services/formula.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';
import 'package:sakayna/views/custom_map.dart';

class BookDriverPage extends StatefulWidget {
  const BookDriverPage({
    Key? key,
    required this.destination,
    required this.driverId,
    required this.hasBooked,
  }) : super(key: key);
  final DestinationModel destination;
  final int driverId;
  final bool hasBooked;
  @override
  State<BookDriverPage> createState() => _BookDriverPageState();
}

class _BookDriverPageState extends State<BookDriverPage> {
  final FirestoreAccountInfoVM _vm = FirestoreAccountInfoVM.instance;
  final DriverApi _da = DriverApi.instance;
  bool allowable = false;
  bool isBooking = false;
  void book() async {
    try {
      setState(() {
        isBooking = true;
      });
      double dist = calculateDistanceHaversine(
        src: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        tar: widget.destination.coordinate,
      );
      await _da.bookDriver(
        body: {
          "latitude": widget.destination.coordinate.latitude.toString(),
          "longitude": widget.destination.coordinate.longitude.toString(),
          'picked_up_area': widget.destination.locationName,
          'fare': (10 * dist).toString(),
          'distance': dist.toString(),
          'total_passenger': "1",
          'driver_id': widget.driverId.toString(),
          'passenger_id': loggedUser!.id.toString(),
          'vehicle_id': "1",
        },
      ).then((val) {
        if (val) {
          setState(() {
            // currentBooking = BookingModel(
            //   dest: widget.destination,
            //   driverId: widget.driverId,
            // );
          });
        } else {
          print("ASDASAD");
        }
      }).whenComplete(() => setState(() => isBooking = false));
      setState(() {});
    } catch (e) {
      print("BOOKING ERROR! $e");
      setState(() {
        isBooking = false;
      });
    }
  }

  @override
  void initState() {
    if (!widget.hasBooked) {
      book();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            return allowable;
          },
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Container(
              child: StreamBuilder<List<FirestoreAccountInfoModel>>(
                stream: _vm.stream$,
                builder: (_, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    try {
                      FirestoreAccountInfoModel driver = snapshot.data!
                          .where((element) => element.id == widget.driverId)
                          .first;
                      return CustomMap(
                        destination: widget.destination,
                        driverLoc: driver.location,
                      );
                    } on StateError {
                      return const Center(
                        child: Text("DRIVER NOT FOUND"),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Palette.kToDark),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        isBooking ? loadingWidget : Container()
      ],
    );
  }
}
