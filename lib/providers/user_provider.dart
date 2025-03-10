import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sahai/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> setUser(UserModel user) async {
    _user = user;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('email', user.email!);
    await prefs.setString('userType', user.userType);
  }

  Future<void> clearUser() async {
    _user = null;
    notifyListeners(); // Add this to trigger UI update
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('uid'),
      prefs.remove('email'),
      prefs.remove('userType'),
    ]);
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    final userType = prefs.getString('userType');

    if (uid == null || userType == null) {
      _user = null;
      return;
    }

    _user = UserModel(
      uid: uid,
      email: prefs.getString('email') ?? '', // Default value
      userType: userType,
    );
  }
}
