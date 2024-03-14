import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? idUser;
  Future<void> saveSession(int val, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    return value;
  }

  // Future getSessionIdUser() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.getInt("value");
  //   pref.getString("id");
  //   return value;
  // }

  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();
