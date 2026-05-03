enum AuthBackend {
  none,
  supabase;

  static AuthBackend fromName(String value) {
    return AuthBackend.values.firstWhere(
      (backend) => backend.name == value,
      orElse: () => AuthBackend.none,
    );
  }
}

class AppConfig {
  const AppConfig({
    required this.authBackend,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.apiBaseUrl,
  });

  factory AppConfig.fromEnvironment() {
    return AppConfig(
      authBackend: AuthBackend.fromName(
        const String.fromEnvironment('AUTH_BACKEND', defaultValue: 'none'),
      ),
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    );
  }

  final AuthBackend authBackend;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String apiBaseUrl;

  bool get hasSupabaseConfig {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
