import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/network.dart';

class FCMTokenApi {
  Future<void> addToken(String token) async {
    try {
      await http.post(Uri.parse("${Network.apiHost}/fcms_add"), headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }, body: {
        "token": token,
      }).then((response) {
        // var data = json.decode(response.body);
        print("FCM DATA");
      });
    } catch (e) {
      print("FCM TOKEN ERROR! $e");
      return;
    }
  }
}
