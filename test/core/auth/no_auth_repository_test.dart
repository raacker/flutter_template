import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/auth/auth_repository.dart';
import 'package:flutter_template/core/auth/no_auth_repository.dart';

void main() {
  test('returns an authenticated anonymous user', () async {
    final repository = NoAuthRepository();

    expect(await repository.currentUser(), const AuthUser.anonymous());
    expect(repository.authStateChanges(), emits(const AuthUser.anonymous()));
  });
}
