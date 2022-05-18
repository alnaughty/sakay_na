import 'package:flutter/cupertino.dart';
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
import 'package:sakayna/view_model.dart/current_booking_vm.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';
import 'package:sakayna/views/custom_map.dart';
import 'package:sakayna/views/landing_children/nearest_driver_list_children/booking_info.dart';

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
  late double dist = calculateDistanceHaversine(
    src: LatLng(currentPosition!.latitude, currentPosition!.longitude),
    tar: widget.destination.coordinate,
  );

  bool allowable = true;
  bool bookingIsShown = false;
  bool isBooking = false;
  double _fare = 0;
  int _passenger = 1;
  void showBookingDialog() {
    setState(() {
      bookingIsShown = true;
    });

    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        // totalFare();
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: Text('Hello Passenger!'.toUpperCase()),
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
                fontSize: 20,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.red,
                  )),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // book();
                    print("BOOKING FARE : $_fare");
                    print("NEW PASSENGER : $_passenger");
                    if (bookingIsShown) {
                      Navigator.of(context).pop(null);
                    }
                    book();
                  },
                  child: const Text(
                    "Book",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              content: SingleChildScrollView(
                child: BookingInfo(
                  distance: dist,
                  passengerCallback: (int pass) {
                    setState(() {
                      _passenger = pass;
                    });
                  },
                  fareCallback: (double fare) async {
                    print("NEW FARE: $fare");
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() {
                      _fare = double.parse(fare.toStringAsFixed(2));
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
    ).whenComplete(() {
      // setState(() {
      //   passengerAmount = 1;
      // });
      // _passenger.dispose();
    });
  }

  void book() async {
    try {
      setState(() {
        isBooking = true;
        bookingIsShown = false;
      });

      await _da.bookDriver(
        body: {
          "latitude": widget.destination.coordinate.latitude.toString(),
          "longitude": widget.destination.coordinate.longitude.toString(),
          'picked_up_area': widget.destination.locationName,
          'fare': _fare.toString(),
          'distance': dist.toString(),
          'total_passenger': _passenger.toString(),
          'driver_id': widget.driverId.toString(),
          'passenger_id': loggedUser!.id.toString(),
          'vehicle_id': "1",
        },
      ).then((val) {
        if (bookingIsShown) {
          Navigator.of(context).pop(null);
          setState(() {
            bookingIsShown = false;
          });
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
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        showBookingDialog();
      });
      // showBookingDialog();
      // book();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (bookingIsShown) {
              Navigator.of(context).pop(null);
            }
            Navigator.of(context).pop(null);
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
