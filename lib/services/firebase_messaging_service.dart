import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/services/API/booking_api.dart';
import 'package:sakayna/services/API/fcm_token_api.dart';
import 'package:sakayna/services/data_cacher.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';

class FirebaseMessagingService {
  static const serverToken =
      "AAAArsGEMLs:APA91bHzdoyBlvAzI2VOue7Ybavpf0DDwWgCUNflW76EF3AQ0rRXtNZS3u5stE-nuYr0q-bcpvuJbRtbHdUYVyXlOlp_xDhivL_88tbLROcmayS-X3xSh33uWnxSgY8EU3M2ssxgUOo8";
  // final RecipeHelper _recipeHelper = RecipeHelper();
  final FCMTokenApi _api = FCMTokenApi();
  final BookingApi _booking = BookingApi();
  final CurrentBookingVm _bookingVm = CurrentBookingVm.instance;
  void init(context) async {
    // final bool isDarkMode = NeumorphicTheme.isUsingDark(context);
    // final Color baseColor = isDarkMode ?
    // final Color baseColor = NeumorphicTheme.baseColor(context);
    final Color accent = Colors.grey.shade200;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // ignore: avoid_print

      print("MESSAGE DATA: ${message.data}");
      bool isAdd = json.encode(message.data).contains("add");
      if (isAdd) {
        await _booking.getCurrentBooking().then((value) {
          _bookingVm.populate(value);
        });
      } else {
        _bookingVm.populate(null);
      }
      // Map? notificationData = message.data.isEmpty
      //     ? null
      //     : json.decode(json.encode(message.data['notificaton_data']));
      // if (notificationData != null) {
      //   if (notificationData['type'] == "add") {
      //     print("MAG ADD NA!");
      //   } else {
      //     print("UPSDATE!");
      //   }
      // }
      // if (message.data['notification_data'].toString().contains("add")) {
      // await _booking.getCurrentBooking().then((value) {
      //   _bookingVm.populate(value);
      // });
      // } else if (message.data['notification_data']
      //     .toString()
      //     .contains("finish")) {
      //   _bookingVm.populate(null);
      // }
      // print(
      //     "IMAGE: ${Platform.isIOS ? message.notification!.apple?.imageUrl : message.notification!.android?.imageUrl}");
      // String? image = Platform.isIOS
      //     ? message.notification!.apple?.imageUrl
      //     : message.notification!.android?.imageUrl;
      Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              // icon: Container(
              //   margin: const EdgeInsets.only(left: 10),
              //   child: Image.asset(
              //     "assets/images/app_logo.png",
              //   ),
              // ),
              // mainButton: image == null
              //     ? null
              //     : Image.network("${Network.url}/storage/images/compressed/$image",
              //         height: 60),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              forwardAnimationCurve: Curves.decelerate,
              reverseAnimationCurve: Curves.easeOut,
              isDismissible: true,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(10)),
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.grey.shade300,
              duration: const Duration(seconds: 5),
              titleText: Text(
                message.notification!.title ?? "Sakay na",
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              dismissDirection: FlushbarDismissDirection.HORIZONTAL,
              messageText: Text("${message.notification!.body}"))
          .show(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // ignore: avoid_print
      print("ON OPENED MESSAGE : ${message.data}");
      bool isAdd = json.encode(message.data).contains("add");
      if (isAdd) {
        await _booking.getCurrentBooking().then((value) {
          _bookingVm.populate(value);
        });
      } else {
        _bookingVm.populate(null);
      }
    });
    await _firebaseMessaging.getToken().then((val) async {
      DataCacher _cacher = DataCacher.instance;
      print("${Platform.isAndroid ? "ANDROID" : "IOS"} Token : $val");
      if (val != null) {
        fcmToken = val;
        _api.addToken(val);
      }
    });
  }
}
