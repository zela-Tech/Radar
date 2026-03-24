import 'package:shared_preferences/shared_preferences.dart';

// the sesion helper wraps SharedPreferences.ex.logied in user d, darkmode, notfication togle
class SessionHelper {
  static const _keyUserId = 'user_id';

  // ── ---------------------------Auth ─────────────────────────────────────
  static Future<void> saveUserId(int id) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_keyUserId, id);
  }

  static Future<int?> getUserId() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_keyUserId);
  }

  static Future<bool> isLoggedIn() async {
    final id = await getUserId();
    return id != null;
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyUserId);

  }
  // ------------------Onborading-----------------------------------------------------
  static Future<void> setOnboardingDone() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyOnboardingDone, true);
  }

  static Future<bool> isOnboardingDone() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyOnboardingDone) ?? false;
  }

  //settings
  
}