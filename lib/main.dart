import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/auth/auth_repository.dart';
import 'package:flutter_template/core/auth/no_auth_repository.dart';
import 'package:flutter_template/core/auth/supabase_auth_repository.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final authRepository = await _createAuthRepository(config);

  runApp(App(authRepository: authRepository));
}

Future<AuthRepository> _createAuthRepository(AppConfig config) async {
  switch (config.authBackend) {
    case AuthBackend.none:
      return NoAuthRepository();
    case AuthBackend.supabase:
      if (!config.hasSupabaseConfig) {
        throw StateError(
          'SUPABASE_URL and SUPABASE_ANON_KEY are required when '
          'AUTH_BACKEND=supabase.',
        );
      }

      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseAnonKey,
      );

      return SupabaseAuthRepository(Supabase.instance.client);
  }
}
