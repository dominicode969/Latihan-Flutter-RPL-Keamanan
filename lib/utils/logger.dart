import 'package:flutter/foundation.dart';

/// Level log yang tersedia.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur yang aman.
///
/// - Log hanya ditampilkan pada mode debug ([kDebugMode]).
/// - Nilai yang mengikuti kata kunci sensitif (token, password, pin,
///   api key, authorization, secret) otomatis disamarkan.
class Logger {
  static final RegExp _sensitive = RegExp(
    r'(token|password|pin|api[_-]?key|authorization|secret)(\s*[:=]\s*)(\S+)',
    caseSensitive: false,
  );

  /// Mencatat informasi untuk keperluan debugging.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Mencatat informasi umum jalannya aplikasi.
  static void info(String message) => _log(LogLevel.info, message);

  /// Mencatat kondisi yang perlu diperhatikan.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Mencatat error.
  static void error(String message) => _log(LogLevel.error, message);

  /// Menyamarkan nilai sensitif pada [message].
  static String redact(String message) {
    return message.replaceAllMapped(
      _sensitive,
      (m) => '${m[1]}${m[2]}[REDACTED]',
    );
  }

  static void _log(LogLevel level, String message) {
    if (!kDebugMode) return; // tidak ada log pada mode release
    debugPrint('[${level.name.toUpperCase()}] ${redact(message)}');
  }
}
