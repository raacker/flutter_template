import 'package:equatable/equatable.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> currentUser();

  Stream<AuthUser?> authStateChanges();

  Future<void> signOut();
}

class AuthUser extends Equatable {
  const AuthUser({required this.id, this.email});

  const AuthUser.anonymous() : id = 'anonymous', email = null;

  final String id;
  final String? email;

  @override
  List<Object?> get props => [id, email];
}
