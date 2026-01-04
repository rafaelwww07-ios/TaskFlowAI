part of 'auth_bloc.dart';

/// Auth events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check authentication status
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// Sign in with email and password
class SignInWithEmail extends AuthEvent {
  const SignInWithEmail({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Sign up with email and password
class SignUpWithEmail extends AuthEvent {
  const SignUpWithEmail({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [email, password, name];
}

/// Sign in anonymously (demo mode)
class SignInAnonymously extends AuthEvent {
  const SignInAnonymously();
}

/// Sign out
class SignOut extends AuthEvent {
  const SignOut();
}

