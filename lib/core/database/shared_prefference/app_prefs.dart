import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearAll() async {
    final seenOnboarding = _prefs.getBool('seenOnboarding') ?? false;
    // ✅ Preserve all profile pictures keyed by userId
    // so photos survive logout and reappear on next login
    final allKeys = _prefs.getKeys();
    final pictureEntries = <String, String>{};
    for (final key in allKeys) {
      if (key.startsWith('profilePicture_')) {
        pictureEntries[key] = _prefs.getString(key) ?? '';
      }
    }
    await _prefs.clear();
    await _prefs.setBool('seenOnboarding', seenOnboarding);
    // Restore all saved pictures
    for (final entry in pictureEntries.entries) {
      if (entry.value.isNotEmpty) {
        await _prefs.setString(entry.key, entry.value);
      }
    }
  }

  // ── Onboarding ──────────────────────────────────────────────────
  static bool get seenOnboarding => _prefs.getBool('seenOnboarding') ?? false;
  static Future<void> setSeenOnboarding() =>
      _prefs.setBool('seenOnboarding', true);

  // ── Token ────────────────────────────────────────────────────────
  static String? get token => _prefs.getString('token');
  static Future<void> setToken(String token) =>
      _prefs.setString('token', token);
  static Future<void> clearToken() => _prefs.remove('token');

  // ── User ID ──────────────────────────────────────────────────────
  static const String _userIdKey = 'userId';
  static Future<void> saveUserId(String id) async =>
      await _prefs.setString(_userIdKey, id);
  static String? get userId => _prefs.getString(_userIdKey);

  // ── User Name ────────────────────────────────────────────────────
  static String? get userName => _prefs.getString('userName');
  static Future<void> saveUserName(String name) =>
      _prefs.setString('userName', name);

  // ── User Role ────────────────────────────────────────────────────
  static String? get userRole => _prefs.getString('userRole');
  static Future<void> saveUserRole(String role) =>
      _prefs.setString('userRole', role);

  // ── Profile Picture — keyed by userId so each user has their own ─
  // ✅ Saves as profilePicture_{userId} so it survives logout
  static Future<void> saveProfilePicture(String url) async {
    final id = userId;
    if (id != null && id.isNotEmpty) {
      await _prefs.setString('profilePicture_$id', url);
    }
    // Also save generic key for current session
    await _prefs.setString('profilePictureUrl', url);
  }

  static String? get profilePictureUrl {
    // Try user-specific key first
    final id = userId;
    if (id != null && id.isNotEmpty) {
      final specific = _prefs.getString('profilePicture_$id');
      if (specific != null && specific.isNotEmpty) return specific;
    }
    return _prefs.getString('profilePictureUrl');
  }
}