import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/network.dart';
import 'package:sakayna/models/user_model.dart';
import 'package:sakayna/services/data_cacher.dart';

class AuthAPI {
  AuthAPI._singleton();
  static final AuthAPI _instance = AuthAPI._singleton();
  static AuthAPI get instance => _instance;
  final DataCacher _cacher = DataCacher.instance;
  Future<bool> login({required String email, required String password}) async {
    try {
      return await http.post(
        Uri.parse("${Network.apiHost}/login"),
        body: {
          "email": email,
          "password": password,
        },
      ).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          accessToken = data['access_token'];
          _cacher.saveToken(accessToken);
          return true;
        }
        if (data['message'] != null) {
          Fluttertoast.showToast(msg: data['message']);
        }
        return false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error has occurred, please contact the administrator");
      return false;
    }
  }

  Future<bool> register({required Map body}) async {
    try {
      return await http
          .post(Uri.parse("${Network.apiHost}/register"), body: body)
          .then((response) {
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode == 200) {
          accessToken = data['access_token'];
          _cacher.saveToken(accessToken);
          Fluttertoast.showToast(msg: "Registration Successful");
          return true;
        }
        if (data['message'] != null) {
          Fluttertoast.showToast(msg: data['message']);
        }
        Fluttertoast.showToast(msg: data['message']);
        return false;
      });
    } catch (e) {
      print("ERROR : $e");
      Fluttertoast.showToast(
          msg: "An error has occurred, please contact the administrator");
      return false;
    }
  }

  Future<UserModel?> getuserDetails() async {
    try {
      return await http
          .get(Uri.parse("${Network.apiHost}/get_user_details"), headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        print(response.statusCode);
        if (response.statusCode == 200) {
          final UserModel user = UserModel.fromJson(data['user']);
          return user;
        } else if (response.statusCode == 401) {
          _cacher.removeToken();
          return null;
        }
        if (data['message'] != null) {
          Fluttertoast.showToast(msg: data['message']);
        }
        return null;
      });
    } catch (e) {
      print("ERROR : $e");
      Fluttertoast.showToast(
          msg: "An error has occurred, please contact the administrator");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      Map body = {};
      if (fcmToken != null) {
        body.addAll({"token": fcmToken});
      }
      await http.post(
        Uri.parse("${Network.apiHost}/logout"),
        headers: {
          "accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        },
        body: body,
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error has occurred, please contact the administrator");
      return;
    }
  }
}
