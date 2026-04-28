import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _accessTokenKey    = 'access_token';
  static const _refreshTokenKey   = 'refresh_token';
  static const _hasSeenWelcomeKey = 'has_seen_welcome';

  final SharedPreferences prefs;
  LocalStorageService({required this.prefs});

  // ── Tokens ────────────────────────────────────────────────────────────────
  Future<void> saveTokens(String access, String refresh) async {
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
  }

  String? getAccessToken()  => prefs.getString(_accessTokenKey);
  String? getRefreshToken() => prefs.getString(_refreshTokenKey);

  Future<void> clearTokens() async {
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  bool get isLoggedIn {
    final t = getAccessToken();
    return t != null && t.isNotEmpty;
  }

  // ── Welcome screen ────────────────────────────────────────────────────────
  /// Retourne true si l'utilisateur a déjà vu le WelcomeScreen.
  Future<bool> hasSeenWelcome() async {
    return prefs.getBool(_hasSeenWelcomeKey) ?? false;
  }

  /// Marque le WelcomeScreen comme vu (ne plus jamais le montrer).
  Future<void> setHasSeenWelcome() async {
    await prefs.setBool(_hasSeenWelcomeKey, true);
  }

  /// Reset (utile pour les tests ou logout total)
  Future<void> clearAll() async {
    await prefs.clear();
  }
}
