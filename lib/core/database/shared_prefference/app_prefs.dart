import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Onboarding ─────────────────────────────
  static bool get seenOnboarding => _prefs.getBool('seenOnboarding') ?? false;
  static Future<void> setSeenOnboarding() => _prefs.setBool('seenOnboarding', true);

  // ── Token ───────────────────────────────────
  static String? get token => _prefs.getString('token');
  static Future<void> setToken(String token) => _prefs.setString('token', token);
  static Future<void> clearToken() => _prefs.remove('token');

  static const String _userIdKey = 'userId';

static Future<void> saveUserId(String id) async =>
    await _prefs.setString(_userIdKey, id);

static String? get userId => _prefs.getString(_userIdKey);
}