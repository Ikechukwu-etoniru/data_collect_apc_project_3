import 'package:shared_preferences/shared_preferences.dart';

class ApiUrl {
  static const String baseUrl = 'https://apc-iccdatacenter.org/api/';
  static const String internetErrorString = 'Check your internet connection';
  static const String errorString = 'An error occured';

  static Future<Map<String, String>?> setTokenHeaders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  static Map<String, String> setHeaders() {
    return {"Content-type": "application/json", "Accept": "application/json"};
  }
}