import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('isValidEmail', () {
    test('menerima email yang valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('nama.belakang@kampus.ac.id'), isTrue);
    });

    test('menolak email tanpa @', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
    });

    test('menolak email tanpa domain/titik', () {
      expect(Validators.isValidEmail('user@example'), isFalse);
    });

    test('menolak email tanpa nama pengguna', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
    });

    test('menolak email dengan @ ganda dan string kosong', () {
      expect(Validators.isValidEmail('user@@example.com'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('sanitize', () {
    test('mengganti tag script dengan HTML entities', () {
      expect(
        Validators.sanitize('<script>alert(1)</script>'),
        '&lt;script&gt;alert(1)&lt;/script&gt;',
      );
    });

    test('mengganti tanda kutip ganda dan tunggal', () {
      expect(Validators.sanitize('"a" \'b\''), '&quot;a&quot; &#39;b&#39;');
    });

    test('mengganti ampersand lebih dulu agar tidak ter-escape dua kali', () {
      expect(Validators.sanitize('a & b'), 'a &amp; b');
      expect(Validators.sanitize('<'), '&lt;');
    });

    test('menghapus spasi di awal dan akhir', () {
      expect(Validators.sanitize('  halo  '), 'halo');
    });

    test('tidak mengubah teks aman', () {
      expect(Validators.sanitize('Dominic 123'), 'Dominic 123');
    });
  });

  group('validateText', () {
    test('menolak null dan string kosong/spasi', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
      expect(Validators.validateText('   '), 'Field tidak boleh kosong');
    });

    test('memakai nama field pada pesan error', () {
      expect(
        Validators.validateText('', fieldName: 'Nama'),
        'Nama tidak boleh kosong',
      );
    });

    test('menerima teks dengan panjang valid', () {
      expect(Validators.validateText('abc'), isNull);
      expect(Validators.validateText('a' * 100), isNull);
    });

    test('menolak teks lebih dari 100 karakter', () {
      expect(
        Validators.validateText('a' * 101),
        'Field harus antara 1-100 karakter',
      );
    });

    test('menolak teks kurang dari minLength', () {
      expect(
        Validators.validateText('ab', minLength: 3),
        'Field harus antara 3-100 karakter',
      );
    });
  });

  group('Latihan 3: phone, url, password', () {
    test('validatePhone', () {
      expect(Validators.validatePhone('081234567890'), isNull);
      expect(
        Validators.validatePhone('12345'),
        'Nomor telepon hanya boleh angka (10-13 digit)',
      );
      expect(
        Validators.validatePhone('0812-3456-7890'),
        'Nomor telepon hanya boleh angka (10-13 digit)',
      );
      expect(
        Validators.validatePhone('12345678901234'),
        'Nomor telepon hanya boleh angka (10-13 digit)',
      );
    });

    test('validateUrl', () {
      expect(Validators.validateUrl('https://example.com'), isNull);
      expect(Validators.validateUrl('http://example.com/a?b=1'), isNull);
      expect(
        Validators.validateUrl('ftp://example.com'),
        'URL harus diawali http:// atau https://',
      );
      expect(
        Validators.validateUrl('example.com'),
        'URL harus diawali http:// atau https://',
      );
    });

    test('validatePassword', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
      expect(
        Validators.validatePassword('Abc1!'),
        'Password minimal 8 karakter',
      );
      expect(
        Validators.validatePassword('abcdefg1!'),
        'Password harus mengandung huruf kapital',
      );
      expect(
        Validators.validatePassword('Abcdefgh!'),
        'Password harus mengandung angka',
      );
      expect(
        Validators.validatePassword('Abcdefg1'),
        'Password harus mengandung simbol',
      );
    });
  });
}
