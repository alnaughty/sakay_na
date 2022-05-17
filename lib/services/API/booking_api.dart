import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/network.dart';
import 'package:sakayna/models/booking_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:sakayna/view_model.dart/current_booking_vm.dart';

class BookingApi {
  final CurrentBookingVm _vm = CurrentBookingVm.instance;
  Future<BookingDataModel?> getCurrentBooking() async {
    try {
      return await http
          .get(Uri.parse("${Network.apiHost}/current_booking"), headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data['booking'] == null) return null;
          final BookingDataModel book =
              BookingDataModel.fromJson(data['booking']);
          return book;
        }
        Fluttertoast.showToast(msg: data['message']);
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> arrive(int id) async {
    try {
      await http.put(
        Uri.parse("${Network.apiHost}/update_current_booking"),
        headers: {
          "accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
        body: {
          "id": id.toString(),
        },
      ).then((response) async {
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Status updated");
          await getCurrentBooking().then((value) {
            _vm.populate(null);
          });
        }
        return;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "An error has occured!");
      return;
    }
  }
}
