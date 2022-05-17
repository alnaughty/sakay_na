import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/global/widget.dart';
import 'package:sakayna/models/booking_data_model.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';
import 'package:sakayna/services/formula.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';
import 'package:sakayna/views/custom_map.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final FirestoreAccountInfoVM _vm = FirestoreAccountInfoVM.instance;
  final CurrentBookingVm _currentBooking = CurrentBookingVm.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BookingDataModel?>(
        stream: _currentBooking.stream$,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Booking".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const FittedBox(
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data!.passenger!.firstName} ${snapshot.data!.passenger!.middleName ?? ""} ${snapshot.data!.passenger!.lastName}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Palette.kToDark.shade300,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.passenger!.email,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Palette.kToDark.shade300,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.passenger!.mobileNumber,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Destination:",
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            snapshot.data!.pickUpArea,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: CustomMap(
                          isDriver: true,
                          destination: DestinationModel(
                            coordinate: snapshot.data!.passengerDest,
                            locationName: snapshot.data!.pickUpArea,
                          ),
                          driverLoc: LatLng(currentPosition!.latitude,
                              currentPosition!.longitude),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return StreamBuilder<List<FirestoreAccountInfoModel>>(
            stream: _vm.stream$,
            builder: (_, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                List<FirestoreAccountInfoModel> nearestPassengers =
                    snapshot.data!
                        .where(
                          (element) =>
                              element.id != loggedUser!.id &&
                              element.accountType == 1 &&
                              calculateDistanceHaversine(
                                    src: LatLng(currentPosition!.latitude,
                                        currentPosition!.longitude),
                                    tar: element.location,
                                  ) <=
                                  2,
                        )
                        .toList();
                if (nearestPassengers.isNotEmpty) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (_, index) => ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(Icons.person),
                      title: Text(
                        nearestPassengers[index].name,
                      ),
                    ),
                    separatorBuilder: (_, index) => const Divider(),
                    itemCount: nearestPassengers.length,
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No Passengers nearby"),
                    ),
                  );
                }
              }
              return Center(
                child: loadingWidget,
              );
            },
          );
        });
  }
}
