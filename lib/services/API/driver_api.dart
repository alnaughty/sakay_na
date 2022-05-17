import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/network.dart';
import 'package:sakayna/models/user_model.dart';

import 'package:http/http.dart' as http;
import 'package:sakayna/services/API/booking_api.dart';
import 'package:sakayna/view_model.dart/current_booking_vm.dart';

class DriverApi {
  DriverApi._singleton();
  static final DriverApi _instance = DriverApi._singleton();
  static DriverApi get instance => _instance;
  static final BookingApi _bookingApi = BookingApi();
  static final CurrentBookingVm _currB = CurrentBookingVm.instance;
  Future<UserModel?> details(int id) async {
    try {
      return await http.get(
        Uri.parse("${Network.apiHost}/get_driver_details/$id"),
        headers: {
          "accept": "application/json",
        },
      ).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          return UserModel.fromJson(data['driver']);
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> bookDriver({required Map body}) async {
    try {
      return await http
          .post(
        Uri.parse("${Network.apiHost}/booking/store"),
        headers: {
          "accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
        body: body,
      )
          .then((response) {
        var data = json.decode(response.body);
        print("BOOK DATA! $data");
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Booked successfully!");
          _bookingApi.getCurrentBooking().then((value) {
            _currB.populate(value);
          });
          return true;
        }
        Fluttertoast.showToast(msg: data['message']);
        return false;
      });
    } catch (e) {
      print("BOOKING ERROR : $e");
      return false;
    }
  }
}
