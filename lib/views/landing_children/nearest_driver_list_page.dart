import 'package:flutter/material.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';
import 'package:sakayna/services/formula.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';

import 'package:sakayna/views/landing_children/nearest_driver_list_children/driver_info.dart';

class NearestDriverListPage extends StatefulWidget {
  const NearestDriverListPage({
    Key? key,
    required this.destination,
  }) : super(key: key);
  final DestinationModel destination;
  @override
  State<NearestDriverListPage> createState() => _NearestDriverListPageState();
}

class _NearestDriverListPageState extends State<NearestDriverListPage> {
  final FirestoreAccountInfoVM _vm = FirestoreAccountInfoVM.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of drivers"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<FirestoreAccountInfoModel>>(
        stream: _vm.stream$,
        builder: (_, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            final List<FirestoreAccountInfoModel> _nearestDrivers =
                snapshot.data!
                    .where((element) =>
                        element.id != loggedUser!.id &&
                        calculateDistanceHaversine(
                              src: widget.destination.coordinate,
                              tar: element.location,
                            ) <=
                            2)
                    .toList();
            if (_nearestDrivers.isEmpty) {
              return const Center(
                child: Text("NO ACTIVE DRIVERS ON THIS LOCATION"),
              );
            } else {
              return ListView.separated(
                itemBuilder: (_, index) => MaterialButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      isScrollControlled: true,
                      context: context,
                      builder: (
                        _,
                      ) =>
                          DriverInfo(
                        driverId: _nearestDrivers[index].id,
                        destination: widget.destination,
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.drive_eta,
                    ),
                    title: Text(
                      _nearestDrivers[index].name,
                    ),
                    subtitle: Text(_nearestDrivers[index].location.toString()),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (_, index) => const Divider(),
                itemCount: _nearestDrivers.length,
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
