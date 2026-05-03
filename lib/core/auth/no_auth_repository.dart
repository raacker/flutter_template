import 'package:flutter_template/core/auth/auth_repository.dart';

class NoAuthRepository implements AuthRepository {
  const NoAuthRepository();

  @override
  Future<AuthUser?> currentUser() async => const AuthUser.anonymous();

  @override
  Stream<AuthUser?> authStateChanges() {
    return Stream.value(const AuthUser.anonymous());
  }

  @override
  Future<void> signOut() async {}
}
