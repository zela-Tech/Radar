import 'package:shared_preferences/shared_preferences.dart';

// the sesion helper wraps SharedPreferences.
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

}