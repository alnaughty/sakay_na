import 'package:shared_preferences/shared_preferences.dart';

class DataCacher {
  DataCacher._singleton();
  static final DataCacher _instance = DataCacher._singleton();
  static DataCacher get instance => _instance;
  late final SharedPreferences _sharedPreferences;
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getToken() {
    String? token = _sharedPreferences.getString("token");
    return token;
  }

  saveToken(String? tok) {
    if (tok != null) {
      _sharedPreferences.setString("token", tok);
    }
  }

  void removeToken() {
    _sharedPreferences.remove("token");
  }
}
