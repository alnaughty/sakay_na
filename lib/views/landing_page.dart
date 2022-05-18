import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/widget.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/firebase_account_info_model.dart';
import 'package:sakayna/services/API/auth.dart';
import 'package:sakayna/services/API/booking_api.dart';
import 'package:sakayna/services/data_cacher.dart';
import 'package:sakayna/services/driver_info_service.dart';
import 'package:sakayna/services/firebase_messaging_service.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';
import 'package:sakayna/view_model.dart/firebase_driver_info_vm.dart';
import 'package:sakayna/views/landing_children/driver_page.dart';
import 'package:sakayna/views/landing_children/location_picker_page.dart';
import 'package:sakayna/views/landing_children/passenger_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final AuthAPI _auth = AuthAPI.instance;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );
  final DataCacher _cacher = DataCacher.instance;
  LocationPermission? permission;
  final FirebaseMessagingService _fcmServ = FirebaseMessagingService();
  final BookingApi _api = BookingApi();
  final CurrentBookingVm _curB = CurrentBookingVm.instance;
  bool isFetching = true;
  getUserDetails() async {
    try {
      setState(() {
        isFetching = true;
      });
      await _auth.getuserDetails().then((value) async {
        if (value != null) {
          await _api.getCurrentBooking().then((value) {
            _curB.populate(value);
          });
          setState(() {
            loggedUser = value;
          });
        } else {
          Navigator.pushReplacementNamed(context, "/login_page");
        }
      }).whenComplete(() => setState(() => isFetching = false));
    } catch (e) {
      setState(() {
        isFetching = false;
      });
      print("ERROR FETCHING DETAILS : $e");
      rethrow;
    }
  }

  final FirestoreAccountDetailsService _drServ =
      FirestoreAccountDetailsService.instance;
  final FirestoreAccountInfoVM _vm = FirestoreAccountInfoVM.instance;
  void checkPermission() async {
    LocationPermission currentPerm = await Geolocator.checkPermission();
    if (currentPerm == LocationPermission.unableToDetermine ||
        currentPerm == LocationPermission.denied ||
        currentPerm == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      checkPermission();
    } else {
      if (permission != LocationPermission.denied ||
          permission != LocationPermission.deniedForever) {
        getUserDetails();
        _drServ.subscribe();
        positionStream =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((Position pos) async {
          if (mounted) {
            setState(() {
              currentPosition = pos;
            });
          } else {
            currentPosition = pos;
          }
          if (loggedUser != null) {
            try {
              FirestoreAccountInfoModel iamDriver = _vm.current!
                  .where((element) => element.id == loggedUser!.id)
                  .first;
              FirebaseFirestore.instance
                  .collection('account_geo_loc')
                  .doc(iamDriver.firebaseId)
                  .update({
                "latitude": pos.latitude,
                "longitude": pos.longitude,
              });
            } on StateError catch (e) {
              var dd = await FirebaseFirestore.instance
                  .collection('account_geo_loc')
                  .get();
              print("COLLECTION DATA : ${dd.docs}");
              if (dd.docs.isEmpty) {
                ///Create
                FirebaseFirestore.instance.collection('account_geo_loc').add({
                  "name":
                      "${loggedUser!.firstName} ${loggedUser!.middleName ?? ""} ${loggedUser!.lastName}",
                  "id": loggedUser!.id,
                  "latitude": pos.latitude,
                  "account_type": loggedUser!.accountType == null
                      ? 1
                      : int.parse(loggedUser!.accountType!),
                  "longitude": pos.longitude,
                });
              } else {
                for (var doc in dd.docs) {
                  if (doc.get('id') != loggedUser!.id) {
                    print("ACCOUNT TYPE: ${loggedUser!.accountType}");
                    FirebaseFirestore.instance
                        .collection('account_geo_loc')
                        .add({
                      "name":
                          "${loggedUser!.firstName} ${loggedUser!.middleName ?? ""} ${loggedUser!.lastName}",
                      "id": loggedUser!.id,
                      "latitude": pos.latitude,
                      "account_type": loggedUser!.accountType == null
                          ? 1
                          : int.parse(loggedUser!.accountType ?? "0"),
                      "longitude": pos.longitude,
                    });
                  }
                }
              }
              print("STATE ERROR : $e");
            }
          }
        });
      } else {
        Fluttertoast.showToast(msg: "PLEASE ENABLE LOCATION SERVICE");
        // _cacher.removeToken();
        Navigator.pushReplacementNamed(context, "/login_page");
      }
    }
  }

  @override
  void initState() {
    checkPermission();
    _fcmServ.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Sakay Na!"),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset("assets/images/icon.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cacher.removeToken();
              Navigator.pushReplacementNamed(context, "/login_page");
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: loggedUser == null && isFetching == false
            ? Container(
                color: Colors.grey.shade100,
                child: const Center(
                  child: Text("UNABLE TO FETCH DATA,"),
                ),
              )
            : loggedUser == null
                ? loadingWidget
                : currentPosition != null
                    ? Column(
                        children: [
                          Expanded(
                            child: loggedUser!.accountType! == "0"
                                ? const DriverPage()
                                : const PassengerPage(),
                          )
                        ],
                      )
                    : Container(),
      ),
    );
  }
}
