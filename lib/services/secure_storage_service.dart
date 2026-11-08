import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/logger.dart';

/// Service penyimpanan aman untuk data sensitif (token, PIN).
///
/// Memakai [Logger] sehingga tidak ada nilai sensitif yang tercetak.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  /// Menyimpan token.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    Logger.info('Token berhasil disimpan');
  }

  /// Membaca token, `null` jika belum ada.
  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    Logger.debug(token != null ? 'Token ditemukan' : 'Token tidak ditemukan');
    return token;
  }

  /// Menghapus token.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    Logger.info('Token berhasil dihapus');
  }

  /// Menyimpan PIN.
  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    Logger.info('PIN berhasil disimpan');
  }

  /// Membaca PIN, `null` jika belum ada.
  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  /// Menghapus semua data.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
    Logger.info('Semua data berhasil dihapus');
  }

  /// Memeriksa keberadaan token.
  Future<bool> hasToken() async {
    return await _storage.containsKey(key: _tokenKey);
  }
}
