/// Kumpulan fungsi validasi dan sanitasi input.
///
/// Class ini menyediakan method statis untuk memvalidasi input
/// pengguna dan membersihkan karakter berbahaya.
class Validators {
  /// Memvalidasi format email.
  ///
  /// Mengembalikan `true` jika [email] memiliki format yang valid.
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  /// Memvalidasi bahwa [value] tidak kosong.
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Memvalidasi panjang [value] antara [min] dan [max].
  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Membersihkan input dari karakter berbahaya.
  ///
  /// Mengganti karakter `&`, `<`, `>`, `"`, dan `'` dengan HTML entities
  /// untuk mencegah XSS.
  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .trim();
  }

  /// Memvalidasi teks. Mengembalikan pesan error, atau `null` jika valid.
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (!hasValidLength(value, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Memvalidasi email. Mengembalikan pesan error, atau `null` jika valid.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // ---------------- Latihan 3: validasi yang lebih ketat ----------------

  /// Memvalidasi nomor telepon: hanya angka, 10-13 digit.
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10,13}$').hasMatch(phone);
  }

  /// Memvalidasi URL: harus diawali `http://` atau `https://`.
  static bool isValidUrl(String url) {
    return RegExp(r'^https?://\S+$').hasMatch(url);
  }

  /// Memvalidasi nomor telepon. Mengembalikan pesan error atau `null`.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!isValidPhone(value.trim())) {
      return 'Nomor telepon hanya boleh angka (10-13 digit)';
    }
    return null;
  }

  /// Memvalidasi URL. Mengembalikan pesan error atau `null`.
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    if (!isValidUrl(value.trim())) {
      return 'URL harus diawali http:// atau https://';
    }
    return null;
  }

  /// Memvalidasi password: minimal 8 karakter, mengandung huruf kapital,
  /// angka, dan simbol. Mengembalikan pesan error atau `null`.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka';
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
      return 'Password harus mengandung simbol';
    }
    return null;
  }
}
