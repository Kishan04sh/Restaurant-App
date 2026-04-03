import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final AppSession session;

  const AppConfig({
    super.key,
    required this.session,
    required super.child,
  });

  /// ================= GLOBAL ACCESS =================
  static AppConfig of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<AppConfig>();

    if (result == null) {
      throw FlutterError('AppConfig not found in widget tree');
    }

    return result;
  }

  /// ================= HEADERS =================
  Map<String, String> get headers => {
    "Accept": "application/json",
    "Accept-Charset": "UTF-8",
    "Content-Type": "application/json",
    "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Firefox/127.0",
    if (session.auth != null && session.auth!.isNotEmpty)
      "auth": session.auth!,
    if (session.sessionToken != null &&
        session.sessionToken!.isNotEmpty)
      "sessiontoken": session.sessionToken!,
  };

  @override
  bool updateShouldNotify(covariant AppConfig oldWidget) {
    return oldWidget.session.auth != session.auth ||
        oldWidget.session.sessionToken != session.sessionToken;
  }
}

/// ================= SESSION MODEL =================
class AppSession {
  final String? auth;
  final String? sessionToken;

  const AppSession({
    this.auth,
    this.sessionToken,
  });

  bool get isLoggedIn =>
      auth != null &&
          auth!.isNotEmpty &&
          sessionToken != null &&
          sessionToken!.isNotEmpty;
}