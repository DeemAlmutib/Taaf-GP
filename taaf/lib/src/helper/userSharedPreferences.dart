
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
static SharedPreferences? _preferences;

   static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserID(String userID) async{
     await _preferences!.setString("userID", userID);
  }
  static String? getUserID() {
    return  _preferences!.getString("userID");
  }

   static Future deleteData()async{
    await _preferences!.remove("userID");
  }



}