import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Menyediakan instance service dan repository untuk seluruh aplikasi.
///
/// [ApiService] dibuat sekali saja (singleton) dan dipakai bersama oleh
/// semua repository. Repository diekspos sebagai abstraksi.
class DependencyInjector {
  DependencyInjector._internal();

  static final DependencyInjector _instance = DependencyInjector._internal();

  /// Mengembalikan instance tunggal [DependencyInjector].
  factory DependencyInjector() => _instance;

  /// Instance tunggal [ApiService].
  late final ApiService apiService = ApiService();

  /// Repository pengguna.
  late final UserRepository userRepository = UserRepositoryImpl(
    apiService: apiService,
  );

  /// Repository post.
  late final PostRepository postRepository = PostRepositoryImpl(
    apiService: apiService,
  );
}

/// InheritedWidget yang menyediakan [DependencyInjector] ke widget tree.
class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Dipakai di `build()`: mendaftarkan widget sebagai dependent.
  static DependencyInjector of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DependencyProvider>();
    assert(provider != null, 'DependencyProvider tidak ditemukan di context');
    return provider!.injector;
  }

  /// Dipakai di `initState()` atau event handler: tanpa dependent.
  static DependencyInjector read(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<DependencyProvider>();
    assert(provider != null, 'DependencyProvider tidak ditemukan di context');
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}
