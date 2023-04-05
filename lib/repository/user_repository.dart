import 'dart:convert';

import 'package:sae/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  UserRepository{

  saveUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("User",json.encode(user));
  }

  Future<User> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return User.fromJson(json.decode(sharedPreferences.getString("User")!));
  }
}

