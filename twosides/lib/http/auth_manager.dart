import 'dart:developer';

class AuthenticationTokenManager {
  /// No token storage on web when using HttpOnly cookies

  /// Called after successful login
  static Future<void> onLogin() async {
    // Optional: mark session as authenticated in memory
  }

  /// Called on logout
  static Future<void> onLogout() async {
    // Optional: clear client-side session state
  }

  /// Client-side auth state check
  /// (best-effort only; server is source of truth)
  static Future<bool> isAuthenticated() async {
    return true; // server decides via cookie presence
  }
}