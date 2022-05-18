import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sakayna/models/booking_data_model.dart';
import 'package:sakayna/models/destination_model.dart';
import 'package:sakayna/models/user_model.dart';
import 'package:sakayna/splash_screen_page.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';
import 'package:sakayna/views/landing_children/nearest_driver_list_children/book_driver_page.dart';
import 'package:sakayna/views/landing_children/nearest_driver_list_page.dart';
import 'package:sakayna/views/landing_page.dart';
import 'package:sakayna/views/login_page.dart';

import '../views/register_page.dart';

String? accessToken;
String? fcmToken;
UserModel? loggedUser;
Position? currentPosition;
late StreamSubscription<Position?> positionStream;
BookingDataModel? currentBooking;
final RegExp numberRegexp = RegExp(r"/^\d+$/");
// ignore: prefer_function_declarations_over_variables
Route<dynamic>? Function(RouteSettings)? get routeSettings => (settings) {
      switch (settings.name) {
        case "/landing_page":
          return PageTransition(
            child: const LandingPage(),
            type: PageTransitionType.leftToRightWithFade,
          );
        case "/settings_page":
          return PageTransition(
            child: Container(),
            type: PageTransitionType.rightToLeftWithFade,
          );
        case "/login_page":
          return PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.scale,
            alignment: Alignment.center,
          );
        case "/register_page":
          return PageTransition(
            child: const RegisterPage(),
            type: PageTransitionType.scale,
            alignment: Alignment.center,
          );
        case "/nearest_driver_list_page":
          DestinationModel model = settings.arguments as DestinationModel;
          return PageTransition(
            child: NearestDriverListPage(
              destination: model,
            ),
            type: PageTransitionType.scale,
            alignment: Alignment.center,
          );
        case "/book_driver_page":
          final List args = settings.arguments as List;
          final DestinationModel destination = args[0] as DestinationModel;
          final int driverId = args[1] as int;
          print("DRIVER ID : $driverId");
          final CurrentBookingVm _curr = CurrentBookingVm.instance;
          return PageTransition(
            child: BookDriverPage(
              destination: destination,
              driverId: driverId,
              hasBooked: _curr.current != null,
            ),
            type: PageTransitionType.rightToLeftWithFade,
          );
        default:
          return PageTransition(
            child: const SplashScreenPage(),
            type: PageTransitionType.rightToLeftWithFade,
          );
      }
    };

final RegExp emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final RegExp phoneRegExp = RegExp(r"^(09|\+639)\d{9}$");
