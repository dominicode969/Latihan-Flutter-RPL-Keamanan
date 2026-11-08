import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Class ini menangani semua request HTTP ke API, termasuk
/// penanganan error, timeout, serta mendukung metode login dan post.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari API.
  Future<List<User>> getUsers({Duration? timeout}) async {
    final requestTimeout =
        timeout ?? Duration(seconds: AppConfig.timeoutSeconds);
    try {
      _logRequest('GET', '/users');
      final response = await _client
          .get(Uri.parse('$_baseUrl/users'), headers: _buildHeaders())
          .timeout(requestTimeout);
      _logResponse(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      // Pada Chrome (web), gagal koneksi dilempar sebagai ClientException
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Mengambil pengguna berdasarkan [id].
  Future<User> getUserById(int id) async {
    try {
      _logRequest('GET', '/users/$id');

      final response = await _client
          .get(Uri.parse('$_baseUrl/users/$id'), headers: _buildHeaders())
          .timeout(Duration(seconds: AppConfig.timeoutSeconds));

      _logResponse(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Mengambil daftar post dari API.
  Future<List<Post>> getPosts({Duration? timeout}) async {
    final requestTimeout =
        timeout ?? Duration(seconds: AppConfig.timeoutSeconds);
    try {
      _logRequest('GET', '/posts');
      final response = await _client
          .get(Uri.parse('$_baseUrl/posts'), headers: _buildHeaders())
          .timeout(requestTimeout);
      _logResponse(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Simulasi login untuk mendapatkan token (atau bisa diubah ke POST request nyata).
  Future<String> login(String email, String password) async {
    try {
      _logRequest('POST', '/login');
      // Jika menggunakan API nyata, Anda dapat melakukan:
      // final response = await _client.post(
      //   Uri.parse('$_baseUrl/login'),
      //   headers: _buildHeaders(),
      //   body: jsonEncode({'email': email, 'password': password}),
      // ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      await Future.delayed(const Duration(seconds: 1)); // Simulasi jeda network

      if (email.isNotEmpty && password.isNotEmpty) {
        final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
        Logger.info('Login berhasil');
        return token;
      } else {
        throw Exception('Email dan password tidak boleh kosong');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  /// Membangun header untuk request HTTP.
  Map<String, String> _buildHeaders() {
    return {'Content-Type': 'application/json', 'X-API-Key': AppConfig.apiKey};
  }

  /// Logging request yang aman (tidak mencetak token/API key).
  void _logRequest(String method, String endpoint) {
    Logger.info('[$method] $_baseUrl$endpoint');
  }

  /// Logging response yang aman (hanya status code).
  void _logResponse(int statusCode) {
    Logger.debug('Response status: $statusCode');
  }

  /// Menutup client.
  void dispose() {
    _client.close();
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}
