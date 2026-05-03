import 'package:flutter_template/core/auth/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

class SupabaseAuthRepository implements AuthRepository {
  const SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<AuthUser?> currentUser() async {
    return _mapUser(_client.auth.currentUser);
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map(
      (event) => _mapUser(event.session?.user),
    );
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut();
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthUser(id: user.id, email: user.email);
  }
}
