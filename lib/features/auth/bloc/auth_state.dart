part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState._({required this.status, this.user, this.message});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  const AuthState.failure(String message)
    : this._(status: AuthStatus.failure, message: message);

  final AuthStatus status;
  final AuthUser? user;
  final String? message;

  @override
  List<Object?> get props => [status, user, message];
}
