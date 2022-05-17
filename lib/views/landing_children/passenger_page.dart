import 'package:flutter/material.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/views/landing_children/location_picker_page.dart';

class PassengerPage extends StatefulWidget {
  const PassengerPage({Key? key}) : super(key: key);

  @override
  State<PassengerPage> createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  @override
  Widget build(BuildContext context) {
    return LocationPickerPage(
      onChooseDestination: (DestinationModel value) {
        Navigator.pushNamed(
          context,
          '/nearest_driver_list_page',
          arguments: value,
        );
      },
    );
  }
}
