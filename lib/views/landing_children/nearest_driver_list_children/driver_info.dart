import 'package:flutter/material.dart';
import 'package:sakayna/global/network.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/user_model.dart';
import 'package:sakayna/services/API/driver_api.dart';

class DriverInfo extends StatefulWidget {
  const DriverInfo({
    Key? key,
    required this.driverId,
    required this.destination,
  }) : super(key: key);
  final int driverId;
  final DestinationModel destination;
  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  UserModel? driverData;
  bool isFetching = true;
  final DriverApi _api = DriverApi.instance;
  Future<void> getDriverInfo() async {
    setState(() {
      isFetching = true;
    });
    await _api.details(widget.driverId).then((value) {
      setState(() {
        driverData = value;
      });
    }).whenComplete(() => setState(() => isFetching = false));
  }

  void init() async {
    await getDriverInfo();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.grey.shade100,
          ),
          width: double.maxFinite,
          height: driverData != null
              ? driverData!.hasBooking
                  ? 100
                  : 150
              : 150,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: isFetching && driverData == null
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Palette.kToDark),
                    ),
                  )
                : !isFetching && driverData == null
                    ? const Center(
                        child: Text("Couldn't load driver details"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: driverData!.avatarUrl == null
                                          ? Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const FittedBox(
                                                child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(Icons.person)),
                                              ),
                                            )
                                          : Image.network(
                                              "${Network.domain}/${driverData!.avatarUrl}"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${driverData!.firstName} ${driverData!.middleName ?? ""} ${driverData!.lastName}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Palette.kToDark.shade100,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  driverData!.mobileNumber),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    driverData!.isAccountVerified
                                        ? Icons.verified_user
                                        : Icons.close,
                                    color: driverData!.isAccountVerified
                                        ? Colors.green
                                        : Colors.red,
                                  )
                                ],
                              ),
                            ),
                            if (!driverData!.hasBooking) ...{
                              SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(null);
                                    Navigator.of(context).pop(null);
                                    Navigator.pushNamed(
                                        context, "/book_driver_page",
                                        arguments: [
                                          widget.destination,
                                          widget.driverId,
                                        ]);
                                  },
                                  child: const Text("BOOK THIS DRIVER"),
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
