import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/models/booking_data_model.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/services/API/booking_api.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';

class CustomMap extends StatelessWidget {
  CustomMap({
    Key? key,
    required this.destination,
    required this.driverLoc,
    this.isDriver = false,
  }) : super(key: key);
  final bool isDriver;
  final LatLng driverLoc;
  final DestinationModel destination;
  static final BookingApi _booking = BookingApi();
  static final CurrentBookingVm _curr = CurrentBookingVm.instance;
  final _controller = Completer<GoogleMapController>();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          //  camera position
          initialCameraPosition: cameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMoveStarted: () {},
          onCameraMove: (cameraPosition) {
            this.cameraPosition = cameraPosition;
          },
          markers: {
            Marker(
              markerId: const MarkerId("me"),
              infoWindow: const InfoWindow(
                title: "My Location",
              ),
              position:
                  LatLng(currentPosition!.latitude, currentPosition!.longitude),
            ),
            if (!isDriver) ...{
              Marker(
                infoWindow: const InfoWindow(
                  title: "Driver Location",
                ),
                markerId: const MarkerId("driver"),
                position: driverLoc,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose),
              ),
            },
            Marker(
              markerId: const MarkerId("destination"),
              infoWindow: const InfoWindow(
                title: "Destination",
              ),
              position: destination.coordinate,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          },
        ),
        if (!isDriver) ...{
          StreamBuilder<BookingDataModel?>(
            stream: _curr.stream$,
            builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: LayoutBuilder(builder: (context, constraint) {
                        return SizedBox(
                          width: constraint.maxWidth,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _booking.arrive(snapshot.data!.id);
                            },
                            child: const Center(
                              child: Text("ARRIVE"),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                : Container(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(builder: (context, constraint) {
                return SizedBox(
                  width: constraint.maxWidth,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Center(
                      child: Text(
                        "CLOSE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        }
      ],
    );
  }
}
