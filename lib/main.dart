import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/app_config.dart';
import 'config/dependency_injector.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/secure_storage_service.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi dari file `.env` sebelum menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env
  await dotenv.load(fileName: '.env');

  // Periksa konfigurasi
  if (!AppConfig.isConfigured()) {
    Logger.warning('Konfigurasi .env tidak lengkap. Periksa file .env Anda.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Latihan 2: dependency disediakan ke seluruh widget tree
    return DependencyProvider(
      injector: DependencyInjector(),
      child: MaterialApp(
        title: 'Secure Storage & HTTP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Dari Pertemuan 5: halaman awal ditentukan oleh keberadaan token.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SecureStorageService().hasToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
