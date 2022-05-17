import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_picker/map_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/models/booking_data_model.dart';
import 'package:sakayna/models/booking_model.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({Key? key, required this.onChooseDestination})
      : super(key: key);
  final ValueChanged<DestinationModel> onChooseDestination;
  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  final CurrentBookingVm _vm = CurrentBookingVm.instance;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
    zoom: 14.4746,
  );
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapPicker(
          child: GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            //  camera position
            initialCameraPosition: cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMoveStarted: () {
              // notify map is moving
              mapPickerController.mapMoving!();
              textController.text = "checking ...";
            },
            onCameraMove: (cameraPosition) {
              this.cameraPosition = cameraPosition;
            },
            onCameraIdle: () async {
              // notify map stopped moving
              mapPickerController.mapFinishedMoving!();
              //get address name from camera position
              List<Placemark> placemarks = await placemarkFromCoordinates(
                cameraPosition.target.latitude,
                cameraPosition.target.longitude,
              );

              // update the ui with the address
              textController.text =
                  '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
            },
          ),
          mapPickerController: mapPickerController,
          iconWidget: SvgPicture.asset(
            "assets/images/location_icon.svg",
            color: Palette.kToDark.shade200,
            width: 30,
            height: 30,
          ),
        ),
        StreamBuilder<BookingDataModel?>(
          stream: _vm.stream$,
          builder: (_, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: double.maxFinite,
                  onPressed: () {
                    Navigator.pushNamed(context, "/book_driver_page",
                        arguments: [
                          DestinationModel(
                            coordinate: snapshot.data!.passengerDest,
                            locationName: snapshot.data!.pickUpArea,
                          ),
                          snapshot.data!.driver!.id,
                        ]);
                  },
                  color: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Current Booking",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                        ),
                        title: Text(
                          snapshot.data!.pickUpArea,
                        ),
                        subtitle: Text(
                          "${snapshot.data!.passengerDest}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    "Choose Destination",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color(0xFFFFFFFF),
                      fontSize: 19,
                      // height: 19/19,
                    ),
                  ),
                  onPressed: () {
                    widget.onChooseDestination(DestinationModel(
                      coordinate: LatLng(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                      ),
                      locationName: textController.text,
                    ));

                    // print(
                    //     "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                    // print("Address: ${textController.text}");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Palette.kToDark.shade200),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
